

import Foundation

struct Product: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
    func generateRandomStock() -> Int {
        return Int.random(in: 1...10)
    }
}

extension Product {
    static let sample = Product(
        id: 1,
        title: "Premium Cotton T-Shirt",
        price: 29.99,
        description: "High-quality cotton t-shirt with a comfortable fit. Perfect for everyday wear.",
        category: "men's clothing",
        image: "https://picsum.photos/200"
    )
    
    static let sampleLongTitle = Product(
        id: 2,
        title: "Premium Extra Long Cotton T-Shirt With Beautiful Design And Comfortable Fit",
        price: 29.99,
        description: "Comfortable cotton t-shirt",
        category: "men's clothing",
        image: "https://picsum.photos/200"
    )
    
    static let sampleJeans = Product(
        id: 3,
        title: "Classic Blue Jeans",
        price: 49.99,
        description: "Comfortable denim jeans with a modern fit",
        category: "men's clothing",
        image: "https://picsum.photos/200"
    )
    
    static let sampleJacket = Product(
        id: 4,
        title: "Winter Jacket",
        price: 89.99,
        description: "Warm winter jacket for cold weather",
        category: "women's clothing",
        image: "https://picsum.photos/200"
    )
    
    static let sampleExpensive = Product(
        id: 5,
        title: "4K Ultra HD Monitor",
        price: 599.99,
        description: "Professional grade 27-inch 4K monitor with HDR support",
        category: "electronics",
        image: "https://picsum.photos/200"
    )
    
    static let samples = [
        sample,
        sampleJeans,
        sampleJacket,
        sampleExpensive,
        Product(id: 6, title: "Gold Necklace", price: 39.99, description: "Beautiful gold necklace", category: "jewelery", image: "https://picsum.photos/200"),
        Product(id: 7, title: "Silver Ring", price: 29.99, description: "Elegant silver ring", category: "jewelery", image: "https://picsum.photos/200")
    ]
}
