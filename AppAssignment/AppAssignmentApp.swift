//
//  AppAssignmentApp.swift
//  AppAssignment
//
//  Created by Ankit Jain on 19/08/25.
//

import SwiftUI

@main
struct AppAssignmentApp: App {
    @StateObject private var theme = ThemeManager()
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(theme)
                .preferredColorScheme(theme.activeColorScheme)
        }
    }
}
