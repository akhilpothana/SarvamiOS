import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var translationItems: [TranslationItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(translationItems) { item in
                    NavigationLink {
                        Text("\(item.translation)")
                            .font(.body)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } label: {
                        Text("\(item.userPrompt)")
                            .font(.body)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .onDelete(perform: deleteTranslation)
                .listRowSeparatorTint(.backgroundLight.opacity(0.2))
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundLight)
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
    FavoritesView()
}
