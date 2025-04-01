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
        NavigationStack {
            VStack(spacing: 24) {
                NavigationLink {
                    NavigationStack {
                        List {
                            ForEach(translationItems) { item in
                                NavigationLink {
                                    Text("\(item.translation)")
                                        .font(.body)
                                } label: {
                                    Text("\(item.userPrompt)")
                                }
                            }
                            .onDelete(perform: deleteTranslation)
                        }
                        .background(.clear)
                        .navigationTitle("Favorites")
                    }
                } label: {
                    Text("Favorites")
                        .foregroundColor(Color.orange)
                        .bold()
                }
                
                TextEditor(text: $inputText)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if inputText.isEmpty {
                                Text("Enter text to translate")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 16)
                                    .padding(.top, 16)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                    )
                
                Button(action: {
                    Task {
                        await translate()
                    }
                }) {
                    Text("Translate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(isLoading || inputText.isEmpty)
                
                if isLoading {
                    ProgressView()
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                
                TextEditor(text: $translatedText)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding()
            .navigationTitle("Translate")
        }
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
    
    private func deleteTranslation(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(translationItems[index])
            }
        }
    }
}

#Preview {
    TranslateView()
        .modelContainer(for: TranslationItem.self, inMemory: true)
}
