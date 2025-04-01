import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TranslateView()
                .modelContainer(SarvamiOSApp.sharedModelContainer)
                .tabItem {
                    Label("Translate", systemImage: "translate")
                }
            
            Text("Text to Speech")
                .tabItem {
                    Label("Text to Speech", systemImage: "person.wave.2")
                }
            
            Text("Speech to Text")
                .tabItem {
                    Label("Speech to Text", systemImage: "text.page")
                }
            
            FavoritesView()
                .modelContainer(SarvamiOSApp.sharedModelContainer)
                .tabItem {
                    Label("Favorites", systemImage: "book")
                }
        }
        .accentColor(Color.buttonPurple)
    }
}

#Preview {
    MainView()
}
