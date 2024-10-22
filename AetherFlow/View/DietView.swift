//
//  DietView.swift
//  AetherFlow
//
//  Created by Gabby Sanchez and Christina Tu on 2024/9/21.
//

import SwiftUI
import SwiftData

/// A view that displays a list of completed and ongoing challenges associated with the user, retrieved from the local database.
///
/// The `DietView` is divided into two sections:
/// - **Completed Challenges**: Displayed in a horizontal grid, showing the name and count of each completed challenge.
/// - **Ongoing Challenges**: Displayed in a list, where each challenge can be swiped to delete or long-pressed to enable a drag gesture.
///   If the user drags the challenge down and then up, it marks the challenge as completed.
struct DietView: View {
    
    /// Access to the SwiftData model context for performing database operations.
    @Environment(\.modelContext) private var modelContext
    
    /// Fetches diet data for the current user.
    @Query private var diets: [Diet]
    
    /// Retrieves the user's diets (ongoing and completed) when initializing the view.
    ///
    /// The query is filtered by the `userId` stored in `UserDefaults`.
    init() {
        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            _diets = Query(filter: #Predicate { diet in
                diet.userId == savedUserId
            })
        } else {
            print("No userId found in UserDefaults")
        }
    }
    
    /// Filters the list of diets to only those that are completed.
    private var completeDiets: [Diet] {
        diets.filter { $0.isComplete }
    }
    
    /// Layout configuration for the grid used to display completed challenges.
    private var gridItemLayout = [GridItem(.fixed(200))]
    
    /// Calculates the counts of completed diets, returning a dictionary of challenge names and their counts.
    /// - Parameter dietList: The list of `Diet` objects to count.
    /// - Returns: A dictionary where the keys are challenge names and the values are their respective counts.
    func countChallenges(dietList: [Diet]) -> [String: Int] {
        var challengeCountDict: [String: Int] = [:]
        for diet in dietList {
            if let count = challengeCountDict[diet.challenge] {
                challengeCountDict[diet.challenge] = count + 1
            } else {
                challengeCountDict[diet.challenge] = 1
            }
        }
        return challengeCountDict
    }
    
    /// Removes the user-selected item from the database storing diets.
    /// - Parameter offsets: The index set of items to be deleted.
    private func deleteDiet(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = diets[index]
            modelContext.delete(itemToDelete)
        }
    }
    
    /// Variables to track user interactions with challenges in the ongoing section.
    @State private var position = CGPoint.zero
    @State private var isTextVisible = false
    @State private var tappedItem: Diet? = nil
    @State private var dragOffset = CGSize.zero
    @State private var isDragDownFirst = false
    
    var body: some View {
        let challengeCountDict = countChallenges(dietList: completeDiets)
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("Completed challenges")
                    .font(.title3)
                    .padding(.leading)
                    .accessibilityLabel("Completed challenges")
                
                // Horizontal scroll view displaying completed challenges in a grid
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout) {
                        ForEach(challengeCountDict.keys.sorted(), id: \.self) { key in
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.yellow)
                                        .rotationEffect(.degrees(45))
                                    
                                    Text("\(key)")
                                        .padding(10)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.black)
                                        .background(.yellow)
                                        .padding(.vertical, 20)
                                        .accessibilityLabel("\(key)")
                                }
                                // Display the count of completed challenges
                                if let count = challengeCountDict[key] {
                                    Text("x \(count)")
                                        .foregroundColor(.gray)
                                        .accessibilityLabel("Completed \(count) times")
                                }
                            }
                            .frame(width: 100, height: 100)
                            .background(.white)
                            .padding(30)
                        }
                    }
                }
                
                // Ongoing challenge list section with custom gestures
                Text("Ongoing challenges")
                    .font(.title3)
                    .padding(.leading)
                    .accessibilityLabel("Ongoing challenges")
                
                ZStack {
                    List {
                        ForEach(diets) { diet in
                            if !diet.isComplete {
                                Text(diet.challenge)
                                    .padding(15)
                                    .border(.yellow, width: 3)
                                    .cornerRadius(5)
                                    .listRowSeparator(.hidden)
                                    .accessibilityLabel("\(diet.challenge)")
                                    // Detect long press gesture to enable drag functionality
                                    .onLongPressGesture {
                                        tappedItem = diet
                                        isTextVisible = true
                                    }
                            }
                        }
                        .onDelete(perform: deleteDiet)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    
                    // Capture the position of the long-pressed item
                    GeometryReader { geometry in
                        Color.clear
                            .frame(width: 300)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        position = CGPoint(x: geometry.size.width / 2, y: value.location.y)
                                    }
                            )
                    }
                    
                    // Show the dragged challenge text when the item is long-pressed
                    if isTextVisible, let item = tappedItem {
                        Text("\(item.challenge)")
                            .foregroundColor(.black)
                            .padding()
                            .frame(minWidth: 350, minHeight: 50, alignment: .leading)
                            .background(.yellow)
                            .cornerRadius(10)
                            .accessibilityLabel("\(item.challenge)")
                            .position(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // Record the user drag down action
                                        if !isDragDownFirst {
                                            if value.translation.height > 0 {
                                                isDragDownFirst = true
                                            }
                                        }
                                        
                                        // Update drag offset as the user drags the text
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        // Check if the first drag was downward followed by an upward drag
                                        if isDragDownFirst && value.translation.height < 0 {
                                            print("First drag was downward followed by an upward drag!")
                                            item.isComplete = true
                                        } else {
                                            print("Not right!")
                                        }
                                        
                                        // Reset states for gesture
                                        isTextVisible = false
                                        tappedItem = nil
                                        isDragDownFirst = false
                                        dragOffset = .zero
                                    }
                            )
                            .animation(.easeInOut, value: dragOffset)
                    }
                }
            }
            .navigationTitle("Carbon Diet")
        }
    }
}

#Preview {
    DietView()
        .modelContainer(Diet.preview)
}
