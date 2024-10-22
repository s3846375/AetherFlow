//
//  AddFootprintViewTests.swift
//  UnitTests
//
//  Created by Gabby Sanchez on 9/10/2024.
//

import XCTest
import SwiftData
@testable import AetherFlow

class AddFootprintViewTests: XCTestCase {
    var sut: AddFootprintView!

    override func setUp() {
        super.setUp()
        
        sut = AddFootprintView(isPresented: .constant(true))
    }

    // MARK: - Name Validation Tests

    func testIsFormValid_ValidName() {
        // Set up a valid transaction name
        let validName = "Groceries"
        let transactionPriceText = "50.00"
        let validTransactionDate = Date() // Current date, should be valid
        
        // Assert valid name
        let isFormValid = sut.isFormValid(transactionName: validName, transactionPriceText: transactionPriceText, transactionDate: validTransactionDate)
        XCTAssertTrue(isFormValid, "Form should be valid when the transaction name is valid.")
    }
    
    func testIsFormValid_EmptyName() {
        // Set up an empty transaction name
        let emptyName = ""
        let transactionPriceText = "50.00"
        let validTransactionDate = Date()
        
        // Assert empty name
        let isFormInvalid = sut.isFormValid(transactionName: emptyName, transactionPriceText: transactionPriceText, transactionDate: validTransactionDate)
        XCTAssertFalse(isFormInvalid, "Form should be invalid when the transaction name is empty.")
    }

    // MARK: - Price Validation Tests

    func testIsFormValid_ValidPrice() {
        // Set up a valid transaction price
        let transactionName = "Groceries"
        let validPrice = "50.00"
        let validTransactionDate = Date()
        
        // Assert valid price
        let isFormValid = sut.isFormValid(transactionName: transactionName, transactionPriceText: validPrice, transactionDate: validTransactionDate)
        XCTAssertTrue(isFormValid, "Form should be valid when the transaction price is valid.")
    }
    
    func testIsFormValid_EmptyPrice() {
        // Set up an empty transaction price
        let transactionName = "Groceries"
        let emptyPrice = ""
        let validTransactionDate = Date()
        
        // Assert empty price
        let isFormInvalid = sut.isFormValid(transactionName: transactionName, transactionPriceText: emptyPrice, transactionDate: validTransactionDate)
        XCTAssertFalse(isFormInvalid, "Form should be invalid when the transaction price is empty.")
    }
    
    func testIsFormValid_InvalidPrice() {
        // Set up an invalid transaction price (non-numeric value)
        let transactionName = "Groceries"
        let invalidPrice = "Fifty"
        let validTransactionDate = Date()
        
        // Assert invalid price
        let isFormInvalid = sut.isFormValid(transactionName: transactionName, transactionPriceText: invalidPrice, transactionDate: validTransactionDate)
        XCTAssertFalse(isFormInvalid, "Form should be invalid when the transaction price is not a valid number.")
    }
    
    // MARK: - Date Validation Tests
    
    func testIsFormValid_ValidPastDate() {
        // Set up inputs with a valid past date
        let transactionName = "Groceries"
        let transactionPriceText = "50.00"
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())! // A date in the past
        
        // Assert valid past date
        let isValidOnPastDate = sut.isFormValid(transactionName: transactionName, transactionPriceText: transactionPriceText, transactionDate: pastDate)
        XCTAssertTrue(isValidOnPastDate, "Form should be valid when the transaction date is in the past.")
    }

    func testIsFormValid_InvalidFutureDate() {
        // Set up inputs with a future date
        let transactionName = "Groceries"
        let transactionPriceText = "50.00"
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())! // A date in the future
        
        // Assert invalid future date
        let isInvalidOnFutureDate = sut.isFormValid(transactionName: transactionName, transactionPriceText: transactionPriceText, transactionDate: futureDate)
        XCTAssertFalse(isInvalidOnFutureDate, "Form should be invalid when the transaction date is in the future.")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
