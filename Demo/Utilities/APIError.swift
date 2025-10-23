
import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case networkError(String)
    case decodingError
    case serverError(Int)
    case timeout
    case noInternetConnection
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Try again."
        case .invalidResponse:
            return "Invalid server response."
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError:
            return "Failed to process data."
        case .serverError(let code):
            return "Server error (\(code)). Try again."
        case .timeout:
            return "Request timed out. Check your connection."
        case .noInternetConnection:
            return "No internet connection. Check your network."
        }
    }
}
