//
//  ProfileView.swift
//  AetherFlow
//
//  Created by Gabby Sanchez and Christina Tu on 2024/9/22.
//

import SwiftUI
import Charts
import Auth0
import SwiftData
import WidgetKit

/// A view that displays user transaction history and carbon emissions statistics, such as total emissions, emission breakdowns, and monthly progress.
///
/// This view retrieves user transaction history from the local database, allowing users to view their carbon emissions statistics, including
/// the latest month's total emissions, emission breakdown, and monthly progress.
///
/// The toolbar includes a button for users to log out.
/// The view also handles saving widget data for external display.
struct ProfileMetricsView: View {
    /// Access to the SwiftData model context for performing database operations.
    @Environment(\.modelContext) private var modelContext
    
    /// Fetches a single profile metric from the local database, filtered by `userId`.
    @Query var profileMetrics: [ProfileMetric]
    
    /// Fetches transactions from the local database, sorted by `timestamp` in reverse order (newest to oldest),
    /// and filters them by the `userId`.
    @Query var transaction: [Transaction]
    
    @Binding var isAuthenticated: Bool
    
    @State private var isLoadingMetrics = false
    
    /// Initializes the view, retrieving the profile metric based on the `userId` stored in `UserDefaults`.
    ///
    /// The profile metric data is fetched and filtered by the `userId` value. If the `userId` is not found in `UserDefaults`, a message is logged.
    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
        
