

import SwiftUI

struct BagItemRow: View {
    let bagItem: BagItem
    
    @Environment(BagViewModel.self) private var viewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AsyncImageView(urlString: bagItem.product.image)
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(bagItem.product.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(bagItem.product.category.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(bagItem.totalPrice, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .contentTransition(.numericText())
                        .animation(.default, value: bagItem.totalPrice)
                    
                    Text("\(bagItem.product.price, format: .currency(code: Locale.current.currency?.identifier ?? "GBP")) each")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .opacity(bagItem.quantity > 1 ? 1 : 0)
                        .animation(.default, value: bagItem.quantity)
                }
            }
            
            HStack {
                Stepper(value: Binding(
                    get: { bagItem.quantity },
                    set: { viewModel.updateQuantity(bagItem.product, to: $0) }
                ), in: 1...99) {
                    HStack {
                        Text("Quantity:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(bagItem.quantity)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .contentTransition(.numericText())
                    }
                }
                .animation(.default, value: bagItem.quantity)
                
                Spacer()
            }
        }
        .padding(.vertical)
    }
}
