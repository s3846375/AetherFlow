//
//  Challenges.swift
//  AetherFlow
//
//  This entity is mainly used in AetherFlow's Challenge feature.
//  Each Challenge is composed of a predefined hardcoded data which are manually scraped from the
//  Connect Earth API’s suggested/recommended actions from the endpoint (Chart Insights API 2023)
//
//  Created by Gabby Sanchez and Christina Tu on 24/8/2024.
//

import Foundation

/// Represents an individual challenge within the AetherFlow Challenge feature.
///
/// Each `Challenge` is composed of predefined hardcoded data which are manually scraped from the
/// Connect Earth API's suggested or recommended actions.
///
/// Challenges are used to encourage users to take action in reducing their carbon footprint by completing specific tasks.
///
/// Conforms to the `Codable` and `Identifiable` protocols, allowing it to be easily serialized and uniquely identified.
/// - Parameters:
///   - category: The main category of the challenge (e.g., "Energy", "Transport").
///   - subCategory: The specific subcategory related to the challenge.
///   - action: The specific action users are encouraged to take.
///   - description: A detailed description of the challenge.
///   - reference: A reference for further information or background on the challenge.
struct Challenge: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case category
        case subCategory = "sub_category"
        case action
        case description
        case reference
    }
    
    /// A unique identifier for each challenge instance.
    var id = UUID()
    
    /// The main category to which the challenge belongs (e.g., "Energy", "Transport").
    var category: String
    
    /// A more specific subcategory of the challenge.
    var subCategory: String
    
    /// The action users are encouraged to perform as part of the challenge.
    var action: String
    
    /// A detailed explanation of the challenge and its importance.
    var description: String
    
    /// A reference link or resource for additional information about the challenge.
    var reference: String
}
