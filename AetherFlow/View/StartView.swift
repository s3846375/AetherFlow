//
//  StartView.swift
//  AetherFlow
//
//  This is the starting screen featuring the AetherFlow logo that uses the custom layout.
//
//  Created by Gabby Sanchez and Christina Tu on 14/8/2024.
//

import SwiftUI
import Auth0

/// The starting view of the AetherFlow app.
///
/// This view displays the app logo using the custom ``AetherFlowSineWaveLayout`` and prompts the user to log in via Auth0 to access the main app features.
///
/// - If the user is authenticated, the main view ``AetherFlowTabView`` is shown.
/// - Otherwise, the starting view includes a button prompting the user to log in.
struct StartView: View {
    
    /// Tracks whether the user is authenticated.
    @State var isAuthenticated = false
    
    /// Holds the user's profile data after logging in.
    @State var userProfile = User.empty
    
    var body: some View {
        if isAuthenticated {
            // Show the main app if the user is authenticated
            AetherFlowTabView(userProfile: $userProfile)
        } else {
            // Show the starting view when the user is not authenticated
            ZStack {
                // Background image
                Image("Forest")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Display the app logo
                    AetherFlowLogo
                        .padding(.vertical, 60)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Aether Flow Logo")
                    
                    // Button to initiate the login process
                    Button("Calculate Your Footprint") {
                        login()
                    }
                    .frame(minWidth: 70, minHeight: 5)
                    .padding(20)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    .background(.teal)
                    .cornerRadius(50)
                    .padding(20)
                    .accessibilityLabel("Calculate Your Footprint")
                    
                    Spacer()
                    Spacer()
                }
            }
        }
    }
    
    /// Displays the AetherFlow logo using a custom sine wave layout and animation.
    private var AetherFlowLogo: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 370, height: 250)
                .cornerRadius(15)
                .opacity(0.80)
            
            // Custom layout using sine wave
            AetherFlowSineWaveLayout(
                amplitude: amplitude,
                frequency: frequency,
                margin: margin,
                offset: offset
            ) {
                ForEach(subviews.indices, id: \.self) { _ in
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.teal)
                        .opacity(0.8)
                }
            }
            .frame(width: 300, height: 150)
            
            Text("Aether Flow")
                .font(.system(size: 42))
                .bold()
                .shadow(radius: 10)
        }
        .onAppear {
            startAnimation() // Starts the sine wave animation
        }
    }
    
    // MARK: - State Properties
    
    /// Controls the amplitude of the sine wave in the logo.
    @State private var amplitude: CGFloat = 45
    
    /// Controls the phase shift of the sine wave animation.
    @State private var phaseShift: Double = 0.0
    
    /// Controls the frequency of the sine wave.
    @State private var frequency: Double = 5
    
    /// Controls the margin between sine wave subviews.
    @State private var margin: Double = 12.0
    
    /// Tracks the current offset of the sine wave animation.
    @State private var offset: CGFloat = 0.0
    
    /// An array of indices representing the subviews used in the sine wave layout.
    @State private var subviews = Array(0..<12)
    
    // MARK: - Animation
    
    /// Starts the animation for the sine wave logo, incrementing the offset over time.
    ///
    /// This function uses a timer to continuously adjust the `offset` of the sine wave.
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(Animation.linear(duration: 0.0)) {
                offset += 0.01
                
                if offset >= 300 {
                    offset = 0
                }
            }
        }
    }
}

// MARK: - Auth0 Login

extension StartView {
    /// Initiates the login process using Auth0.
    ///
    /// When the user successfully logs in, their profile is fetched from the `idToken` and stored in `UserDefaults`.
    /// If the login fails, the error is logged in the console.
    func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .failure(let error):
                    print("Failed with: \(error)")
                    
                case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile = User.from(credentials.idToken)
                    print("Credentials: \(credentials)")
                    print("ID token: \(credentials.idToken)")
                    
                    UserDefaults.standard.set(userProfile.id, forKey: "userId")
                    UserDefaults.standard.set(userProfile.name, forKey: "username")
                }
            }
    }
}

#Preview {
    StartView()
}
