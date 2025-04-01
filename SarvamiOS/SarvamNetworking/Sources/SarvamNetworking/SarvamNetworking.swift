import Foundation

public protocol NetworkingProtocol: Sendable {
    func request<T: Decodable>(to endpoint: SarvamEndpoint) async throws(SarvamError) -> T
}

public enum SarvamError: Error, LocalizedError {
    case invalidURL
    case decodingError(Error)
    case serverError(statusCode: Int, sarvamError: SarvamErrorResponse)
    case noData
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL: 
            return "Invalid URL provided."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let statusCode, let sarvamError):
            return "Server error: \(statusCode) | \(sarvamError.error.message) | \(sarvamError.error.code)"
        case .noData: 
            return "No data received from the server."
        }
    }
}


/// Represents an error object returned from Sarvam's API
public struct SarvamErrorResponse: Decodable, Sendable {
    let error: ErrorObject
    
    public struct ErrorObject: Decodable, Sendable {
        let message: String
        let code: String
    }
}

public struct SarvamEndpoint: Decodable {
    let url: String
    let method: String
    let headers: [String: String]
    let body: Data?
}
