//
//  jungbo_silgi_2025App.swift
//  jungbo-silgi-2025
//
//  Created by DOMINIQUE on 6/13/25.
//

import SwiftUI
import SwiftData

@main
struct jungbo_silgi_2025App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
