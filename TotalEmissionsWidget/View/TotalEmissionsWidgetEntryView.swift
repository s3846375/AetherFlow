//
//  TotalEmissionsWidgetEntryView.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 5/10/2024.
//

import WidgetKit
import SwiftUI

/// A view for rendering AetherFlow's total emissions widget based on its family size.
struct TotalEmissionsWidgetEntryView: View {
    /// The entry data containing emissions information.
    var entry: TotalEmissionsProvider.Entry

    /// The size of the widget family, used to determine how to render the view.
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack {
            if widgetFamily == .systemSmall {
                SmallEmissionsWidgetView(entry: entry)
            } else if widgetFamily == .systemMedium {
                MediumEmissionsWidgetView(entry: entry)
            } else if widgetFamily == .systemLarge {
                LargeEmissionsWidgetView(entry: entry)
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}
