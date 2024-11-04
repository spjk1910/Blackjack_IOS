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

// Manages audio playback for the application
class SoundManager {
    // Shared instance for singleton pattern
    static let shared = SoundManager()
    
    // Audio player for handling sound playback
    private var audioPlayer: AVAudioPlayer?
    
    // Function to play a sound file
    func playSound(named soundName: String, fileExtension: String = "mp3") {
        // Locate the sound file in the main bundle
        guard let url = Bundle.main.url(forResource: soundName, withExtension: fileExtension) else {
            print("Sound file not found.")
            return
        }
        
        do {
            // Initialize the audio player with the sound file
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // Play the sound
            audioPlayer?.play()
        } catch {
            // Handle errors if the sound file cannot be played
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
