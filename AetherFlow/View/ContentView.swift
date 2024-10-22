//
//  ContentView.swift
//  AetherFlow
//
//  Created by Gabby Sanchez and Christina Tu on 14/8/2024.
//

import SwiftUI

/// The starting scene of the app initialy set to ``StartView`` that prompts the user to log in.
struct ContentView: View {
    var body: some View {
        VStack{
            StartView()
        }
    }
}
#Preview {
    ContentView()
}
