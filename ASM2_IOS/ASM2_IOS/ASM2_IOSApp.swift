/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2024B
 Assessment: Assignment 2
 Author: Doan Phan Thuy Trang
 ID: s4027648
 Created date: 16/08/2024
 Last modified: 31/08/2024
 Acknowledgement:
 - Youtube
 - Freepik
 - Pinterest
 - Stackoverflow
 - https://opengameart.org/content/playing-cards-vector-png (Card Asset)
 */

import SwiftUI
import UIKit

@main
struct ASM2_IOSApp: App {
    @StateObject private var readJson = ConvertJson()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var musicManager = BackgroundMusicManager()
    @StateObject private var playerManager = PlayerManager()
    @StateObject private var playerManagerTimer = PlayerManagerTimer() 
    @StateObject private var timeManager = TimeManager()
    @StateObject private var controlPlayerBalance = ControlPlayerBalance()

    var body: some Scene {
        WindowGroup {
            WelcomeScreen()
                .environmentObject(readJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .environmentObject(timeManager)
                .environmentObject(controlPlayerBalance)
        }
    }
}
