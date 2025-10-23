

import SwiftUI

struct AddToBagSheet: View {
    let product: Product
    var dismissSearch: DismissSearchAction
    
    @Environment(\.dismiss) private var dismiss
    @Environment(BagViewModel.self) private var bagViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            AsyncImageView(urlString: product.image)
                .frame(height: 200)
            
            Text(product.title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                .font(.title)
                .fontWeight(.bold)
            
            Button {
                dismiss()
                dismissSearch()
            } label: {
                Text("Buy Now")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonSizing(.fitted)
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleMenu {
            Button { } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button(role: .destructive, action: { }) {
                Label("Action", systemImage: "trash")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    bagViewModel.addToBag(product)
                    
                    dismiss()
                }, label: {
                    Text("Add")
                        .foregroundStyle(.white)
                })
                .controlSize(.regular)
                .buttonSizing(.fitted)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

#Preview("AddToBagSheet") {
    @Previewable @Environment(\.dismissSearch) var dismissSearch
    NavigationStack {
        AddToBagSheet(
            product: .sample,
            dismissSearch: dismissSearch
        )
        .environment(BagViewModel())
    }
}
