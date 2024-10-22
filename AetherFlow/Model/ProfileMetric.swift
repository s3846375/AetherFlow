//
//  ProfileMetric.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 30/9/2024.
//

import Foundation
import SwiftData

/// Represents a user's carbon emissions profile for a specific month.
///
/// Each `ProfileMetric` stores the user's total carbon emissions, the number of transactions contributing to those emissions,
/// and related equivalents and breakdowns by category (e.g., food, energy, transport). This model is used to track the user's carbon footprint
/// and generate insights based on past behavior.
@Model
class ProfileMetric: Codable, Identifiable {
    /// Coding keys for decoding from and encoding to JSON.
    enum CodingKeys: String, CodingKey {
        case userId
        case emissionsTotal = "emissions_total"
        case transactionCount = "transaction_count"
        case equivalents
        case groups
        case month
        case timestamp
    }
    
    /// Unique identifier for the profile metric.
    var id: UUID = UUID()
    
    /// The user ID associated with this profile metric.
    var userId: String
    
    /// Total carbon emissions (in kilograms of CO2) for the month.
    var emissionsTotal: Double
    
    /// The total number of transactions contributing to the carbon emissions.
    var transactionCount: Int
    
    /// An array of equivalent actions or activities to the carbon emissions generated.
    var equivalents: [String]
    
    /// The month for which this profile metric was generated (e.g., "October").
    var month: String
    
    /// The timestamp when the profile metric was created.
    var timestamp: Date
    
    /// The breakdown of emissions into groups, with a cascade delete rule.
    @Relationship(deleteRule: .cascade) var groups: [ProfileMetricGroupItem]
    
    // MARK: - Initializers
    
    /// Initializes a new `ProfileMetric` instance from a decoder.
    /// This initializer is used for decoding JSON data into a `ProfileMetric` object.
    /// - Parameter decoder: The decoder to extract data from.
    /// - Throws: An error if the decoding process fails.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decode(String.self, forKey: .userId)
        self.emissionsTotal = try container.decode(Double.self, forKey: .emissionsTotal)
        self.transactionCount = try container.decode(Int.self, forKey: .transactionCount)
        self.equivalents = try container.decode([String].self, forKey: .equivalents)
        self.groups = try container.decode([ProfileMetricGroupItem].self, forKey: .groups)
        self.month = try container.decode(String.self, forKey: .month)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    /// Initializes a new `ProfileMetric` object with the provided details.
    /// - Parameters:
    ///   - userId: The ID of the user associated with the profile metric.
    ///   - emissionsTotal: The total carbon emissions (in kilograms of CO2) for the month.
    ///   - transactionCount: The number of transactions contributing to the emissions.
    ///   - equivalents: A list of equivalent actions or activities for the emissions.
    ///   - groups: An array of `ProfileMetricGroupItem` objects representing the emission breakdown by category (optional).
    ///   - month: The month name for which the metric was generated.
    ///   - timestamp: The timestamp when the profile metric was created.
    init(userId: String,
         emissionsTotal: Double,
         transactionCount: Int,
         equivalents: [String],
         groups: [ProfileMetricGroupItem] = [],
         month: String,
         timestamp: Date
    ) {
        self.userId = userId
        self.emissionsTotal = emissionsTotal
        self.transactionCount = transactionCount
        self.equivalents = equivalents
        self.groups = groups
        self.month = month
        self.timestamp = timestamp
    }
    
    /// Encodes this `ProfileMetric` instance into an encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if the encoding process fails.
    func encode(to encoder: Encoder) throws {
    }
}

// MARK: - ProfileMetric Extensions

extension ProfileMetric {
    @MainActor
    static var preview: ModelContainer {
        UserDefaults.standard.set("luke", forKey: "userId")
        UserDefaults.standard.set("Luke", forKey: "username")
        
        // Create a container for both `ProfileMetric` and `Transaction`.
        let container = try! ModelContainer(for: ProfileMetric.self, Transaction.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Load Profile Metric Sample Data
        if let profileMetricURL = Bundle.main.url(forResource: "ProfileMetricSampleData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: profileMetricURL)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                // Decode the JSON into a `ProfileMetric` object and insert it into the container's context.
                let profileMetrics = try decoder.decode([ProfileMetric].self, from: data)
                
                for profileMetric in profileMetrics {
                    container.mainContext.insert(profileMetric)
                }
            } catch {
                print("Failed to decode ProfileMetric Sample Data JSON: \(error)")
            }
        } else {
            print("ProfileMetric Sample Data Json file not found")
        }
        
        // Load Transaction Sample Data
        if let transactionURL = Bundle.main.url(forResource: "TransactionData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: transactionURL)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                // Decode the JSON into a list of `Transaction` objects and insert them into the container's context.
                let transactions = try decoder.decode([Transaction].self, from: data)
                
                for transaction in transactions {
                    container.mainContext.insert(transaction)
                }
            } catch {
                print("Failed to decode Transaction Data JSON: \(error)")
            }
        } else {
            print("Transaction Data Json file not found")
        }
        
        return container
    }
}
