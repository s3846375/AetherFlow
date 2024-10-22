//
//  ReadTransactionData.swift
//  AetherFlow
//
//  A Utility function to load mock transaction data from the TransactionData JSON file.
//
//  Created by Gabby Sanchez and Christina Tu on 26/8/2024.
//

import Foundation

/// Reads data from JSON file TransactionData and import as a `Transaction` array.
class ReadTransactionData: ObservableObject  {
    @Published var transactions = [Transaction]()
    
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "TransactionData", withExtension: "json")
            else {
                print("Transaction Data Json file not found")
                return
            }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let transactions = try decoder.decode([Transaction].self, from: data)
            self.transactions = transactions
        } catch {
            print("Failed to decode Transaction Data JSON: \(error)")
        }
    }
}
