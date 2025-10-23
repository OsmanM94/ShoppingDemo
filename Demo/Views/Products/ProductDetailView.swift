

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImageView(urlString: product.image)
                    .frame(maxHeight: 300)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(product.category.capitalized)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(product.price, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Text("Description")
                        .font(.headline)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Button(action: { }) {
                        Text("Buy")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.glassProminent)
                    .controlSize(.extraLarge)
                    .buttonSizing(.flexible)
                    .buttonBorderShape(.roundedRectangle)
                    .padding([.top, .bottom])
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .contentMargins(10)
    }
}

#Preview("ProductDetailView") {
    ProductDetailView(product: .sample)
}
