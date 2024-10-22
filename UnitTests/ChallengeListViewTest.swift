//
//  ChallengeListViewTest.swift
//  UnitTests
//
//  Created by Gabby Sanchez and Christina Tu on 2024/10/7.
//

import XCTest
@testable import AetherFlow

final class ChallengeListViewTest: XCTestCase {
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
    
    private var ongoingDiets: [Diet] {
        diets.filter { $0.isComplete == false }
    }

    func testChallengeIsContain() throws {
        
        let challengeListView = ChallengeListView(challengeCategory: ChallengeCategoryView(id: "transport", name: "Transport", icon: "car.fill", video: "transportVideo"))
        
        let isContainDiet1 = challengeListView.dietContainsChallenge(list: ongoingDiets, subCategory: "Look after devices")
        XCTAssertTrue(isContainDiet1, "The listed challenges should not show a button next to 'Look after devices'.")
        
        let isContainDiet2 = challengeListView.dietContainsChallenge(list: ongoingDiets, subCategory: "Use public transport")
        XCTAssertTrue(isContainDiet2, "The listed challenges should not show a button next to 'Use public transport'.")

        let isContainDiet3 = challengeListView.dietContainsChallenge(list: ongoingDiets, subCategory: "Use car less")
        XCTAssertTrue(isContainDiet3, "The listed challenges should not show a button next to 'Use car less'.")
        
        
    }
}
