
import SwiftUI

struct ContentView: View {
    @Environment(ProductsViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .empty:
                    ContentUnavailableView("Sold out.", systemImage: "tray.fill")
              
                case .loading:
                    ProgressView()
                    
                case .loaded(_ ):
                  ProductListView()
                        .searchable(
                            text: Bindable(viewModel).searchText,
                            placement: .navigationBarDrawer,
                            prompt: "Clothing, electronics..."
                        )
                
                case .error(let error):
                    ContentUnavailableView {
                        Label(error.message, systemImage: "questionmark")
                    } actions: {
                        Button("Refresh") {
                            Task { await viewModel.loadProducts() }
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)
                        .buttonSizing(.fitted)
                    }
                }
            }
            .navigationTitle("Products")
            .navigationSubtitle("New Stock")
            .animation(.easeInOut, value: viewModel.viewState)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Local Notifications?
                    } label: {
                        Image(systemName: "bell.fill")
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                       // Refresh?
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    
                    Button {
                        // Account?
                    } label: {
                        Image(systemName: "person.fill")
                    }
                }
            }
        }
        .task {
            if viewModel.products.isEmpty {
                await viewModel.loadProducts()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ProductsViewModel())
}
