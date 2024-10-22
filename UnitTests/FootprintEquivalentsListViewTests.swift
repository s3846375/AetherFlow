//
//  FootprintEquivalentsListViewTests.swift
//  UnitTests
//
//  Created by Gabby Sanchez and Christina Tu on 2024/10/8.
//

import XCTest
@testable import AetherFlow

final class FootprintEquivalentsListViewTests: XCTestCase {
    func testTrimEquivalent() {
        // Setup input
        let view = FootprintEquivalentsListView(emissionsTotal: 1200, equivalents: [])
        let input = "This is equivalent to the emissions from flying from London to Paris 0.7 times."
        
        // Get trimmed output
        let trimmedOutput = view.trimEquivalent(equivalent: input)
        
        // Assert trimmed output is correct
        XCTAssertEqual(trimmedOutput, "Emissions from flying from London to Paris 0.7 times.")
    }
    
    func testGetIconForEquivalent_ForRecognizedKeywords() {
        let view = FootprintEquivalentsListView(emissionsTotal: 1200, equivalents: [])
        
        // Assert all recognized keywords with their expected icon
        let equivalentsWithExpectedIcon: [(equivalentString: String, expectedIcon: String)] = [
            ("This is equivalent to the emissions from flying from London to Paris 0.7 times.", "airplane"),
            ("This is equivalent to the CO2 absorbed by planting and growing 0.8 trees for 10 years.", "leaf.fill"),
            ("This is equivalent to the emissions saved by recycling 2 trash bags.", "arrow.triangle.2.circlepath"),
            ("This is equivalent to the emissions from powering a restaurant for 1 day.", "fork.knife"),
            ("This is equivalent to the emissions from powering a library.", "books.vertical"),
            ("This is equivalent to the electricity used by a house.", "bolt.fill"),
            ("This is equivalent to the emissions from using gas in a home.", "flame.fill"),
            ("This is equivalent to the emissions from heating a home.", "house.fill"),
            ("This is equivalent to producing 0.5 pairs of jeans.", "tshirt.fill"),
            ("This is equivalent to air freighting goods.", "shippingbox.fill"),
            ("This is equivalent to using water for irrigation.", "drop.fill")
        ]
        
        for scenario in equivalentsWithExpectedIcon {
            let output = view.getIconForEquivalent(equivalent: scenario.equivalentString)
            XCTAssertEqual(output, scenario.expectedIcon, "Failed for equivalentString: \(scenario.equivalentString), Expected: \(scenario.expectedIcon)")
        }
    }
    
    func testGetIconForEquivalent_ForDefaultScenarios() {
        let view = FootprintEquivalentsListView(emissionsTotal: 1200, equivalents: [])
        
        // Assert returned default icon if no recognized keywords are found
        let inputInvalid = "This is equivalent to an undisclosed metric."
        XCTAssertEqual(view.getIconForEquivalent(equivalent: inputInvalid), "carbon.dioxide.cloud.fill")
        
        // Assert returned default icon if input is an empty string
        let inputEmpty = ""
        XCTAssertEqual(view.getIconForEquivalent(equivalent: inputEmpty), "carbon.dioxide.cloud.fill")
    }
}
