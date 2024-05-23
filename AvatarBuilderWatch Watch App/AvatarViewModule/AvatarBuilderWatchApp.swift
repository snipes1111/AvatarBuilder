//
//  AvatarBuilderWatchApp.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//

import SwiftUI

@main
struct AvatarBuilderWatch_Watch_AppApp: App {
    
    @StateObject private var viewModel = AvatarViewModel()
    
    var body: some Scene {
        WindowGroup {
            AvatarOverviewView()
                .environmentObject(viewModel)
        }
    }
}
