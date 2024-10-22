//
//  Diet.swift
//  AetherFlow
//
//  This entity is mainly used in AetherFlow's Challenge and Carbon Diet features.
//  Whenever a user takes on a challenge, the app creates a Diet record,
//  linking the user’s progress to the selected challenge.
//
//  Created by Christina Tu on 2024/10/1.
//

import Foundation
import SwiftData

/// Represents a diet record that tracks a user's progress toward completing a challenge in the AetherFlow app.
///
/// The `Diet` entity is used in the AetherFlow's Challenge and Carbon Diet features. Whenever a user takes on a challenge,
/// the app creates a `Diet` record that tracks the user's association with the challenge, their progress, and completion status.
///
/// - Parameters:
///   - id: A unique identifier for each diet record.
///   - userId: The ID of the user who is taking on the challenge.
///   - challenge: The name or description of the challenge being tracked.
///   - timestamp: The date and time when the diet record was created.
///   - isComplete: A Boolean value indicating whether the user has completed the challenge.
@Model
class Diet: Identifiable {
    var id: UUID
    var userId: String
    var challenge: String
    var timestamp: Date
    var isComplete: Bool

    /// Initializes a new `Diet` record with the provided values.
    /// - Parameters:
    ///   - id: A unique identifier for the diet record. If not provided, a new UUID is generated.
    ///   - userId: The ID of the user who is taking on the challenge.
    ///   - challenge: The name of the challenge being tracked.
    ///   - timestamp: The time when the record was created. Defaults to the current date and time.
    ///   - isComplete: Whether the challenge has been completed. Defaults to `false`.
    init(id: UUID = UUID(), userId: String, challenge: String, timestamp: Date = Date(), isComplete: Bool = false) {
        self.id = id
        self.userId = userId
        self.challenge = challenge
        self.timestamp = timestamp
        self.isComplete = isComplete
    }
}

extension Diet {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Diet.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(Diet(userId: "luke", challenge: "Low emissions transport", isComplete: false))
        container.mainContext.insert(Diet(userId: "luke", challenge: "Use car less", isComplete: false))
        container.mainContext.insert(Diet(userId: "luke", challenge: "Use public transport", isComplete: false))
        container.mainContext.insert(Diet(userId: "luke", challenge: "Use public transport", isComplete: true))
        container.mainContext.insert(Diet(userId: "luke", challenge: "Look after devices", isComplete: true))
        container.mainContext.insert(Diet(userId: "luke", challenge: "Look after devices", isComplete: true))
        
        return container
    }
}
