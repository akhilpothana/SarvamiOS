//
//  SarvamiOSApp.swift
//  SarvamiOS
//
//  Created by Akhil Pothana on 3/26/25.
//

import SwiftUI
import SwiftData

@main
struct SarvamiOSApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TranslationItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TranslateView()
                .modelContainer(sharedModelContainer)
        }
    }
}
