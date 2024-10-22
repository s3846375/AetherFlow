//
//  LargeEmissionsWidgetView.swift
//  TotalEmissionsWidgetExtension
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit
import SwiftUI
import Charts

/// A view that displays the large version of the total emissions widget.
///
/// The large widget includes the month, total emissions value, emissions level,
/// and a bar chart displaying a breakdown of emissions across categories like
/// Food, Clothing, Energy, and Transport.
struct LargeEmissionsWidgetView: View {
    /// The entry data containing emissions information.
    var entry: TotalEmissionsProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(entry.month) Emissions")
                .font(.headline)
                .bold()
                .accessibilityLabel("Month")
            HStack {
                VStack(alignment: .leading) {
                    Text("\(String(format: "%.0f", entry.totalEmissions))")
                        .font(.largeTitle)
                        .bold()
                        .accessibilityLabel("Emissions in kilograms")
                    Text("kg CO2")
                        .font(.title3)
                        .bold()
                        .offset(y: 4)
                }
                Spacer()
                EmissionIconView(entry: entry, size: .systemLarge)
            }
            .padding()
            
            // Bar chart for breakdown of emissions
            Chart(emissionData()) { dataPoint in
                BarMark(
                    x: .value("Category", dataPoint.category),
                    y: .value("Emissions", dataPoint.value)
                )
                .foregroundStyle(.yellow)
                .accessibilityLabel("\(dataPoint.category) emissions are \(String(format: "%.0f", dataPoint.value)) kilograms of CO2")
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine().foregroundStyle(Color.primary)
                    AxisTick().foregroundStyle(Color.primary)
                    AxisValueLabel().foregroundStyle(Color.primary)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine().foregroundStyle(Color.primary)
                    AxisTick().foregroundStyle(Color.primary)
                    AxisValueLabel().foregroundStyle(Color.primary)
                }
            }
            .frame(height: 120)
        }
        .padding()
        .accessibilityLabel("\(entry.month) emissions breakdown. Total emissions are \(String(format: "%.0f", entry.totalEmissions)) kilograms of CO2")
    }
    
    /// Creates data points for the bar chart based on emissions categories.
    /// - Returns: An array of `WidgetBarDataPoint` containing category and emission values.
    private func emissionData() -> [WidgetBarDataPoint] {
        return [
            WidgetBarDataPoint(category: "Food", value: entry.foodEmissions),
            WidgetBarDataPoint(category: "Clothing", value: entry.clothingEmissions),
            WidgetBarDataPoint(category: "Energy", value: entry.energyEmissions),
            WidgetBarDataPoint(category: "Transport", value: entry.transportEmissions)
        ]
    }
}

/// A model representing a point in the bar chart for emissions breakdown.
///
/// Each `WidgetBarDataPoint` represents a category of emissions and its value
/// for use in rendering the bar chart in the large widget view.
struct WidgetBarDataPoint: Identifiable {
    /// A unique identifier for the data point.
    let id = UUID()
    
    /// The category name of the emissions, e.g., "Food", "Clothing".
    let category: String
    
    /// The value of emissions for the given category.
    let value: Double
}

struct LargeEmissionsWidgetPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            LargeEmissionsWidgetView(
                entry: TotalEmissionsEntry(
                    date: .now,
                    totalEmissions: 1610,
                    month: "October",
                    foodEmissions: 360, clothingEmissions: 320, energyEmissions: 550, transportEmissions: 380
                )
            )
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
