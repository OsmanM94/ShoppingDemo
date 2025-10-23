

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
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                viewState = .error(.invalidResponse)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                viewState = .error(.serverError(httpResponse.statusCode))
                return
            }
            
            let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
            
            // Hold on... Let's store the products first, then update the view state... :)
            self.products = decodedProducts
            
            self.viewState = decodedProducts.isEmpty ? .empty : .loaded(decodedProducts)
            
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                viewState = .error(.noInternetConnection)
                
            case .timedOut:
                viewState = .error(.timeout)
                
            default:
                viewState = .error(.networkError(urlError.localizedDescription))
            }
        } catch {
            viewState = .error(.networkError(error.localizedDescription))
        }
    }
}
