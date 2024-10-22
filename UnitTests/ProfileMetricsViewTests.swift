//
//  ProfileMetricsViewTests.swift
//  UnitTests
//
//  Created by Gabby Sanchez on 9/10/2024.
//

import XCTest
@testable import AetherFlow

class ProfileMetricsViewTests: XCTestCase {
    
    var sut: ProfileMetricsView!
    
    override func setUp() {
        super.setUp()
        
        // Create the ProfileMetricsView instance
        sut = ProfileMetricsView(isAuthenticated: .constant(true))
        
        // Clear UserDefaults before each test
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        defaults?.removeObject(forKey: "totalEmissions")
        defaults?.removeObject(forKey: "month")
        defaults?.removeObject(forKey: "foodEmissions")
        defaults?.removeObject(forKey: "clothingEmissions")
        defaults?.removeObject(forKey: "energyEmissions")
        defaults?.removeObject(forKey: "transportEmissions")
    }

    func testAggregateEmissions_CorrectlyAggregatesData() {
        // Setup response data with non-aggregated groups
        let responseGroups: [CalculateMetricsGroup] = [
            CalculateMetricsGroup(group: "Airfare", result: CalculateMetricsGroupResult(emissions: 900, count: 1, fractionOfTotal: 0.6)),
            CalculateMetricsGroup(group: "Lodging", result: CalculateMetricsGroupResult(emissions: 300, count: 1, fractionOfTotal: 0.2)),
            CalculateMetricsGroup(group: "Fuel", result: CalculateMetricsGroupResult(emissions: 180, count: 1, fractionOfTotal: 0.1)),
            CalculateMetricsGroup(group: "Cafes and Restaurants", result: CalculateMetricsGroupResult(emissions: 20, count: 1, fractionOfTotal: 0.02)),
            CalculateMetricsGroup(group: "Clothing", result: CalculateMetricsGroupResult(emissions: 25, count: 1, fractionOfTotal: 0.02)),
            CalculateMetricsGroup(group: "Groceries", result: CalculateMetricsGroupResult(emissions: 12, count: 1, fractionOfTotal: 0.01))
        ]
        
        // Trigger aggregateEmissions
        let aggregatedData = sut.aggregateEmissions(groups: responseGroups)
        
        // Assert that the aggregated data matches the expected output
        XCTAssertEqual(aggregatedData["Food"]?.emissions, 32, "The emissions for 'Food' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Food"]?.count, 2, "The count for 'Food' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Food"]?.fractionOfTotal, 0.03, "The fraction of total for 'Food' should be correctly aggregated.")
        
        XCTAssertEqual(aggregatedData["Clothing"]?.emissions, 25, "The emissions for 'Clothing' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Clothing"]?.count, 1, "The count for 'Clothing' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Clothing"]?.fractionOfTotal, 0.02, "The fraction of total for 'Clothing' should be correctly aggregated.")
        
        XCTAssertEqual(aggregatedData["Energy"]?.emissions, 300, "The emissions for 'Energy' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Energy"]?.count, 1, "The count for 'Energy' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Energy"]?.fractionOfTotal, 0.2, "The fraction of total for 'Energy' should be correctly aggregated.")
        
        XCTAssertEqual(aggregatedData["Transport"]?.emissions, 1080, "The emissions for 'Transport' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Transport"]?.count, 2, "The count for 'Transport' should be correctly aggregated.")
        XCTAssertEqual(aggregatedData["Transport"]?.fractionOfTotal, 0.7, "The fraction of total for 'Transport' should be correctly aggregated.")
    }
    
    func testSaveWidgetData_SavesProfileMetricToUserDefaults() {
        // Setup input profileMetrics data
        let profileMetric = ProfileMetric(
            userId: "luke",
            emissionsTotal: 1200,
            transactionCount: 6,
            equivalents: [],
            groups: [],
            month: "October",
            timestamp: Date()
        )
        let sampleGroups: [ProfileMetricGroupItem] = [
            ProfileMetricGroupItem(group: "Food", emissions: 75, count: 1, fractionOfTotal: 0.06),
            ProfileMetricGroupItem(group: "Clothing", emissions: 25, count: 2, fractionOfTotal: 0.02),
            ProfileMetricGroupItem(group: "Energy", emissions: 300, count: 3, fractionOfTotal: 0.25),
            ProfileMetricGroupItem(group: "Transport", emissions: 800, count: 4, fractionOfTotal: 0.66)
        ]
        
        // Trigger saveWidgetData
        sut.saveWidgetData(profileMetric: profileMetric, profileMetricGroups: sampleGroups)
        
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        
        // Assert Correct Total Emissions Saved in UserDefaults
        XCTAssertEqual(
            defaults?.double(forKey: "totalEmissions"),
            profileMetric.emissionsTotal,
            "Total emissions should be saved in UserDefaults."
        )
        // Assert Correct Month Saved in UserDefaults
        XCTAssertEqual(
            defaults?.string(forKey: "month"),
            profileMetric.month,
            "Month should be saved in UserDefaults."
        )
        // Assert Correct Food Emissions Saved in UserDefaults
        XCTAssertEqual(
            defaults?.double(forKey: "foodEmissions"),
            sampleGroups[0].emissions,
            "Food emissions should be saved in UserDefaults."
        )
        // Assert Correct Clothing Emissions Saved in UserDefaults
        XCTAssertEqual(
            defaults?.double(forKey: "clothingEmissions"),
            sampleGroups[1].emissions,
            "Clothing emissions should be saved in UserDefaults."
        )
        // Assert Correct Energy Emissions Saved in UserDefaults
        XCTAssertEqual(
            defaults?.double(forKey: "energyEmissions"),
            sampleGroups[2].emissions,
            "Energy emissions should be saved in UserDefaults."
        )
        // Assert Correct Transport Emissions Saved in UserDefaults
        XCTAssertEqual(
            defaults?.double(forKey: "transportEmissions"),
            sampleGroups[3].emissions,
            "Transport emissions should be saved in UserDefaults."
        )
    }
    
    func testSaveWidgetData_InvalidProfileMetric_DoesNotSaveToUserDefaults() {
        // Setup nil profileMetrics data
        sut.saveWidgetData(profileMetric: nil, profileMetricGroups: [])
        
        // Trigger saveWidgetData
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        
        // Assert total emissions is not set
        XCTAssertNil(
            defaults?.object(forKey: "totalEmissions"),
            "Total emissions should not be saved in UserDefaults if profileMetric is nil."
        )
        
        // Assert that month is not set
        XCTAssertNil(
            defaults?.string(forKey: "month"),
            "Month should not be saved in UserDefaults if profileMetric is nil."
        )
        
        // Assert that food emissions is not set
        XCTAssertNil(
            defaults?.object(forKey: "foodEmissions"),
            "Food emissions should not be saved in UserDefaults if profileMetric is nil."
        )
        
        // Assert that clothing emissions is not set
        XCTAssertNil(
            defaults?.object(forKey: "clothingEmissions"),
            "Clothing emissions should not be saved in UserDefaults if profileMetric is nil."
        )
        
        // Assert that energy emissions is not set
        XCTAssertNil(
            defaults?.object(forKey: "energyEmissions"),
            "Energy emissions should not be saved in UserDefaults if profileMetric is nil."
        )
        
        // Assert that transport emissions is not set
        XCTAssertNil(
            defaults?.object(forKey: "transportEmissions"),
            "Transport emissions should not be saved in UserDefaults if profileMetric is nil."
        )
    }
    
    override func tearDown() {
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        defaults?.removeObject(forKey: "totalEmissions")
        defaults?.removeObject(forKey: "month")
        defaults?.removeObject(forKey: "foodEmissions")
        defaults?.removeObject(forKey: "clothingEmissions")
        defaults?.removeObject(forKey: "energyEmissions")
        defaults?.removeObject(forKey: "transportEmissions")
        
        sut = nil
        super.tearDown()
    }
}