        // Retrieve `userId` from UserDefaults on appear
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            // Filters the profile metric by the saved user ID
            _profileMetrics = Query(filter: #Predicate { profileMetric in
                profileMetric.userId == savedUserId
            }, sort: \ProfileMetric.timestamp, order: .reverse)
            
            _transaction = Query(filter: #Predicate { transaction in
                transaction.userId == savedUserId
            }, sort: \Transaction.timestamp, order: .reverse)
        } else {
            print("No userId found in UserDefaults")
        }
    }
    
    var body: some View {
        NavigationView {
            if isLoadingMetrics {
                // Display a placeholder or loading view
                ProgressView("Loading metrics...")
                
            } else if !transaction.isEmpty && !profileMetrics.isEmpty {
                // Display the main content if transactions and profile metrics are available.
                VStack(alignment: .leading){
                    monthlyEmissionSection
                        .padding(.vertical,10)
                    monthlyBreakdownSection
                        .padding(.vertical,10)
                    // If there are multiple profile metrics, show the progress section.
                    if profileMetrics.count > 1 {
                        progressSection
                            .padding(.vertical,10)
                    } else {
                        Spacer()
                    }
                }
                .padding()
                .navigationTitle(UserDefaults.standard.string(forKey: "username") ?? "User")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout"){
                            logout()
                        }
                        .foregroundColor(.teal)
                        .accessibilityLabel("Logout")
                    }
                }
            } else {
                VStack(alignment: .leading){
                    // Placeholder text when there are no transactions
                    Text("You currently have no recorded transactions within the last twelve months.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityLabel("No Transactions")
                        .accessibilityHint("You currently have no recorded transactions within the last twelve months.")
                }
                .padding()
                .navigationTitle(UserDefaults.standard.string(forKey: "username") ?? "User")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout"){
                            logout()
                        }
                        .foregroundColor(.teal)
                        .accessibilityLabel("Logout")
                    }
                }
            }
        }.onAppear() {
            Task {
                if !transaction.isEmpty {
                    // If there are transactions but no profile metrics, or if metrics need reloading.
                    if profileMetrics.isEmpty || UserDefaults.standard.string(forKey: "reloadMetrics") != nil {
                        isLoadingMetrics = true
                        await clearProfileMetrics()
                        await generateProfileMetrics()
                        UserDefaults.standard.removeObject(forKey: "reloadMetrics")
                        isLoadingMetrics = false
                    }
                    
                    // Save data for the widget once metrics are available
                    saveWidgetData(profileMetric: profileMetrics.first, profileMetricGroups: profileMetrics.first?.groups ?? [])
                }
            }
        }
    }
    
    /// Displays user latest transaction record month carbon emission and a horizontal bar chart comparing the user's emissions with averages.
    private var monthlyEmissionSection: some View {
        VStack(alignment: .leading){
            let latestMonthEmission = profileMetrics.first?.month ?? ""
            Text("\(latestMonthEmission) carbon emission")
                .font(.title3)
                .foregroundColor(.gray)
                .accessibilityLabel("\(latestMonthEmission) carbon emission")
            
            HStack {
                Spacer()
                NavigationLink(destination: FootprintEquivalentsListView(emissionsTotal: profileMetrics.first!.emissionsTotal, equivalents: profileMetrics.first!.equivalents))
                {
                    Text("\(String(format: "%.2f", profileMetrics.first?.emissionsTotal ?? 0)) kg")
                        .padding(10)
                        .font(.title2)
                        .frame(width: 200, height: 60)
                        .foregroundColor(.primary)
                        .background(.yellow)
                        .cornerRadius(15)
                        .accessibilityLabel("\(String(format: "%.2f", profileMetrics.first?.emissionsTotal ?? 0)) kg")
                }
                Spacer()
            }
            
            // Data points for transpose Bar chart (user vs. AU average vs. World average)
            let transBarData: [BarDataPoint] = [
                BarDataPoint(category: "You", value: profileMetrics.first?.emissionsTotal ?? 0),
                BarDataPoint(category: "AU avg", value: 1280),
                BarDataPoint(category: "World avg", value: 400)
            ]
            
            // Transpose Bar chart
            Chart(transBarData) { dataPoint in
                BarMark(
                    x: .value("Value", dataPoint.value),
                    y: .value("Month", dataPoint.category)
                )
                .foregroundStyle(.teal)
            }
            .frame(height: 100)
        }
    }
    
    /// Displays a vertical bar chart showing the latest month carbon emissions for each category.
    private var monthlyBreakdownSection: some View {
        VStack(alignment: .leading){
            Text("Monthly breakdown")
                .font(.title3)
                .foregroundColor(.gray)
                .accessibilityLabel("Monthly breakdown")
            
            // Bar chart
            Chart(profileMetrics.first?.groups ?? []) { profileMetricGroupItem in
                BarMark(
                    x: .value("Month", profileMetricGroupItem.group),
                    y: .value("Value", profileMetricGroupItem.emissions)
                )
                .foregroundStyle(.yellow)
            }
            .frame(height: 120)
        }
    }
    
    /// Displays a line chart of user's total carbon emissions for the last four months.
    private var progressSection: some View {
        VStack(alignment: .leading) {
            Text("Progress")
                .font(.title3)
                .foregroundColor(.gray)
                .accessibilityLabel("Progress")
            
            // Line chart
            Chart(profileMetrics.prefix(4).reversed()) { profileMetric in
                LineMark(
                    x: .value("Month", profileMetric.month),
                    y: .value("Emissions (kg CO2)", profileMetric.emissionsTotal)
                )
                .foregroundStyle(.teal)
                .lineStyle(StrokeStyle(lineWidth: 4))
            }
            .frame(height: 150)
        }
    }
    
    /// Clears all `ProfileMetric` objects initially queried
    private func clearProfileMetrics() async {
        do {
            // Delete each fetched profile metric from the context
            for profileMetric in profileMetrics {
                modelContext.delete(profileMetric)
            }
            
            // Save changes in the model context
            try modelContext.save()
            
            print("Successfully cleared all ProfileMetric records.")
        } catch {
        }
    }
    
    /// Calculates user's carbon emission metrics for the current and previous eleven months and saves the suggestions from API.
    private func generateProfileMetrics() async {
        do {
            // Define the current month and the previous three months.
            let calendar = Calendar.current
            let currentDate = Date()
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "LLLL" // Full month name format
            
            for monthOffset in 0...11 { // 0 for current month, 1 for last month, ..., 11 for eleven months ago
                guard let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: currentDate) else {
                    continue
                }
                
                // Get the month name (e.g., "October")
                let monthName = monthFormatter.string(from: monthDate)
                
                // Define start and end dates of the month
                let range = calendar.range(of: .day, in: .month, for: monthDate)
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))!
                let endOfMonth = calendar.date(byAdding: .day, value: (range?.count ?? 0) - 1, to: startOfMonth)!
                
                // Filter transactions within this month
                let filteredTransactions = transaction.filter {
                    $0.timestamp >= startOfMonth && $0.timestamp <= endOfMonth
                }
                
                // If there are no transactions for this month, skip it
                guard !filteredTransactions.isEmpty else { continue }
                
                // Calculate metrics for the filtered transactions
                let responseData = try await APIService.calculateMetrics(transactions: filteredTransactions)!
                
                // Save profile metric for this month
                saveProfileMetric(
                    month: monthName,
                    timestamp: startOfMonth,
                    calculateMetricsResponse: responseData
                )
            }
        } catch {
            print("Add Transaction Error: \(error)")
        }
    }
    
    /// Saves the calculated metric details in the local SwiftData model context.
    /// - Parameters:
    ///   - month: The name of the month for which the metric is being saved (e.g., "October").
    ///   - timestamp: The date representing the start of the month for which the metric is being calculated.
    ///   - calculateMetricsResponse: The response data from the Connect Earth API, containing detailed emissions, transaction counts, and breakdowns by category.
    private func saveProfileMetric(month: String, timestamp: Date, calculateMetricsResponse: CalculateMetricsResponse) {
        guard let savedUserId = UserDefaults.standard.string(forKey: "userId") else {
            print("No userId found in UserDefaults")
            return
        }
        
        let newProfileMetric = ProfileMetric(
            userId: savedUserId,
            emissionsTotal: calculateMetricsResponse.emissionsTotal,
            transactionCount: calculateMetricsResponse.transactionCount,
            equivalents: calculateMetricsResponse.equivalents,
            groups: [],
            month: month,
            timestamp: timestamp
        )
        
        let metricGroups = aggregateEmissions(groups: calculateMetricsResponse.groups)
        
        // Create ProfileMetricGroupItem for each main group that has data
        var groups: [ProfileMetricGroupItem] = []
        for (mainGroup, result) in metricGroups { // Sorting for a fixed order
            groups.append(
                ProfileMetricGroupItem(
                    group: mainGroup,
                    emissions: result.emissions,
                    count: result.count,
                    fractionOfTotal: result.fractionOfTotal
                )
            )
        }
        newProfileMetric.groups = groups
        
        modelContext.insert(newProfileMetric)
    }
    
    /// Aggregates emissions data into four main groups: "Food", "Clothing", "Energy", "Transport".
    /// - Parameter groups: The list of `CalculateMetricsGroup` from the API response.
    /// - Returns: A dictionary of aggregated emissions data, with keys being the group names and values being tuples of emissions, count, and fraction of total.
    func aggregateEmissions(groups: [CalculateMetricsGroup]) -> [String: (emissions: Double, count: Int, fractionOfTotal: Double)] {
        var metricGroups: [String: (emissions: Double, count: Int, fractionOfTotal: Double)] = [
            "Food": (emissions: 0, count: 0, fractionOfTotal: 0),
            "Clothing": (emissions: 0, count: 0, fractionOfTotal: 0),
            "Energy": (emissions: 0, count: 0, fractionOfTotal: 0),
            "Transport": (emissions: 0, count: 0, fractionOfTotal: 0)
        ]
        
        for group in groups {
            if let mainGroup = TransactionGroup(rawValue: group.group)?.metricGroup {
                metricGroups[mainGroup]?.emissions += group.result.emissions
                metricGroups[mainGroup]?.count += group.result.count
                metricGroups[mainGroup]?.fractionOfTotal += group.result.fractionOfTotal
            }
        }
        
        return metricGroups
    }
    
    /// Function to save the latest profile metric data to UserDefaults for the widget, and force AetherFlow's widgets to reload
    func saveWidgetData(profileMetric: ProfileMetric?, profileMetricGroups: [ProfileMetricGroupItem]) {
        guard let latestMetric = profileMetric else {
            print("No profile metrics available to save for the widget.")
            return
        }
        
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        
        // Save the total emissions and month
        defaults?.set(latestMetric.emissionsTotal, forKey: "totalEmissions")
        defaults?.set(latestMetric.month, forKey: "month")
        
        // Aggregate the emissions for each main group
        let foodEmissions = profileMetricGroups.first { $0.group == "Food" }?.emissions ?? 0
        let clothingEmissions = profileMetricGroups.first { $0.group == "Clothing" }?.emissions ?? 0
        let energyEmissions = profileMetricGroups.first { $0.group == "Energy" }?.emissions ?? 0
        let transportEmissions = profileMetricGroups.first { $0.group == "Transport" }?.emissions ?? 0
        
        // Save emissions data for each main group
        defaults?.set(foodEmissions, forKey: "foodEmissions")
        defaults?.set(clothingEmissions, forKey: "clothingEmissions")
        defaults?.set(energyEmissions, forKey: "energyEmissions")
        defaults?.set(transportEmissions, forKey: "transportEmissions")
        
        WidgetCenter.shared.reloadAllTimelines()
        
        print("Widget data successfully saved.")
    }
}

