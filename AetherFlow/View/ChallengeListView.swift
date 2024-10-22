//
//  ChallengeListView.swift
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
import SwiftData
import UIKit
import AVKit

/// A view that displays a list of carbon footprint reduction challenges filtered by a selected category.
///
/// This view retrieves the user's current list of `Diet` entries from the local database and filters for incomplete challenges.
/// Each challenge is associated with a specific category (e.g., Food, Clothes, Energy, Transport). If a challenge has not already been added by the user, a button is provided for adding it to their diet list.
struct ChallengeListView: View {
    
    /// Access to the SwiftData model context for performing database operations.
    @Environment(\.modelContext) private var modelContext
    
    /// Queries the current user's diet (challenges they are working on) from the local database.
    @Query private var diets: [Diet]
    
    /// Handles loading the list of challenges from a data source.
    @ObservedObject private var challengeData = ReadChallengeData()
    
    /// Filters the list of challenges based on the selected category.
    private var filteredChallenges: [Challenge] {
        challengeData.challenges.filter { $0.category == challengeCategory.id }
    }
    
    /// The challenge category to display
    private let challengeCategory: ChallengeCategoryView
    
    /// Initializes the view with the selected category and retrieves the user's incomplete diets.
    ///
    /// - Parameter challengeCategory: The category of challenges to display, such as "Food", "Clothes", "Energy", or "Transport".
    init(challengeCategory: ChallengeCategoryView) {
        self.challengeCategory = challengeCategory
        
        // Filter user diets for incomplete challenges based on the `userId` stored in UserDefaults.
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            _diets = Query(filter: #Predicate { diet in
                diet.userId == savedUserId && diet.isComplete == false })
        } else {
            print("No userId found in UserDefaults")
        }
    }
    
    /// Checks if a specific challenge is already part of the user's ongoing diet list.
    ///
    /// - Parameters:
    ///   - list: A list of `Diet` entries representing the user's ongoing challenges.
    ///   - subCategory: The subcategory of the challenge to check.
    /// - Returns: A Boolean value indicating whether the challenge is already in the user's diet list.
    func dietContainsChallenge(list: [Diet], subCategory: String) -> Bool {
        return list.contains(where: { $0.challenge == subCategory })
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:
                    VStack {
 
                    VideoPlayer(url: Bundle.main.url(forResource: "\(challengeCategory.video)", withExtension: "mp4")!)
                        .frame(width: 350, height: 150)
                        .scaleEffect(1.5)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 10)
                        .accessibilityLabel("\(challengeCategory.name)")
                    }
                    .frame(maxWidth: .infinity))
                {
                    // Display the list of challenges filtered by the selected category.
                    ForEach(filteredChallenges) { challenge in
                        HStack {
                            Text(challenge.subCategory)
                                .font(.headline)
                            
                            Spacer()
                            
                            // If the challenge is not in the user's diet list, show a button to add it.
                            if !dietContainsChallenge(list: diets, subCategory: challenge.subCategory) {
                                Button("", systemImage: "plus.circle") {
                                    if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
                                        let newDiet = Diet(userId: savedUserId, challenge: challenge.subCategory)
                                        modelContext.insert(newDiet)
                                    } else {
                                        print("No userId found in UserDefaults")
                                    }
                                }
                                .foregroundColor(.gray)
                                .imageScale(.large)
                                .accessibilityLabel("Add Challenge")
                            } else {
                                Spacer()
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("\(challengeCategory.name)")
        }
    }
}

// MARK: - UIkit video player

/// Intergrates UIKit AVPlayer in SwiftUI. Automatically plays and loops the video when the view is loaded.
struct VideoPlayer: UIViewControllerRepresentable {
    
    var url: URL
    
    // Create properties to hold player and looper
    class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        // Create AVQueuePlayer for looping
        let player = AVQueuePlayer()
        context.coordinator.player = player
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        // Set up the looper and hold it in the coordinator
        context.coordinator.looper = AVPlayerLooper(player: player, templateItem: playerItem)

        // Create AVPlayerViewController
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        // Automatically start playing video when load view
        player.play()
        
        // Disable user play/pause controls
        playerController.showsPlaybackControls = false
        
        return playerController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}



#Preview {
    ChallengeListView(challengeCategory: ChallengeCategoryView(id: "transport", name: "Transport", icon: "car.fill", video: "transportVideo"))
        .modelContainer(Diet.preview)
}
