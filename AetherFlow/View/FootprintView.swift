//
//  TransactionsView.swift
//  AetherFlow
//
//  One of five screens implemented for Assignment 1.
//  This screen is part of AetherFlow's Footprint feature.
//  This feature allows users to view each transaction's associated carbon footprint data.
//
//  Created by Gabby Sanchez and Christina Tu on 18/8/2024.
//

import SwiftUI
import SwiftData

/// A view that displays a list of transactions stored in the local database, sorted by timestamp in descending order.
/// 
/// The `FootprintView` displays a list of user transactions from the local database,
/// sorted by their timestamp in descending order, and filtered by the `userId`.
/// Each transaction is shown with details such as the name, date, price, and associated carbon emissions.
/// The view also allows users to add, navigate to display equivalent information, and delete transactions.
struct FootprintView: View {
    /// Access to the SwiftData model context for performing database operations.
    @Environment(\.modelContext) private var modelContext

    /// Fetches transactions from the local database, sorted by `timestamp` in reverse order (newest to oldest),
    /// and filtered by the `userId`.
    @Query var transaction: [Transaction]
    
    /// Controls the presentation of the sheet for adding a new transaction.
    @State private var isAddingTransaction = false
    
    /// Initializes the view, filtering transactions based on the `userId` stored in `UserDefaults`.
    ///
    /// The transactions are fetched and filtered by the `userId` value. If the `userId` is not found in `UserDefaults`, a message is logged.
    init() {
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            // Filters transactions by the saved user ID
            _transaction = Query(filter: #Predicate { transaction in
                transaction.userId == savedUserId
            }, sort: \Transaction.timestamp, order: .reverse)
        } else {
            print("No userId found in UserDefaults")
        }
    }
    
    var body: some View {
        NavigationStack {
            // List of transactions
            List {
                Section(header: Text("Transactions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                    .accessibilityLabel("Transaction List")
                ) {
                    if !transaction.isEmpty {
                        // Displays each transaction as a row in the list.
                        ForEach(transaction) { transaction in
                            NavigationLink(destination: FootprintEquivalentsListView(
                                emissionsTotal: transaction.kgEmissions,
                                equivalents: transaction.equivalents,
                                name: transaction.name))
                            {
                                FootprintTransactionRowView(transaction: transaction)
                            }
                        }
                        .onDelete { indexSet in
                            // Deletes the selected transaction from the database.
                            for index in indexSet {
                                let item = transaction[index]
                                modelContext.delete(item)
                                UserDefaults.standard.set(true, forKey: "reloadMetrics")
                            }
                        }
                    } else {
                        // Placeholder text when there are no transactions
                        Text("You currently have no recorded transactions.")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("No Transactions")
                            .accessibilityHint("You currently have no recorded transactions.")
                    }
                }
            }
            // Presents a sheet to add a new transaction.
            .sheet(isPresented: $isAddingTransaction) {
                AddFootprintView(isPresented: $isAddingTransaction)
            }
            .navigationTitle("Footprint")
            .toolbar {
                // Toolbar item for adding a new transaction.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingTransaction = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.teal)
                    }
                    .accessibilityLabel("Add New Transaction")
                    .accessibilityHint("Opens a form to add a new transaction")
                }
            }
        }
    }
}

// MARK: - Footprint Transaction Row View

/// A view that displays a single row of transaction details in the `FootprintView`.
///
/// Each row contains:
/// - A circular icon representing the transaction category.
/// - The name of the transaction.
/// - The date of the transaction.
/// - The price of the transaction.
/// - The calculated carbon emissions (CO2) of the transaction, measured in kilograms.
struct FootprintTransactionRowView: View {
    /// The transaction to display in this row.
    var transaction: Transaction
    
    /// A date formatter to format the transaction timestamp.
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        HStack {
            // Displays the category icon
            if let group = TransactionGroup(rawValue: transaction.group) {
                ZStack {
                    Circle()
                        .fill(.teal)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: group.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.white)
                        .accessibilityLabel("\(group.rawValue) icon")
                }
                .padding(.leading, -4)
                .padding(.trailing, 4)
            }

            // Display transaction details: name and timestamp.
            VStack(alignment: .leading) {
                Text(transaction.name)
                    .font(.headline)
                    .accessibilityLabel("Transaction name: \(transaction.name)")
                Text(Self.dateFormatter.string(from: transaction.timestamp))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Date: \(Self.dateFormatter.string(from: transaction.timestamp))")
            }

            Spacer()

            // Display transaction price and calculated carbon emissions.
            VStack(alignment: .trailing) {
                Text(String(format: "$%.2f", transaction.price))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("Price: $\(String(format: "%.2f", transaction.price))")
                
                HStack(spacing: 4){
                    Text(String(format: "%.2f", transaction.kgEmissions))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                    Text("kg CO2")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                .accessibilityLabel("Carbon emissions: \(String(format: "%.2f", transaction.kgEmissions)) kilograms of CO2")
            }
        }
        .padding(.vertical, 8)
        .accessibilityHint("Swipe left to delete this transaction")
    }
}

// MARK: - Transaction Group Enum

/// An enumeration that categorizes different types of transactions based on their group.
///
/// Each case in the enumeration represents a category of transaction and provides:
/// - A system icon name for visual representation.
/// - A merchant category code (MCC) that categorizes the type of transaction.
enum TransactionGroup: String, CaseIterable {
    case groceries = "Groceries"
    case cafesAndRestaurants = "Cafes and Restaurants"
    case fuel = "Fuel"
    case clothing = "Clothing"
    case digitalGoods = "Digital Goods"
    case airfare = "Airfare"
    case lodging = "Lodging"
    
    /// Returns the corresponding system icon name for the transaction category.
    var iconName: String {
        switch self {
        case .groceries:
            return "cart.fill"
        case .cafesAndRestaurants:
            return "fork.knife"
        case .clothing:
            return "tshirt.fill"
        case .lodging:
            return "bed.double.fill"
        case .digitalGoods:
            return "desktopcomputer"
        case .fuel:
            return "fuelpump.fill"
        case .airfare:
            return "airplane"
        }
    }
    
    /// Returns the MCC code associated with the transaction category.
    var mccCode: String {
        switch self {
        case .groceries:
            return "5411"
        case .cafesAndRestaurants:
            return "5812"
        case .clothing:
            return "5691"
        case .lodging:
            return "3501"
        case .digitalGoods:
            return "5732"
        case .fuel:
            return "5541"
        case .airfare:
            return "3012"
        }
    }
    
    /// Returns the metric group associated with the transaction category.
    var metricGroup: String {
        switch self {
        case .groceries, .cafesAndRestaurants:
            return "Food"
        case .clothing:
            return "Clothing"
        case .lodging, .digitalGoods:
            return "Energy"
        case .fuel, .airfare:
            return "Transport"
        }
    }
}

#Preview {
    FootprintView()
        .modelContainer(Transaction.preview)
}
