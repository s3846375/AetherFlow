//
//  AetherFlow.swift
//  AetherFlow
//
//  Created by Gabby Sanchez and Christina Tu on 14/8/2024.
//

import SwiftUI
import SwiftData

/// The main entry point for the AetherFlow app, configuring the app's main scene and initializing the data model container.
@main
struct AetherFlow: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print(URL.applicationSupportDirectory.path(percentEncoded: false))
                }
        }
        .modelContainer(for: [Transaction.self, ProfileMetric.self, ProfileMetricGroupItem.self, Diet.self])
    }
}
