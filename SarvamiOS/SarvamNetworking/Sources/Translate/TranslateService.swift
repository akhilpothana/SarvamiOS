import Foundation

final public class TranslateService: Sendable {
    
    private let networking: NetworkingProtocol
    private let apiKey: String
    
    public init(networking: NetworkingProtocol = SarvamAPIService()) {
        guard let key = ProcessInfo.processInfo.environment["SARVAM_API_KEY"] else {
            fatalError("SARVAM_API_KEY environment variable not set")
        }
        self.apiKey = key
        self.networking = networking
    }
    
    public func translateText(
        input: String,
        sourceLanguage: String = "en-IN",
        targetLanguage: String = "te-IN"
    ) async throws -> String {
        let payload = TranslateRequest(
            input: input,
            sourceLanguageCode: sourceLanguage,
            targetLanguageCode: targetLanguage,
            speakerGender: nil,
            mode: .modern_colloquial,
            enablePreprocessing: true,
            outputScript: .fullyNative,
            numeralsFormat: .international
        )
        
        let body = try JSONEncoder().encode(payload)
        let endpoint = SarvamEndpoint(
            url: "https://api.sarvam.ai/translate",
            method: "POST",
            headers: [
                "api-subscription-key": apiKey,
                "Accept": "application/json",
                "Content-Type": "application/json"
            ],
            body: body
        )
        
        let response: TranslateResponse = try await networking.request(to: endpoint)
        return response.translatedText
    }
}
