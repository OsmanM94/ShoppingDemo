
import Foundation

struct BagItem: Identifiable {
    let product: Product
    var quantity: Int
    
    var id: Int { product.id }
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
}

extension BagItem {
    static let sample = BagItem(product: .sample, quantity: 1)
    static let sampleMultiple = BagItem(product: .sample, quantity: 5)
    static let sampleJeans = BagItem(product: .sampleJeans, quantity: 2)
}
