//
//  TotalEmissionsEntry.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit

/// A timeline entry representing total emissions data for the AetherFlow widget.
///
/// This struct holds the emissions data for the widget's timeline, including
/// the total emissions, month name, and breakdown of emissions by category.
struct TotalEmissionsEntry: TimelineEntry {
    /// The date for which this entry is relevant.
    let date: Date
    
    /// The total emissions for the specified month.
    let totalEmissions: Double
    
    /// The name of the month the emissions data belongs to.
    let month: String
    
    /// The total emissions of recorded food transactions.
    let foodEmissions: Double
    
    /// The total emissions of recorded clothing transactions.
    let clothingEmissions: Double
    
    /// The total emissions of recorded energy transactions.
    let energyEmissions: Double
    
    /// The total emissions of recorded transport transactions.
    let transportEmissions: Double
}
