import Foundation

final public class SarvamAPIService: NetworkingProtocol {

    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(to endpoint: SarvamEndpoint) async throws(SarvamError) -> T {
        do {
            guard let url = URL(string: endpoint.url) else {
                throw SarvamError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method
            endpoint.headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            request.httpBody = endpoint.body
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, !data.isEmpty else {
                throw SarvamError.noData
            }
            
            guard httpResponse.statusCode == 200 else {
                let sarvamErrorResponse = try JSONDecoder().decode(SarvamErrorResponse.self, from: data)
                throw SarvamError.serverError(statusCode: httpResponse.statusCode, sarvamError: sarvamErrorResponse)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as SarvamError {
            throw error // Re-throw SarvamError directly
        } catch {
            throw SarvamError.decodingError(error) // Wrap any decoding or unexpected errors
        }
    }
}