/// Represents a single data point used in the monthly breakdown bar chart of ProfileMetricsView, containing a category and a corresponding numeric value.
///
/// Each data point consists of a `category` (e.g., "Food", "Energy") and a `value` (e.g., carbon emissions in kilograms).
struct BarDataPoint: Identifiable {
    /// A unique identifier for the data point, automatically generated.
    let id = UUID()
    
    /// The category or label for the data point (e.g., "Food", "Energy").
    let category: String
    
    /// The numeric value associated with the category (e.g., carbon emissions in kilograms).
    let value: Double
}

/// Function for Auth0 to handle logout
extension ProfileMetricsView {
    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    UserDefaults.standard.removeObject(forKey: "userId")
                    UserDefaults.standard.removeObject(forKey: "username")
                    resetWidgetData()
                    self.isAuthenticated = false
                    print("Success")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    
    /// Function to reset the widget data saved in UserDefaults, and force AetherFlow's widgets to reload
    func resetWidgetData() {
        let defaults = UserDefaults(suiteName: "group.rmit.AetherFlow")
        
        // Reset all relevant widget data
        defaults?.removeObject(forKey: "totalEmissions")
        defaults?.removeObject(forKey: "month")
        defaults?.removeObject(forKey: "foodEmissions")
        defaults?.removeObject(forKey: "clothingEmissions")
        defaults?.removeObject(forKey: "energyEmissions")
        defaults?.removeObject(forKey: "transportEmissions")
        
        WidgetCenter.shared.reloadAllTimelines()
        
        print("Widget data successfully reset.")
    }
}

#Preview {
    ProfileMetricsView(isAuthenticated: .constant(true))
        .modelContainer(ProfileMetric.preview)
}
