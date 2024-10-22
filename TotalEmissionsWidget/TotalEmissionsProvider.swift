//
//  TotalEmissionsProvider.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit

/// A timeline provider for generating the data needed for the total emissions widget.
///
/// The `TotalEmissionsProvider` fetches and provides data from `UserDefaults` and generates
/// timeline entries used to populate the widget across different sizes.
struct TotalEmissionsProvider: AppIntentTimelineProvider {
    
    /// Provides a placeholder entry for the widget preview.
    ///
    /// - Parameter context: The context of the widget.
    /// - Returns: A `TotalEmissionsEntry` with sample data.
    func placeholder(in context: Context) -> TotalEmissionsEntry {
        TotalEmissionsEntry(
            date: Date(),
            totalEmissions: 1200,
            month: "October",
            foodEmissions: 300,
            clothingEmissions: 200,
            energyEmissions: 500,
            transportEmissions: 200
        )
    }

    /// Provides a snapshot entry for the widget during a quick view or when not actively updating.
    ///
    /// - Parameters:
    ///   - configuration: The app intent configuration for the widget.
    ///   - context: The context of the widget.
    /// - Returns: A `TotalEmissionsEntry` with data retrieved from `UserDefaults`.
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TotalEmissionsEntry {
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        let totalEmissions = defaults?.double(forKey: "totalEmissions") ?? 0
        let month = defaults?.string(forKey: "month") ?? "Your"
        let foodEmissions = defaults?.double(forKey: "foodEmissions") ?? 0
        let clothingEmissions = defaults?.double(forKey: "clothingEmissions") ?? 0
        let energyEmissions = defaults?.double(forKey: "energyEmissions") ?? 0
        let transportEmissions = defaults?.double(forKey: "transportEmissions") ?? 0
        
        return TotalEmissionsEntry(
            date: Date(),
            totalEmissions: totalEmissions,
            month: month,
            foodEmissions: foodEmissions,
            clothingEmissions: clothingEmissions,
            energyEmissions: energyEmissions,
            transportEmissions: transportEmissions
        )
    }
    
    /// Generates a timeline of entries to update the widget's content.
    ///
    /// - Parameters:
    ///   - configuration: The app intent configuration for the widget.
    ///   - context: The context of the widget.
    /// - Returns: A timeline containing one or more entries, to be used for refreshing the widget.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TotalEmissionsEntry> {
        var entries: [TotalEmissionsEntry] = []

        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        let totalEmissions = defaults?.double(forKey: "totalEmissions") ?? 0
        let month = defaults?.string(forKey: "month") ?? "Your"
        let foodEmissions = defaults?.double(forKey: "foodEmissions") ?? 0
        let clothingEmissions = defaults?.double(forKey: "clothingEmissions") ?? 0
        let energyEmissions = defaults?.double(forKey: "energyEmissions") ?? 0
        let transportEmissions = defaults?.double(forKey: "transportEmissions") ?? 0

        // Generate a timeline consisting of one entry, refreshing at a set interval
        let currentDate = Date()
        let entry = TotalEmissionsEntry(
            date: currentDate,
            totalEmissions: totalEmissions,
            month: month,
            foodEmissions: foodEmissions,
            clothingEmissions: clothingEmissions,
            energyEmissions: energyEmissions,
            transportEmissions: transportEmissions
        )
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }
}
