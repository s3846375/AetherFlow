//
//  Transaction.swift
//  AetherFlow
//
//  This entity is mainly used in AetherFlow's Footprint Log feature.
//  The Transaction entity represents a record of the user’s transactions with its corresponding carbon footprint data.
//
//  Created by Gabby Sanchez and Christina Tu on 18/8/2024.
//

import Foundation
import SwiftData

/// Represents a carbon footprint transaction entry, storing details about a user's spending activity and its associated carbon emissions.
///
/// This model class conforms to `Codable` and `Identifiable`, allowing it to be serialized and uniquely identified.
/// It contains the properties required for storing the transaction details and the calculated carbon emissions.
///
/// A `Transaction` is associated with a user and can be grouped by category (e.g., groceries, fuel), identified by a merchant category code (MCC).
@Model
class Transaction: Codable, Identifiable {
    /// Coding keys for decoding from and encoding to JSON.
    enum CodingKeys: String, CodingKey {
        case userId
        case group
        case name
        case price
        case mcc
        case kgEmissions = "kg_of_CO2e_emissions"
        case mtEmissions = "mt_of_CO2e_emissions"
        case equivalents = "similar_to"
        case timestamp
    }
    
    /// Unique identifier for the transaction.
    var id = UUID()
    
    /// The ID of the user associated with the transaction.
    var userId: String
    
    /// The category of the transaction, e.g., "Groceries", "Fuel".
    var group: String
    
    /// The name or description of the transaction.
    var name: String
    
    /// The price of the transaction.
    var price: Double
    
    /// The merchant category code (MCC) representing the type of transaction.
    var mcc: String
    
    /// The carbon emissions associated with the transaction, measured in kilograms.
    var kgEmissions: Double
    
    /// The carbon emissions associated with the transaction, measured in metric tons.
    var mtEmissions: Double
    
    /// An array of equivalent actions or activities to the carbon emissions generated by this transaction.
    ///
    /// These equivalents provide a more relatable context to understand the environmental impact.
    /// For example, an equivalent could be "This is equivalent to the emissions from flying from London to Paris 0.7 times."
    var equivalents: [String]
    
    /// The timestamp when the transaction occurred.
    var timestamp: Date
    
    // MARK: - Initializers
    
    /// Initializes a new `Transaction` instance from a decoder.
    /// - Parameter decoder: The decoder to extract data from.
    /// - Throws: An error if the decoding process fails.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decode(String.self, forKey: .userId)
        self.group = try container.decode(String.self, forKey: .group)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.mcc = try container.decode(String.self, forKey: .mcc)
        self.kgEmissions = try container.decode(Double.self, forKey: .kgEmissions)
        self.mtEmissions = try container.decode(Double.self, forKey: .mtEmissions)
        self.equivalents = try container.decode([String].self, forKey: .equivalents)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    /// Initializes a new `Transaction` instance with the provided details.
    /// - Parameters:
    ///   - id: Unique identifier for the transaction.
    ///   - userId: The ID of the user associated with the transaction.
    ///   - group: The category of the transaction.
    ///   - name: The name or description of the transaction.
    ///   - price: The monetary value of the transaction.
    ///   - mcc: The MCC representing the type of transaction.
    ///   - kgEmissions: Carbon emissions in kilograms.
    ///   - mtEmissions: Carbon emissions in metric tons.
    ///   - equivalents: An array of equivalent actions or activities to the carbon emissions for better context.
    ///   - timestamp: The timestamp of when the transaction occurred.
    init(id: UUID = UUID(),
         userId: String,
         group: String,
         name: String,
         price: Double,
         mcc: String,
         kgEmissions: Double,
         mtEmissions: Double,
         equivalents: [String],
         timestamp: Date
    ) {
        self.id = id
        self.userId = userId
        self.group = group
        self.name = name
        self.price = price
        self.mcc = mcc
        self.kgEmissions = kgEmissions
        self.mtEmissions = mtEmissions
        self.equivalents = equivalents
        self.timestamp = timestamp
    }
    
    /// Encodes this `Transaction` instance into an encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if the encoding process fails.
    func encode(to encoder: Encoder) throws {
    }
}

// MARK: - Transaction Extensions

extension Transaction {
    /// A preview container to simulate a model context for use in SwiftUI previews.
    ///
    /// This uses data from a local JSON file (`TransactionData.json`) and initializes a container with sample transactions.
    @MainActor
    static var preview: ModelContainer {
        UserDefaults.standard.set("luke", forKey: "userId")
        
        let container = try! ModelContainer(for: Transaction.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Attempts to find the JSON file with sample transaction data.
        guard let url = Bundle.main.url(forResource: "TransactionData", withExtension: "json")
            else {
                print("Transaction Data Json file not found")
                return container
            }
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            // Decodes the JSON into a list of `Transaction` objects and inserts them into the container's context.
            let transactions = try decoder.decode([Transaction].self, from: data)
            
            for transaction in transactions {
                container.mainContext.insert(transaction)
            }
        } catch {
            print("Failed to decode Transaction Data JSON: \(error)")
        }
        
        return container
    }
}
