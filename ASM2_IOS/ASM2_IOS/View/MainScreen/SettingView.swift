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

struct SettingView: View {
    @EnvironmentObject var controlPlayerBalance: ControlPlayerBalance
    @EnvironmentObject var readJson: ConvertJson
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var musicManager: BackgroundMusicManager
    @EnvironmentObject var timeManager: TimeManager
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("selectedTheme") private var selectedTheme = "Light"
    @AppStorage("selectedDifficulty") private var selectedDifficulty = "Easy"
    @AppStorage("selectedMode") private var selectedMode = "Standard"
    @State private var showingInfo: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            if isPhone() {
                Menu
                    .frame(maxWidth: 600)
                    .padding()
            } else {
                Menu
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Adjust layout to fill the screen
        .background(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
        .ignoresSafeArea()
        .infoView(showingInfo: $showingInfo) // Display info pop-up based on the showingInfo state
        .navigationBarBackButtonHidden(true) // Hide default navigation back button
        .onAppear{
            if let data = UserDefaults.standard.data(forKey: "saveGame"),
                      let loadedGame = try? JSONDecoder().decode(SaveGame.self, from: data) {
                       controlPlayerBalance.balance = loadedGame.balance
                   }
        }
        .onChange(of: selectedLanguage, initial: true) { oldValue, newValue in
            readJson.selectedLanguage = newValue == "English" ? "en" : "vi"
            updateSettings(selectedTheme: &selectedTheme, selectedDifficulty: &selectedDifficulty, selectedMode: &selectedMode, selectedLanguage: &selectedLanguage, readJson: readJson)
            // Uncomment the following lines and change language if you need to reset saved game data when language changes:
            //             UserDefaults.standard.removeObject(forKey: "savedPlayers")  // Reset save file ~ savedPlayers
            //             UserDefaults.standard.removeObject(forKey: "savedPlayersTimer") // Reset save file ~ savePlayersTimer
            //             UserDefaults.standard.removeObject(forKey: "saveGame") // Reset save file ~ saveGame
        }
        .onChange(of: selectedTheme, initial: true) { oldValue, newValue in
            themeManager.setTheme(newValue) // Apply the selected theme
        }
        .onAppear {
            if musicManager.isMusicOn {
                musicManager.setMusicState(isOn: true) // Ensure music is on if set in preferences
            }
        }
    }
    
    // Menu containing the settings options
    var Menu: some View {
        VStack {
            Text(readJson.localizedString(forKey: "setting"))
                .font(.custom("MTD-Afecta", size: isPhone() ? 60 : 100))
                .padding(.trailing, isPhone() ? 50 : 20)
                .padding(.top, 30)
                .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
            
            Setting(
                title: readJson.localizedString(forKey: "language"),
                option: [readJson.localizedString(forKey: "language1"), readJson.localizedString(forKey: "language2")],
                value: { $0 },
                description: readJson.localizedString(forKey: "languageDescription"),
                selectedOption: $selectedLanguage
            )
            
            Setting(
                title: readJson.localizedString(forKey: "theme"),
                option: [readJson.localizedString(forKey: "themeL"), readJson.localizedString(forKey: "themeD")],
                value: { $0 },
                description: readJson.localizedString(forKey: "themeDescription"),
                selectedOption: $selectedTheme
            )
            
            Setting(
                title: readJson.localizedString(forKey: "difficulty"),
                option: [
                    readJson.localizedString(forKey: "difficulty1"),
                    readJson.localizedString(forKey: "difficulty2"),
                    readJson.localizedString(forKey: "difficulty3")
                ],
                value: { $0 },
                description: {
                    switch $0 {
                    case readJson.localizedString(forKey: "difficulty1"):
                        return readJson.localizedString(forKey: "difficultyDescription1")
                    case readJson.localizedString(forKey: "difficulty2"):
                        return readJson.localizedString(forKey: "difficultyDescription2")
                    case readJson.localizedString(forKey: "difficulty3"):
                        return readJson.localizedString(forKey: "difficultyDescription3")
                    default:
                        return ""
                    }
                }(selectedDifficulty),
                selectedOption: Binding(
                    get: {
                        selectedDifficulty
                    },
                    set: { newValue in
                        // Check if the mode requires balance validation
                        if selectedMode == readJson.localizedString(forKey: "mode1") || selectedMode == "Tiêu Chuẩn" {
                            // Apply balance check for "Standard" or "Tiêu Chuẩn" mode
                            if (newValue == readJson.localizedString(forKey: "difficulty2") && controlPlayerBalance.balance >= 100) ||
                                (newValue == readJson.localizedString(forKey: "difficulty3") && controlPlayerBalance.balance >= 1000) ||
                                (newValue == readJson.localizedString(forKey: "difficulty1")) {
                                selectedDifficulty = newValue
                            } else {
                                let requiredBalance = controlPlayerBalance.getBet(selectedDifficulty: newValue)
                                alertMessage = selectedLanguage == "English"
                                ? "Difficulty \(newValue) requires $\(requiredBalance) balance!"
                                : "Độ khó \(newValue) cần $\(requiredBalance)!"
                                showAlert = true
                            }
                        } else {
                            // Set difficulty without balance check if mode does not require it
                            selectedDifficulty = newValue
                        }
                    }
                )
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(selectedLanguage == "English" ? "You have $\(controlPlayerBalance.balance) - Insufficient Balance" : "Bạn có $\(controlPlayerBalance.balance) -  Số dư không đủ"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        SoundManager.shared.playSound(named: "MouseClick")
                    }
                )
            }
            
            Setting(
                title: readJson.localizedString(forKey: "mode"),
                option: [readJson.localizedString(forKey: "mode1"), readJson.localizedString(forKey: "mode2")],
                value: { $0 },
                description: {
                    switch $0 {
                    case readJson.localizedString(forKey: "mode1"): return readJson.localizedString(forKey: "modeDescription1")
                    case readJson.localizedString(forKey: "mode2"): return readJson.localizedString(forKey: "modeDescription2")
                    default: return ""
                    }
                }(selectedMode),
                selectedOption: $selectedMode
            )
            
            HStack(spacing: 20) {
                NavigationLink(destination: WelcomeScreen()) {
                    Image(systemName: "arrow.backward.square")
                        .font(.system(size: isPhone() ? 24 : 45))
                        .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                        .padding()
                }
                .simultaneousGesture(TapGesture().onEnded { SoundManager.shared.playSound(named: "MouseClick") }) // Play sound on tap
                
                Button(action: {
                    SoundManager.shared.playSound(named: "MouseClick")
                    musicManager.setMusicState(isOn: !musicManager.isMusicOn)
                }) {
                    Image(systemName: musicManager.isMusicOn ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .font(.system(size: isPhone() ? 24 : 45))
                        .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                        .padding()
                }
                
                Button(action: {
                    SoundManager.shared.playSound(named: "MouseClick")
                    showingInfo.toggle()
                }) {
                    Image(systemName: "info.square")
                        .font(.system(size: isPhone() ? 24 : 45))
                        .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        let convertJson = ConvertJson()
        
        convertJson.selectedLanguage = "en"
        let themeManager = ThemeManager()
        let musicManager = BackgroundMusicManager()
        let timeManager = TimeManager()
        let controlPlayerBalance = ControlPlayerBalance()
        let playerManager = PlayerManager()
        let playerManagerTimer = PlayerManagerTimer()
        
        return Group {
            SettingView()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .environmentObject(timeManager)
                .environmentObject(controlPlayerBalance)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
            
            SettingView()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .environmentObject(timeManager)
                .environmentObject(controlPlayerBalance)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("iPad")
        }
    }
}

