//
//  EmissionIconAndValueView.swift
//  TotalEmissionsWidgetExtension
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import SwiftUI

/// A shared view for rendering the emission icon and value.
///
/// This view combines the emissions level icon and displays the total emissions value
/// in a vertical stack.
struct EmissionIconAndValueView: View {
    /// The entry data containing emissions information.
    var entry: TotalEmissionsProvider.Entry

    var body: some View {
        VStack {
            EmissionIconView(entry: entry, size: .systemSmall)
            Text("\(String(format: "%.0f", entry.totalEmissions))")
                .font(.largeTitle)
                .bold()
                .offset(y: -8)
        }
    }
}
