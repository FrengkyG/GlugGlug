//
//  GlugGlugApp.swift
//  GlugGlug
//
//  Created by Frengky Gunawan on 19/03/25.
//

import SwiftUI


class ColorScheme {
    
}

@main

struct GlugGlugApp: App {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
        }
    }
}
