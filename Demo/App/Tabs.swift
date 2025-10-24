

import SwiftUI

struct Tabs: View {
    
    enum TabViews {
        case products
        case bag
        case search
    }
    
    @State private var productViewModel = ProductsViewModel()
    @State private var bagViewModel = BagViewModel()
    
    @State private var selectedTab = TabViews.products
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Products", systemImage: "tshirt.fill", value: TabViews.products) {
                ContentView()
            }
            
            Tab("Bag", systemImage: "bag", value: TabViews.bag) {
                BagView()
            }
            .badge(bagViewModel.itemCount)
            
            Tab(value: TabViews.search, role: .search) {
                Text("Dedicated SearchView")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            if bagViewModel.itemCount > 0  && selectedTab == .products {
                HStack {
                    // this will handle plurals eg. item / items - automatically
                    Text("^[\(bagViewModel.itemCount) item](inflect: true)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(bagViewModel.bagTotal, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button("Pay Now") {
                        // Navigate to checkout?
                    }
                }
                .padding(.horizontal)
            }
        }
        .environment(productViewModel)
        .environment(bagViewModel)
    }
}
