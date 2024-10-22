//
//  ReadChallengeData.swift
//  AetherFlow
//
//  A Utility function to load mock challenge data from the ChallengesData JSON file.
//
//  Created by Gabby Sanchez and Christina Tu on 26/8/2024.
//

import Foundation

/// Reads data from JSON file ChallengesData and import as a `Challenge` array.
class ReadChallengeData: ObservableObject  {
    @Published var challenges = [Challenge]()
         
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "ChallengesData", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let challenges = try? JSONDecoder().decode([Challenge].self, from: data!)
        self.challenges = challenges!
    }
}
