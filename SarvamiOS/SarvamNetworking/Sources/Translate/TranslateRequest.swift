import Foundation

public struct TranslateRequest: Encodable {
    let input: String
    let sourceLanguageCode: String
    let targetLanguageCode: String
    let speakerGender: String?
    let mode: TranslationMode
    let enablePreprocessing: Bool
    let outputScript: TransliterationStyle
    let numeralsFormat: NumeralsFormat
    
    enum CodingKeys: String, CodingKey {
        case input
        case sourceLanguageCode = "source_language_code"
        case targetLanguageCode = "target_language_code"
        case speakerGender = "speaker_gender"
        case mode
        case enablePreprocessing = "enable_preprocessing"
        case outputScript = "output_script"
        case numeralsFormat = "numerals_format"
    }
}

public enum NumeralsFormat: String, Encodable {
    /// Uses regular numerals (0-9). For ex. 9840950950
    case international
    
    /// Uses language-specific native numerals. For ex. ९८४०९५०९५०
    case native
}

public enum TranslationMode: String, Encodable {
    case formal
    case modern_colloquial = "modern-colloquial"
    case classic_colloquial = "classic-colloquial"
    case code_mixed = "code-mixed"
}

/// Controls the transliteration style applied to the output text
public enum TransliterationStyle: String, Encodable {
    ///Transliteration in Romanized script.
    case roman
    
    /// Transliteration in the native script with formal style.
    case fullyNative = "fully-native"
    
    /// Transliteration in the native script with spoken style.
    case spokenFormInNative = "spoken-form-in-native"
}

public struct TranslateResponse: Decodable {
    let translatedText: String
    
    enum CodingKeys: String, CodingKey {
        case translatedText = "translated_text"
    }
}
