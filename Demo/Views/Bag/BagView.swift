

import SwiftUI

struct BagView: View {
    @Environment(BagViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            List {
                if !viewModel.bagItems.isEmpty {
                    ForEach(viewModel.bagItems, id: \.id) { bagItem in
                        BagItemRow(bagItem: bagItem)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            viewModel.removeFromBag(at: indexSet)
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(viewModel.bagTotal, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .contentTransition(.numericText())
                                .animation(.default, value: viewModel.bagTotal)
                        }
                    }
                    
                    Section {
                        Button(action: {}) {
                            Text("Checkout")
                                .font(.headline)
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.extraLarge)
                        .buttonSizing(.flexible)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .overlay {
                if viewModel.bagItems.isEmpty {
                    ContentUnavailableView(
                        "Your bag is empty",
                        systemImage: "bag"
                    )
                }
            }
            .toolbar {
                if !viewModel.bagItems.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
            }
            .navigationTitle("Bag")
        }
    }
}

#Preview("BagView - Empty") {
    BagView()
        .environment(BagViewModel())
}

#Preview("BagView - With Items") {
    let viewModel = BagViewModel()
    viewModel.bagItems = [.sample, .sampleJeans]
    
    return BagView()
        .environment(viewModel)
}
