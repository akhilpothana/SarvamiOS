import SarvamNetworking
import SwiftData
import SwiftUI

struct TranslateView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    @Environment(\.modelContext) private var modelContext
    @Query private var translationItems: [TranslationItem]
    
    private let translateService: TranslateService
    
    init(translateService: TranslateService = TranslateService()) {
        self.translateService = translateService
    }
    
    var body: some View {
        VStack(spacing: 24) {
            TextEditor(text: $inputText)
                .frame(minHeight: 100)
                .padding(8)
                .scrollContentBackground(.hidden)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lightAccentBrown.opacity(0.4), lineWidth: 1)
                )
                .tint(.lightAccentBrown)
            
            let buttonTitle = isLoading ? nil : "Translate"
            let buttonIcon = isLoading ? "hexagon" : nil
            
            HStack {
                Text("English")
                Image(systemName: "arrow.right")
                Text("తెలుగు")
                Spacer()
                CustomActionButton(
                    text: buttonTitle,
                    icon: buttonIcon,
                    action: {
                        isLoading.toggle()
//                    Task {
//                        await translate()
//                    }
                },
                    isLoading: $isLoading)
                //.disabled(isLoading || inputText.isEmpty)
            }
            .frame(height: 64)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            TextEditor(text: $translatedText)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lightAccentBrown.opacity(0.4), lineWidth: 1)
                )
                .tint(.lightAccentBrown)
        }
        .padding()
        .background(Color.backgroundLight)
    }
    
    private func translate() async {
        isLoading = true
        errorMessage = nil
        translatedText = ""
        
        do {
            let result = try await translateService.translateText(input: inputText)
            translatedText = result
            Task {
                saveTranslation(userPrompt: inputText, translation: translatedText)
            }
        } catch {
            errorMessage = (error as? SarvamError)?.errorDescription ?? error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func saveTranslation(userPrompt: String, translation: String) {
        withAnimation {
            let newItem = TranslationItem(
                userPrompt: userPrompt,
                translation: translation
            )
            
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    TranslateView()
        .modelContainer(for: TranslationItem.self, inMemory: true)
}
