//
//  MediumEmissionsWidgetView.swift
//  TotalEmissionsWidgetExtension
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit
import SwiftUI

/// A view that displays the medium version of the total emissions widget.
///
/// The medium widget displays the month and the total emissions value, with
/// an icon indicating the emissions level.
struct MediumEmissionsWidgetView: View {
    /// The entry data containing emissions information.
    var entry: TotalEmissionsProvider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(entry.month) Emissions")
                    .font(.headline)
                    .bold()
                    .accessibilityLabel("Month")
                Spacer()
                HStack {
                    Text("\(String(format: "%.0f", entry.totalEmissions))")
                        .font(.largeTitle)
                        .bold()
                        .accessibilityLabel("Emissions in kilograms")
                    Text("kg CO2")
                        .font(.title3)
                        .bold()
                        .offset(y: 4)
                }
            }
            Spacer()
            EmissionIconView(entry: entry, size: .systemMedium)
        }
        .padding()
        .accessibilityLabel("\(entry.month) emissions are \(String(format: "%.0f", entry.totalEmissions)) kilograms of CO2")
    }
}

struct MediumEmissionsWidgetPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            MediumEmissionsWidgetView(
                entry: TotalEmissionsEntry(
                    date: .now,
                    totalEmissions: 400,
                    month: "October",
                    foodEmissions: 100, clothingEmissions: 50, energyEmissions: 150, transportEmissions: 100
                )
            )
        }
        .containerBackground(for: .widget) {
            Color.clear

        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
