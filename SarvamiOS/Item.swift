import Foundation
import SwiftData

@Model
final class TranslationItem {
    var userPrompt: String
    var translation: String
    
    init(userPrompt: String, translation: String) {
        self.userPrompt = userPrompt
        self.translation = translation
    }
}
