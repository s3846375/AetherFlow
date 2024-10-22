//
//  ProfileMetricEquivalentsListView.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 7/10/2024.
//

import SwiftUI

/// A view that displays a list of carbon footprint equivalents based on a provided total emissions value.
///
/// The view shows a summary of the total emissions in kilograms of CO2, optionally alongside the name and price if provided.
/// It also presents a list of equivalent actions or activities that match the given total emissions.
///
/// - Parameters:
///   - emissionsTotal: The total carbon emissions in kilograms of CO2.
///   - equivalents: An array of strings representing equivalent actions or activities to the carbon emissions.
///   - name: An optional name representing the item associated with the emissions, shown as the view's title.
struct FootprintEquivalentsListView: View {
    @State var emissionsTotal: Double
    @State var equivalents: [String]
    var name: String? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:
                    VStack {
                        VStack {
                            Text("\(String(format: "%.2f", emissionsTotal))")
                                .font(.largeTitle)
                                .bold()
                            Text("kg CO2")
                                .font(.title3)
                                .bold()
                                .accessibilityLabel("Kilograms of CO2 emissions")
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .frame(width: 250, height: 100)
                        .background(.yellow)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .accessibilityLabel("\(String(format: "%.2f", emissionsTotal)) kilograms of CO2 emissions")
                    
                        if (!equivalents.isEmpty) {
                            Text("This is equivalent to the...")
                                .font(.headline)
                                .padding(.top, 10)
                                .accessibilityLabel("This is equivalent to the")
                        }
                    }
                    .frame(maxWidth: .infinity))
                {
                    if (!equivalents.isEmpty) {
                        ForEach(equivalents.indices, id: \.self) { index in
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.teal)
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: getIconForEquivalent(equivalent: equivalents[index]))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(.white)
                                }
                                .padding(.leading, -4)
                                .padding(.trailing, 4)
                                
                                Text(trimEquivalent(equivalent: equivalents[index]))
                                    .font(.headline)
                                    .accessibilityLabel(trimEquivalent(equivalent: equivalents[index]))
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle(name ?? "Equivalents")
        }
    }
    
    /// Trims the prefix "This is equivalent to the" from a given string and capitalizes the first letter.
    ///
    /// - Parameter equivalent: A string representing an equivalent action or activity.
    /// - Returns: A trimmed and capitalized string without the specified prefix.
    func trimEquivalent(equivalent: String) -> String {
        let trimmedString = equivalent.replacingOccurrences(of: "This is equivalent to the ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.prefix(1).capitalized + trimmedString.dropFirst()
    }
    
    /// Returns a relevant SF Symbol name based on keywords in the provided equivalent string.
    ///
    /// The function looks for specific keywords in the string to determine the most appropriate icon to display.
    /// If no keyword is found, a default icon for CO2 emissions is returned.
    ///
    /// - Parameter equivalent: A string representing an equivalent action or activity.
    /// - Returns: An SF Symbol name as a string.
    func getIconForEquivalent(equivalent: String) -> String {
        let lowercasedEquivalent = equivalent.lowercased()
        
        if lowercasedEquivalent.contains("flying") || lowercasedEquivalent.contains("airbus") || lowercasedEquivalent.contains("plane") {
            return "airplane"
        } else if lowercasedEquivalent.contains("tree") {
            return "leaf.fill"
        } else if lowercasedEquivalent.contains("recycling") || lowercasedEquivalent.contains("recycle") {
            return "arrow.triangle.2.circlepath"
        } else if lowercasedEquivalent.contains("restaurant") {
            return "fork.knife"
        } else if lowercasedEquivalent.contains("library") {
            return "books.vertical"
        } else if lowercasedEquivalent.contains("electricity") || lowercasedEquivalent.contains("power") {
            return "bolt.fill"
        } else if lowercasedEquivalent.contains("gas") {
            return "flame.fill"
        } else if lowercasedEquivalent.contains("home") || lowercasedEquivalent.contains("house") {
            return "house.fill"
        } else if lowercasedEquivalent.contains("fabric") || lowercasedEquivalent.contains("jeans") {
            return "tshirt.fill"
        } else if lowercasedEquivalent.contains("air freighting") {
            return "shippingbox.fill"
        } else if lowercasedEquivalent.contains("water") {
            return "drop.fill"
        }
        
        return "carbon.dioxide.cloud.fill"
    }
}

#Preview {
    FootprintEquivalentsListView(
        emissionsTotal: 1200,
        equivalents: [
            "This is equivalent to the emissions from flying from London to Paris 0.7 times.",
            "This is equivalent to the CO2 absorbed by planting and growing 0.8 trees for 10 years.",
            "This is equivalent to the emissions saved by recycling 2 trash bags of waste instead of sending it to landfill.",
            "This is equivalent to the emissions from flying from Berlin to Munich 0.5 times.",
            "This is equivalent to the emissions from producing 0.5 jeans.",
            "This is equivalent to the emissions from powering a restaurant with electricity for 1 days.",
            "This is equivalent to the emissions from powering a library with electricity for 0.9 days.",
            "This is equivalent to the emissions from providing 0.4 UK homes with gas for a year.",
            "This is equivalent to the emissions from flying an Airbus A380 for 1 minute.",
            "This is equivalent to the emissions from powering 1 UK homes with electricity for a year.",
            "This is equivalent to the emissions from air freighting 10 kg 0.4 times between London and New York.",
            "This is equivalent to the emissions from supplying 0.4 houses with tap water for one year."
        ],
        name: "ALDI"
    ).modelContainer(ProfileMetric.preview)
}
