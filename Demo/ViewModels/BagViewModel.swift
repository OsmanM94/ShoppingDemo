

import Foundation

@Observable
final class BagViewModel {
    var bagItems: [BagItem] = []
    
    var bagTotal: Double {
        bagItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var itemCount: Int {
        bagItems.reduce(0) { $0 + $1.quantity }
    }
    
    func addToBag(_ product: Product) {
        if let index = bagItems.firstIndex(where: { $0.product.id == product.id }) {
            bagItems[index].quantity += 1
        } else {
            bagItems.append(BagItem(product: product, quantity: 1))
        }
    }
    
    func removeFromBag(_ product: Product) {
        bagItems.removeAll { $0.product.id == product.id }
    }
    
    func removeFromBag(at offsets: IndexSet) {
        bagItems.remove(atOffsets: offsets)
    }
    
    func decreaseQuantity(_ product: Product) {
        if let index = bagItems.firstIndex(where: { $0.product.id == product.id }) {
            if bagItems[index].quantity > 1 {
                bagItems[index].quantity -= 1
            } else {
                bagItems.remove(at: index)
            }
        }
    }
    
    func updateQuantity(_ product: Product, to newQuantity: Int) {
        guard let index = bagItems.firstIndex(where: { $0.product.id == product.id }) else { return }
        
        if newQuantity <= 0 {
            bagItems.remove(at: index)
        } else {
            bagItems[index].quantity = newQuantity
        }
    }
}
