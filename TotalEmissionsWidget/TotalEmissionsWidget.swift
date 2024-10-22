//
//  TotalEmissionsWidget.swift
//  TotalEmissionsWidget
//
//  Created by Gabby Sanchez on 2/10/2024.
//

import WidgetKit
import SwiftUI
import Charts

/// The main widget configuration for AetherFlow's total emissions widget.
///
/// This widget shows the user's total emissions data in different sizes: small, medium, and large,
/// providing an overview of monthly carbon emissions for the user.
struct TotalEmissionsWidget: Widget {
    /// The unique identifier for the widget.
    let kind: String = "TotalEmissionsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: TotalEmissionsProvider()
        ) { entry in
            TotalEmissionsWidgetEntryView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    TotalEmissionsWidget()
} timeline: {
    TotalEmissionsEntry(
        date: .now,
        totalEmissions: 1200,
        month: "October",
        foodEmissions: 300, clothingEmissions: 200, energyEmissions: 500, transportEmissions: 200
    )
}

#Preview(as: .systemMedium) {
    TotalEmissionsWidget()
} timeline: {
    TotalEmissionsEntry(
        date: .now,
        totalEmissions: 3000,
        month: "October",
        foodEmissions: 300, clothingEmissions: 200, energyEmissions: 500, transportEmissions: 200
    )
}

#Preview(as: .systemLarge) {
    TotalEmissionsWidget()
} timeline: {
    TotalEmissionsEntry(
        date: .now,
        totalEmissions: 11100,
        month: "October",
        foodEmissions: 2600, clothingEmissions: 2200, energyEmissions: 3500, transportEmissions: 2800
    )
}
