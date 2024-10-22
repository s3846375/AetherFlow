//
//  ProfileMetricGroupItem.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 30/9/2024.
//

import Foundation
import SwiftData

/// Represents a group in a user's carbon emissions profile, providing a breakdown of emissions for a specific category (e.g., "Food", "Energy").
///
/// Each `ProfileMetricGroupItem` contains data for a specific group, including total emissions, the number of transactions contributing to those emissions,
/// and the fraction of the total carbon footprint represented by this group. It is part of the overall profile tracked by `ProfileMetric`.
@Model
class ProfileMetricGroupItem: Codable, Identifiable {
    /// Coding keys for decoding from and encoding to JSON.
    enum CodingKeys: String, CodingKey {
        case group
        case emissions
        case count
        case fractionOfTotal = "fraction_of_total"
    }
    
    /// Unique identifier for the group item.
    var id: UUID = UUID()
    
    /// The name of the group (e.g., "Food", "Energy").
    var group: String
    
    /// The total emissions for this group, measured in kilograms of CO2.
    var emissions: Double
    
    /// The count of transactions that contributed to the emissions of this group.
    var count: Int
    
    /// The fraction of the total emissions represented by this group.
    var fractionOfTotal: Double
    
    // MARK: - Initializers
    
    /// Initializes a new `ProfileMetricGroupItem` instance from a decoder.
    /// This initializer is used to decode JSON data into a `ProfileMetricGroupItem` object.
    /// - Parameter decoder: The decoder to extract data from.
    /// - Throws: An error if the decoding process fails.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.group = try container.decode(String.self, forKey: .group)
        self.emissions = try container.decode(Double.self, forKey: .emissions)
        self.count = try container.decode(Int.self, forKey: .count)
        self.fractionOfTotal = try container.decode(Double.self, forKey: .fractionOfTotal)
    }
    
    /// Initializes a new `ProfileMetricGroupItem` object with the provided details.
    /// - Parameters:
    ///   - group: The name of the group (e.g., "Food", "Energy").
    ///   - emissions: The total emissions for the group (in kilograms of CO2).
    ///   - count: The number of transactions that contributed to the group's emissions.
    ///   - fractionOfTotal: The fraction of the total emissions represented by this group.
    init(group: String,
         emissions: Double,
         count: Int,
         fractionOfTotal: Double
    ) {
        self.group = group
        self.emissions = emissions
        self.count = count
        self.fractionOfTotal = fractionOfTotal
    }
    
    /// Encodes this `ProfileMetricGroupItem` instance into an encoder. Currently, this function does nothing.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if the encoding process fails.
    func encode(to encoder: Encoder) throws {
    }
}
