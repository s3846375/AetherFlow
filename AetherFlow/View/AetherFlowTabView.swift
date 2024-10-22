//
//  TabView.swift
//  AetherFlow
//
//  The view responsible for rendering AetherFlow's feature list menu through the usage of a TabView.
//
//  Created by Gabby Sanchez and Christina Tu on 18/8/2024.
//

import SwiftUI

/// The main view responsible for navigating between the core features of the AetherFlow app through a `TabView`.
///
/// The `AetherFlowTabView` allows users to switch between four main features: 'Profile', 'Footprint', 'Challenge', and 'Diet'.
/// If the user is authenticated, the tab view is presented; otherwise, the `StartView` is shown.
///
/// - Parameters:
///   - isAuthenticated: A `@State` variable that tracks whether the user is authenticated.
///   - userProfile: A `@Binding` to the user's profile data.
struct AetherFlowTabView: View {
    
    /// Tracks the user's authentication status.
    @State private var isAuthenticated = true
    
    /// A binding to the user's profile data.
    @Binding var userProfile: User
    
    var body: some View {
        if isAuthenticated {
            TabView {
                // Displays the ProfileMetricsView tab
                ProfileMetricsView(isAuthenticated: $isAuthenticated)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                            .accessibilityLabel("Profile Tab")
                    }
                
                // Displays the FootprintView tab
                FootprintView()
                    .tabItem {
                        Label("Footprint", systemImage: "shoeprints.fill")
                            .accessibilityLabel("Footprint Tab")
                    }
                    .tag(0)
                
                // Displays the ChallengeCategoriesView tab
                ChallengeCategoriesView()
                    .tabItem {
                        Label("Challenge", systemImage: "leaf.fill")
                            .accessibilityLabel("Challenge Tab")
                    }
                    .tag(1)
                
                // Displays the DietView tab
                DietView()
                    .tabItem {
                        Label("Diet", systemImage: "star.fill")
                            .accessibilityLabel("Diet Tab")
                    }
                    .tag(3)
            }
            .tint(.teal)
        } else {
            // Show the StartView if the user is not authenticated
            StartView()
        }
    }
}

#Preview {
    AetherFlowTabView(userProfile: .constant(User.empty))
}
