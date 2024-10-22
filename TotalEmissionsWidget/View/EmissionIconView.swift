//
//  EmissionIconView.swift
//  TotalEmissionsWidgetExtension
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit
import SwiftUI

/// A shared view for rendering the emissions level icon based on its value.
///
/// This view displays an icon corresponding to the emission level using different
/// symbols and colors depending on the `totalEmissions` value.
struct EmissionIconView: View {
    /// The entry data containing emissions information.
    var entry: TotalEmissionsProvider.Entry
    
    /// The size of the widget family, used to determine the icon size.
    var size: WidgetFamily

    var body: some View {
        let imageSize: CGFloat = size == .systemSmall ? 32 : 64
        let iconName: String
        let color: Color
        if entry.totalEmissions < 640 {
            iconName = "leaf.fill"
            color = .teal
        } else if entry.totalEmissions < 1280 {
            iconName = "exclamationmark.triangle.fill"
            color = .orange
        } else {
            iconName = "carbon.dioxide.cloud.fill"
            color = .red
        }
        
        return Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: imageSize, height: imageSize)
            .foregroundColor(color)
    }
}
