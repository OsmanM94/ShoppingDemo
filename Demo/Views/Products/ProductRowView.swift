
import SwiftUI

struct ProductRowView: View {
    let product: Product
    let addToBag: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImageView(urlString: product.image)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(product.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        addToBag()
                    } label: {
                        Text("Details")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                    .buttonBorderShape(.capsule)
                }
            }
        }
        .padding(10)
    }
}

#Preview("ProductRowView") {
    ProductRowView(
        product: .sample,
        addToBag: { }
    )
}
