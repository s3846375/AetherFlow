//
//  AddTransactionsView.swift
//  AetherFlow
//
//  One of five screens implemented for Assignment 1.
//  This screen is part of AetherFlow's Footprint feature.
//  This screen allows users to add transaction logs based on their specified
//      category, name, price and date.
//
//  Created by Gabby Sanchez and Christina Tu on 18/8/2024.
//

import SwiftUI
import SwiftData

/// A sheet view for adding a new transaction entry. It includes a form with sections for selecting a category, entering transaction details, and setting a date.
///
/// The `AddFootprintView` view allows the user to add a new transaction entry to their carbon footprint log.
/// This view includes a form with sections for selecting a category, and entering transaction details such as name, price, and date.
/// After filling out the form, the user can add the transaction, triggering the app to call the Connect Earth API to calculate carbon emissions,
/// and storing the result along with the transaction data in the local database.
///
/// The view validates the input fields before allowing submission, ensuring that all required data is entered correctly.
struct AddFootprintView: View {
    /// The environment variable for accessing the model context in SwiftData for database operations.
    @Environment(\.modelContext) private var modelContext
    
    /// Controls the dismissal of the view when the user finishes adding a transaction.
    @Binding var isPresented: Bool
    
    /// The category selected for the transaction.
    @State var selectedCategory: TransactionGroup = .groceries
    
    /// The name or description of the transaction.
    @State var transactionName: String = ""
    
    /// The price of the transaction, represented initially as a text string to allow for validation and formatting.
    @State var transactionPriceText: String = ""
    
    /// The date and time when the transaction occurred.
    @State var transactionDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                // Transaction Category Picker
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(TransactionGroup.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .accentColor(.teal)
                    .pickerStyle(MenuPickerStyle())
                    .accessibilityLabel("Transaction Category Picker")
                    .accessibilityHint("Choose a category for the transaction")
                }
                
                // Transaction Details Input Fields
                Section(header: Text("Details")) {
                    TextField("Name", text: $transactionName)
                        .accessibilityLabel("Transaction Name")
                        .accessibilityHint("Enter the name of the transaction")
                    
                    HStack {
                        Text("$")
                        TextField("Price", text: $transactionPriceText)
                            .keyboardType(.decimalPad)
                            .accessibilityLabel("Transaction Price")
                            .accessibilityHint("Enter the price of the transaction in Australian Dollars")
                    }
                    
                    DatePicker("Date", selection: $transactionDate, displayedComponents: [.date, .hourAndMinute])
                        .accessibilityLabel("Transaction Date")
                        .accessibilityHint("Select the date and time of the transaction")
                }
            }
            .navigationTitle("Add Footprint")
            .navigationBarItems(
                leading:
                    // Dismiss the form
                    Button("Back") {
                        isPresented = false
                    }
                    .foregroundColor(.teal)
                    .accessibilityLabel("Back Button")
                    .accessibilityHint("Dismisses the add transaction view"),
                trailing:
                    // Add transaction button, disabled until form validation passes
                    Button("Add") {
                        Task {
                            await handleAddTransaction()
                            UserDefaults.standard.set(true, forKey: "reloadMetrics")
                            isPresented = false
                        }
                    }
                    .foregroundColor(isFormValid(transactionName: transactionName, transactionPriceText: transactionPriceText, transactionDate: transactionDate) ? .teal : .gray)
                    .disabled(!isFormValid(transactionName: transactionName, transactionPriceText: transactionPriceText, transactionDate: transactionDate))
                    .accessibilityLabel("Add Transaction")
                    .accessibilityHint("Adds the transaction to your footprint log")
            )
        }
    }
    
    // MARK: - Validation
    /// Validates the form fields for transaction entry, ensuring that the transaction name is not empty, the price is a valid numeric value, and the date is not in the future.
    ///
    /// - Parameters:
    ///   - transactionName: A `String` representing the name or description of the transaction.
    ///   - transactionPriceText: A `String` representing the price of the transaction.
    ///   - transactionDate: A `Date` representing when the transaction occurred.
    ///
    /// - Returns: A Boolean value indicating whether the form is valid and ready for submission. Returns `true` if all conditions are met: the transaction name is non-empty, the price can be successfully parsed as a number, and the transaction date is not in the future.
    func isFormValid(transactionName: String, transactionPriceText: String, transactionDate: Date) -> Bool {
        guard Double(transactionPriceText) != nil else {
            return false
        }
        guard transactionDate <= Date() else {
            return false
        }
        
        return !transactionName.isEmpty && !transactionPriceText.isEmpty
    }
    
    // MARK: - API and Data Handling
    /// Handles the transaction submission process by validating input, sending the transaction data to the Connect Earth API,
    /// and saving the transaction details to the local database.
    ///
    /// - The transaction is only saved if the form passes validation and the API call is successful.
    private func handleAddTransaction() async {
        guard isFormValid(transactionName: transactionName, transactionPriceText: transactionPriceText, transactionDate: transactionDate) else { return }
        
        do {
            let responseData = try await APIService.calculateEmissions(
                mccCode: selectedCategory.mccCode,
                transactionName: transactionName,
                transactionPrice: Double(transactionPriceText)!,
                transactionDate: transactionDate,
                groupName: selectedCategory.rawValue
            )
            
            saveTransaction(response: responseData,
                            group: selectedCategory.rawValue,
                            transactionName: transactionName,
                            transactionPriceText: transactionPriceText,
                            transactionDate: transactionDate)
        } catch {
            print("Add Transaction Error: \(error)")
        }
    }
    
    /// Saves the transaction details in the local SwiftData model context.
    ///
    /// - Parameters:
    ///   - response: The response data from the Connect Earth API, including carbon emissions.
    ///   - group: The category of the transaction (e.g., "Groceries").
    ///   - transactionName: The name or description of the transaction.
    ///   - transactionPriceText: The price of the transaction as a string.
    ///   - transactionDate: The date when the transaction occurred.
    func saveTransaction(response: AddTransactionResponse,
                         group: String,
                         transactionName: String,
                         transactionPriceText: String,
                         transactionDate: Date) {
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            let newTransaction = Transaction(
                userId: savedUserId,
                group: selectedCategory.rawValue,
                name: transactionName,
                price: Double(transactionPriceText)!,
                mcc: selectedCategory.mccCode,
                kgEmissions: response.kgEmissions,
                mtEmissions: response.mtEmissions,
                equivalents: response.similarTo,
                timestamp: transactionDate
            )
            modelContext.insert(newTransaction)
        } else {
            print("No userId found in UserDefaults")
        }
    }
}

#Preview {
    AddFootprintView(isPresented: .constant(true))
}
