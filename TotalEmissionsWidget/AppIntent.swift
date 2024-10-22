//
//  AppIntent.swift
//  TotalEmissionsWidget
//
//  Created by Gabby Sanchez on 2/10/2024.
//

import WidgetKit
import AppIntents

/// The configuration intent for AetherFlow's total emissions widget.
///
/// This intent defines the basic configuration properties for the widget, including its
/// title and description that are displayed when users add the widget to their home screen.
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    /// The title of the widget displayed in the widget gallery.
    static var title: LocalizedStringResource = "Total Emissions Widget"
    
    /// The description of the widget displayed in the widget gallery.
    static var description = IntentDescription("This widget displays the total emissions for the most recent recorded month")
}
