//
//  APIService.swift
//  AetherFlow
//
//  Created by Gabby Sanchez on 30/9/2024.
//

import Foundation
import SwiftData

/// A service responsible for calling Connect Earth API endpoints.
///
/// This service provides functionalities to calculate carbon emissions for transactions
/// and generate metrics using the Connect Earth API. It abstracts the process of forming
/// API requests, handling responses, and formatting data as needed for API consumption.
struct APIService {
    /// The base URL for all Connect Earth API endpoints.
    private static let baseUrl = "https://api.connect.earth"
    
    /// Fetches the Connect Earth API key from the app's Info.plist file.
    ///
    /// This key is used to authorize requests to the API.
    /// - Throws: An error if the API key is not found in the `Info.plist` file.
    /// - Returns: The API key as a string.
    static private func fetchAPIKey() throws -> String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            throw NSError(domain: "API_KEY Error", code: 1, userInfo:
                            [NSLocalizedDescriptionKey: "API_KEY not set in Config.xconfig or Info.plist"])
        }
        return apiKey
    }
    
    /// Calculates carbon emissions by calling the Connect Earth API's transaction endpoint.
    ///
    /// This function prepares a POST request to the API's `/transaction` endpoint, sending
    /// transaction details such as MCC code, price, and date. It returns the carbon
    /// emissions calculated for the provided transaction details.
    ///
    /// - Parameters:
    ///   - mccCode: The MCC (Merchant Category Code) of the transaction.
    ///   - transactionName: The name or description of the transaction.
    ///   - transactionPrice: The monetary value of the transaction.
    ///   - transactionDate: The date the transaction occurred.
    ///   - groupName: The category group of the transaction.
    /// - Throws: An error if the API call fails or the response is invalid.
    /// - Returns: An `AddTransactionResponse` containing the calculated carbon emissions.
    static func calculateEmissions(
        mccCode: String,
        transactionName: String,
        transactionPrice: Double,
        transactionDate: Date,
        groupName: String
    ) async throws -> AddTransactionResponse {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let parameters: [String: Any] = [
            "currencyISO": "AUD",
            "categoryType": "mcc",
            "categoryValue": mccCode,
            "description": transactionName,
            "merchant": transactionName,
            "price": transactionPrice,
            "transactionId": "new_id",
            "transactionDate": formatter.string(from: transactionDate),
            "geo": "AU",
            "group": groupName
        ]
        
        let apiKey = try fetchAPIKey()
        let data = try await postAPIRequest(endpoint: "/transaction", parameters: parameters, apiKey: apiKey)
        
        print("API_KEY: \(apiKey)")
        // Print the response data
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        } else {
            print("Failed to decode response")
        }
        
        return try JSONDecoder().decode(AddTransactionResponse.self, from: data)
    }
    
    /// Calculates carbon emissions metrics for multiple transactions.
    ///
    /// This function calls the `/charts/pie` endpoint of the Connect Earth API, sending a batch
    /// of transactions and receiving the summarized metrics for those transactions.
    ///
    /// - Parameter transactions: An array of `Transaction` objects to calculate metrics for.
    /// - Throws: An error if the API call fails or the response is invalid.
    /// - Returns: A `CalculateMetricsResponse` containing the calculated metrics, or `nil` if no transactions are provided.
    static func calculateMetrics(transactions: [Transaction]) async throws -> CalculateMetricsResponse? {
        guard !transactions.isEmpty else {
            // Return a response with empty data if no input is given
            return nil
        }
        
        let parameters: [String: Any] = [
            "geo": "AU",
            "userType": "PERSONAL",
            "transactions": formatTransactions(transactions)
        ]
        
        let apiKey = try fetchAPIKey()
        let data = try await postAPIRequest(endpoint: "/charts/pie", parameters: parameters, apiKey: apiKey)
        
        return try JSONDecoder().decode(CalculateMetricsResponse.self, from: data)
    }
    
    /// Makes a POST request to a specified endpoint of the Connect Earth API.
    ///
    /// This function handles the formation and sending of a POST request with the necessary headers
    /// and body parameters, returning the response data for further processing.
    ///
    /// - Parameters:
    ///   - endpoint: The specific API endpoint to send the request to (e.g., `/transaction`).
    ///   - parameters: The body parameters to include in the request.
    ///   - apiKey: The API key for authorization.
    /// - Throws: An error if the request fails or the response is invalid.
    /// - Returns: The `Data` received in the response from the API.
    private static func postAPIRequest(endpoint: String, parameters: [String: Any], apiKey: String) async throws -> Data {
        let urlString = "\(baseUrl)\(endpoint)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-api-key": apiKey,
            "content-type": "application/json"
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return data
    }
    
    /// Formats an array of `Transaction` objects for API requests.
    ///
    /// This function converts a list of `Transaction` objects into a format suitable for
    /// the Connect Earth API `/charts/pie` endpoint.
    ///
    /// - Parameter transactions: An array of `Transaction` objects to be formatted.
    /// - Returns: A formatted array of `[String: Any]` dictionaries, each representing a transaction.
    private static func formatTransactions(_ transactions: [Transaction]) -> [[String: Any]] {
        return transactions.map { transaction in
            [
                "currencyISO": "AUD",
                "mcc": transaction.mcc,
                "price": transaction.price,
                "geo": "AU",
                "group": transaction.group
            ]
        }
    }
}

