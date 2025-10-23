
import SwiftUI

struct ProductListView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(ProductsViewModel.self) private var viewModel
    
    var body: some View {
        List {
            if isSearching && viewModel.searchText.isEmpty {
                Text("Check out the new T-shirts...")
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.categorizedProducts, id: \.id) { category in
                    Section("\(category.name.capitalized)") {
                        ForEach(category.products, id: \.id) { product in
                            NavigationLink(value: product) {
                                ProductRowView(
                                    product: product,
                                    addToBag: {
                                        viewModel.selectedProduct = product
                                        viewModel.showAddToBagSheet.toggle()
                                    })
                                .badge(product.generateRandomStock())
                            }
                        }
                    }
                    .sectionActions {
                        Button(action: { }) {
                            Text("More like these...")
                                .foregroundStyle(.blue)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .badgeProminence(.decreased)
        .navigationDestination(for: Product.self) { product in
            ProductDetailView(product: product)
        }
        .sheet(isPresented: Bindable(viewModel).showAddToBagSheet) {
            NavigationStack {
                if let product = viewModel.selectedProduct {
                    AddToBagSheet(product: product, dismissSearch: dismissSearch)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

