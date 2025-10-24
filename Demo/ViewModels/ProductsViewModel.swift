

import Foundation

@Observable
final class ProductsViewModel {
    
    enum ViewState: Equatable {
        case empty
        case loading
        case loaded([Product])
        case error(APIError)
    }
    
    var viewState: ViewState = .loading
    var products: [Product] = []
    var searchText: String = ""
    var showAddToBagSheet: Bool = false
    var selectedProduct: Product? = nil
    
    // Configure URLSession with cache
    private var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        // Configure cache (10 MB memory, 50 MB disk)
        configuration.urlCache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024
        )
        
        // Cache policy: return cached data if available, otherwise fetch
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        print("DEBUG: URLCache configured: Memory=10MB, Disk=50MB")
        
        return URLSession(configuration: configuration)
    }()
    
    var categorizedProducts: [ProductCategory] {
        let grouped = Dictionary(grouping: filteredProducts, by: { $0.category })
        return grouped.map { ProductCategory(name: $0.key, products: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    var filteredProducts: [Product] {
        guard !searchText.isEmpty else { return products }
        
        return products.filter { product in
            product.title.localizedCaseInsensitiveContains(searchText) ||
            product.category.localizedCaseInsensitiveContains(searchText) ||
            product.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @MainActor
    func loadProducts() async {
        viewState = .loading
        
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            viewState = .error(.invalidURL)
            return
        }
        
        // Check if cached response exists
        if let cachedResponse = urlSession.configuration.urlCache?.cachedResponse(for: URLRequest(url: url)) {
            print("DEBUG: Cache HIT - Loading from cache")
            print("DEBUG: Cached data size: \(cachedResponse.data.count) bytes")
        } else {
            print("DEBUG: Cache MISS - Loading from network")
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                viewState = .error(.invalidResponse)
                return
            }
            
            print("DEBUG: Response status code: \(httpResponse.statusCode)")
            print("DEBUG: Data size: \(data.count) bytes")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                viewState = .error(.serverError(httpResponse.statusCode))
                return
            }
            
            let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
            
            print("DEBUG: Decoded \(decodedProducts.count) products")
            
            self.products = decodedProducts
            self.viewState = decodedProducts.isEmpty ? .empty : .loaded(decodedProducts)
            
        } catch let urlError as URLError {
            print("DEBUG: URLError: \(urlError.code)")
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                viewState = .error(.noInternetConnection)
                
            case .timedOut:
                viewState = .error(.timeout)
                
            default:
                viewState = .error(.networkError(urlError.localizedDescription))
            }
        } catch {
            print("DEBUG: Error: \(error.localizedDescription)")
            viewState = .error(.networkError(error.localizedDescription))
        }
    }
    
    func clearCache() {
        urlSession.configuration.urlCache?.removeAllCachedResponses()
        print("DEBUG: Cache cleared")
    }
}
