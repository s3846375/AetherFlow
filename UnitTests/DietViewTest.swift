//
//  UnitTests.swift
//  UnitTests
//
//  Created by Gabby Sanchez and Christina Tu on 2024/10/7.
//

import XCTest
@testable import AetherFlow

final class DietViewTest: XCTestCase {
    var diets = [
        Diet(userId: "Luke", challenge: "Look after devices", isComplete: false),
        Diet(userId: "Luke", challenge: "Low emissions transport", isComplete: true),
        Diet(userId: "Luke", challenge: "Use car less", isComplete: true),
        Diet(userId: "Luke", challenge: "Use public transport", isComplete: true),
        Diet(userId: "Luke", challenge: "Use public transport", isComplete: false),
        Diet(userId: "Luke", challenge: "Look after devices", isComplete: true),
        Diet(userId: "Luke", challenge: "Look after devices", isComplete: true),
        Diet(userId: "Luke", challenge: "Use car less", isComplete: true),
        Diet(userId: "Luke", challenge: "Use car less", isComplete: true),
        Diet(userId: "Luke", challenge: "Use car less", isComplete: false),
    ]
    
    private var completeDiets: [Diet] {
        diets.filter { $0.isComplete }
    }
    
    func testContainsChallenge() throws {

        let dietView = DietView()
        
        let challengeCountDict = dietView.countChallenges(dietList: completeDiets)
        
        let completeCount1 = challengeCountDict["Use car less"]
        XCTAssertEqual(completeCount1, 3, "In the complete diet section the 'Use car less' badge should have a x2 label.")
        
        let completeCount2 = challengeCountDict["Use public transport"]
        XCTAssertEqual(completeCount2, 1, "In the complete diet section the 'Use public transport' badge should have a x1 label.")
        
        let completeCount3 = challengeCountDict["Look after devices"]
        XCTAssertEqual(completeCount3, 2, "In the complete diet section the 'Look after devices' badge should have a x2 label.")
        
    }
}
