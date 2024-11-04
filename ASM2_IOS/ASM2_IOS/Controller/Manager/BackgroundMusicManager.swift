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

import AVFoundation
import SwiftUI

// Manages background music playback for the application
class BackgroundMusicManager: ObservableObject {
    // AppStorage property to persist the state of the music toggle
    @AppStorage("isMusicOn") var isMusicOn: Bool = true
    
    // Audio player for handling music playback
    private var audioPlayer: AVAudioPlayer?
    
    // Function to set the state of the background music
    func setMusicState(isOn: Bool) {
        isMusicOn = isOn
        if isOn {
            playMusic()
        } else {
            stopMusic()
        }
    }
    
    // Function to play background music
    private func playMusic() {
        // Locate the music file in the main bundle
        guard let url = Bundle.main.url(forResource: "hipjazz", withExtension: "mp3") else {
            print("Music file not found.")
            return
        }
        do {
            // Initialize the audio player with the music file
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // Set audio player properties
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = 0.3       // Set volume level
            // Play the music
            audioPlayer?.play()
        } catch {
            // Handle errors if the music file cannot be played
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    // Function to stop background music
    private func stopMusic() {
        audioPlayer?.stop()
    }
}
