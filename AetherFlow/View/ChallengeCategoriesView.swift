//
//  ChallengeCategoriesView.swift
//  AetherFlow
//
//  One of five screens implemented for Assignment 1.
//  This screen is part of AetherFlow's Challenge feature.
//  The Challenge feature enables users to select and undertake carbon footprint reduction challenges
//      tailored to specific categories they want to focus on.
//
//  Created by Gabby Sanchez and Christina Tu on 18/8/2024.
//

import SwiftUI

/// A view displaying a grid of carbon footprint reduction challenge categories for the user to select.
///
/// Each category represents an area of focus (e.g., Food, Clothes, Energy, Transport) and leads to a list of relevant challenges.
/// Users can select a category by tapping its icon, which navigates to the `ChallengeListView` where challenges related to the selected category are presented.
struct ChallengeCategoriesView: View {
    
    /// A list of predefined challenge categories, each represented by an id, name, and SF symbol icon.
    private let categories = [
        ChallengeCategoryView(
            id: "food",
            name: "Food",
            icon: "takeoutbag.and.cup.and.straw.fill",
            video: "foodVideo"
        ),
        ChallengeCategoryView(
            id: "clothing",
            name: "Clothes",
            icon: "tshirt.fill",
            video: "clothesVideo"
        ),
        ChallengeCategoryView(
            id: "energy",
            name: "Energy",
            icon: "house.fill",
            video: "energyVideo"
        ),
        ChallengeCategoryView(
            id: "transport",
            name: "Transport",
            icon: "car.fill",
            video: "transportVideo"
        )
    ]
    
    /// A two-column grid layout with fixed width for the category items.
    private var twoColumnGridLayout = [GridItem(.fixed(160), spacing: 10), GridItem(.fixed(160), spacing: 10)]
    
    var body: some View {
        NavigationStack {
            VStack {
                // A grid of challenge categories, each wrapped in a NavigationLink to the challenge list view.
                LazyVGrid(columns: twoColumnGridLayout, spacing: 20) {
                    ForEach(categories) { category in
                        NavigationLink(destination: ChallengeListView(challengeCategory: category)) {
                            category
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Challenges")
        }
    }
}

// MARK: - Challenge Categories Item View

/// A view that represents an individual challenge category.
///
/// The view displays an icon and a category name, styled as a square item with a teal background.
/// Tapping on this view navigates to the `ChallengeListView`, where users can explore challenges under the selected category.
///
/// - Parameters:
///   - id: The unique identifier for the category.
///   - name: The name of the category, e.g., "Food", "Clothes", "Energy", "Transport".
///   - icon: The SF symbol name used to represent the category visually.
struct ChallengeCategoryView: View, Identifiable {
    let id: String
    let name: String
    let icon: String
    let video: String
    
    var body: some View {
        VStack {
            // Icon representation for the category
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .padding()
                .frame(width: 150, height: 150)
                .background(.teal)
                .cornerRadius(10)
            
            // Display the name of the category
            Text(name)
                .font(.headline)
                .foregroundColor(.black)
                .accessibilityLabel("\(name)")
        }
    }
}

#Preview {
    ChallengeCategoriesView()
}
