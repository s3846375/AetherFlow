//
//  SmallEmissionsWidgetView.swift
//  TotalEmissionsWidgetExtension
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit
import SwiftUI

/// A view that displays the small version of the total emissions widget.
///
/// The small widget shows an icon representing the emissions level and the total
/// emissions value in kilograms of CO2.
struct SmallEmissionsWidgetView: View {
    /// The entry data containing emissions information.
    var entry: TotalEmissionsProvider.Entry
    
    var body: some View {
        VStack {
            EmissionIconAndValueView(entry: entry)
            Text("kg CO2")
                .font(.title3)
                .bold()
                .offset(y: -8)
                .accessibilityLabel("Kilograms of CO2 emissions")
        }
        .accessibilityLabel("\(String(format: "%.0f", entry.totalEmissions)) kilograms of CO2 emissions")
    }
}

struct SmallEmissionsWidgetPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            SmallEmissionsWidgetView(
                entry: TotalEmissionsEntry(
                    date: .now,
                    totalEmissions: 1200,
                    month: "October",
                    foodEmissions: 300, clothingEmissions: 200, energyEmissions: 500, transportEmissions: 200
                )
            )
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
