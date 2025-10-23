
import Foundation

struct ProductCategory: Identifiable {
    var id: String { name }
    let name: String
    let products: [Product]
}