// MARK: - API Response Model

/// A model representing the response received from the Connect Earth API /transaction endpoint.
/// Contains data about the calculated carbon emissions for a transaction.
///
/// - Note: This model conforms to the `Codable` protocol for easy decoding from JSON data.
struct AddTransactionResponse : Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case kgEmissions = "kg_of_CO2e_emissions"
        case mtEmissions = "mt_of_CO2e_emissions"
        case similarTo = "similar_to"
    }
    
    /// Unique identifier for the response.
    var id = UUID()
    
    /// The carbon emissions associated with the transaction, measured in kilograms.
    var kgEmissions: Double
    
    /// The carbon emissions associated with the transaction, measured in metric tons.
    var mtEmissions: Double
    
    /// An array of similar actions or activities to the carbon emissions generated by this transaction.
    ///
    /// These equivalents provide a more relatable context to understand the environmental impact.
    /// For example, an equivalent could be "This is equivalent to the emissions from flying from London to Paris 0.7 times."
    var similarTo: [String]
}

/// A model representing the response from the Connect Earth API's `/charts/pie` endpoint.
///
/// This model contains summarized emissions metrics for a group of transactions,
/// including total emissions, transaction count, and breakdowns by categories.
struct CalculateMetricsResponse: Codable {
    /// The total carbon emissions for all transactions, measured in kilograms.
    var emissionsTotal: Double
    
    /// The total count of transactions included in the response.
    var transactionCount: Int
    
    /// An array of equivalent actions or activities to the carbon emissions generated by this transaction.
    var equivalents: [String]
    
    /// The breakdown of emissions into groups, with each group representing a category.
    var groups: [CalculateMetricsGroup]
    
    enum CodingKeys: String, CodingKey {
        case emissionsTotal = "emissions_total"
        case transactionCount = "transaction_count"
        case equivalents
        case groups
    }
}

/// A model representing the result for a specific group in the emissions breakdown.
///
/// Each `CalculateMetricsGroupResult` contains the total emissions, count of transactions,
/// and fraction of the total emissions for a given group.
struct CalculateMetricsGroupResult: Codable {
    /// The carbon emissions for the group, measured in kilograms.
    var emissions: Double
    
    /// The count of transactions included in the group.
    var count: Int
    
    /// The fraction of the total emissions represented by this group.
    var fractionOfTotal: Double
    
    enum CodingKeys: String, CodingKey {
        case emissions
        case count
        case fractionOfTotal = "fraction_of_total"
    }
}

/// A model representing an emissions category group and its associated metrics.
///
/// Each `CalculateMetricsGroup` represents a category of transactions, containing
/// the group name and results such as emissions and transaction count.
struct CalculateMetricsGroup: Codable, Identifiable {
    /// A unique identifier for the group, generated upon creation.
    var id = UUID()
    
    /// The name of the group or category, e.g., "Fuel", "Clothing".
    var group: String
    
    /// The results for the group, including emissions, transaction count, and fraction of the total emissions.
    var result: CalculateMetricsGroupResult
    
    enum CodingKeys: String, CodingKey {
        case group
        case result
    }
    
    /// Initializes a new instance of `CalculateMetricsGroup` with the specified parameters.
    /// - Parameters:
    ///   - group: The name of the group or category, e.g., "Fuel", "Clothing".
    ///   - result: The results for the group, including emissions, transaction count, and fraction of the total emissions.
    init(group: String, result: CalculateMetricsGroupResult) {
        self.group = group
        self.result = result
    }
    
    /// Initializes a new instance of `CalculateMetricsGroup` by decoding the provided `Decoder`.
    /// - Parameter decoder: The decoder to extract data from.
    /// - Throws: An error if the decoding process fails.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        group = try container.decode(String.self, forKey: .group)
        result = try container.decode(CalculateMetricsGroupResult.self, forKey: .result)
    }
}
