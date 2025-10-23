

import SwiftUI

struct BagView: View {
    @Environment(BagViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.bagItems.isEmpty {
                    ContentUnavailableView(
                        "Your bag is empty",
                        systemImage: "bag"
                    )
                } else {
                    List {
                        ForEach(viewModel.bagItems) { bagItem in
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
                            Button(action: {
                                
                            }, label: {
                                Text("Checkout")
                                    .font(.headline)
                            })
                            .buttonStyle(.glassProminent)
                            .controlSize(.extraLarge)
                            .buttonSizing(.flexible)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            EditButton()
                        }
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
