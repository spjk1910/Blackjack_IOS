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

struct WelcomeScreen: View
{
    @EnvironmentObject var controlPlayerBalance: ControlPlayerBalance
    @EnvironmentObject var readJson: ConvertJson
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var musicManager: BackgroundMusicManager
    @EnvironmentObject var playerManager: PlayerManager
    @EnvironmentObject var playerManagerTimer: PlayerManagerTimer
    @AppStorage("selectedMode") private var selectedMode: String = "Standard"
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("playerName") private var playerName: String = ""
    @State private var showingPlayerPrompt = false
    @State private var showingGameOptions = false
    @State private var navigateToGameView = false
    @State private var isChangePlayer = false
    let avatars = ["avatar1", "avatar2", "avatar3"]
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                Color(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                    .ignoresSafeArea()
                
                VStack
                {
                    //App logo
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isPhone() ? 150 : 300, height: isPhone() ? 150 : 300)
                    
                    Group
                    {
                        //Button to start game
                        Button(action: startGame)
                        {
                            Text(readJson.localizedString(forKey: "start"))
                                .padding()
                                .frame(width: isPhone() ? 200 : 400, height: isPhone() ? 50 : 100)
                                .background(Color("Button"))
                                .foregroundStyle(Color("Light"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .simultaneousGesture(TapGesture().onEnded { SoundManager.shared.playSound(named: "MouseClick")})
                        .fullScreenCover(isPresented: $showingPlayerPrompt) //Check if there is current player, show option to continue or create new player
                        {
                            PlayerCreationView(playerName: $playerName)
                                .onDisappear
                            {
                                checkStartGame()
                            }
                        }
                        
                        //Button to leaderboard
                        NavigationLink(destination: LeaderboardView())
                        {
                            Text(readJson.localizedString(forKey: "leaderboard"))
                                .padding()
                                .frame(width: isPhone() ? 200 : 400, height: isPhone() ? 50 : 100)
                                .background(Color("Button"))
                                .foregroundStyle(Color("Light"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "MouseClick")})
                        
                        //Button to how to play view
                        NavigationLink(destination: GuideView())
                        {
                            Text(readJson.localizedString(forKey: "guide"))
                                .padding()
                                .frame(width: isPhone() ? 200 : 400, height: isPhone() ? 50 : 100)
                                .background(Color("Button"))
                                .foregroundStyle(Color("Light"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "MouseClick")})
                        
                        //Button to setting view
                        NavigationLink(destination: SettingView())
                        {
                            Text(readJson.localizedString(forKey: "setting"))
                                .padding()
                                .frame(width: isPhone() ? 200 : 400, height: isPhone() ? 50 : 100)
                                .background(Color("Button"))
                                .foregroundStyle(Color("Light"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "MouseClick")})
                    }
                    .font(.custom("MTD-Afecta", size: isPhone() ? 25 : 50))
                }
                .onAppear
                {
                    readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi"
                    
                    if musicManager.isMusicOn
                    {
                        musicManager.setMusicState(isOn: true)
                    }
                }
                .navigationDestination(isPresented: $navigateToGameView) //Navigate to correct gamemode
                {
                    getGameMode()
                }
                
                GameOptionView(isPresented: $showingGameOptions, continueAction: {navigateToGameView = true
                    isChangePlayer = isChangePlayer}, newGameAction: {createNewPlayer()
                        isChangePlayer = isChangePlayer}) //Show GameOptionView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func getGameMode() -> some View //Get correct Gamemode based on current setting
    {
        if selectedMode == "Tiêu Chuẩn" || selectedMode == "Standard"
        {
            GameViewStandard(playerName: playerName,isChangePlayer: isChangePlayer)
        }
        else
        {
            GameViewTimer(playerName: playerName,isChangePlayer: isChangePlayer)
        }
    }
    
    //Setup variable for startgame
    private func startGame()
    {
        if (!playerName.isEmpty && selectedMode == "Timer" || selectedMode == "Thời Gian")
        {
            playerName = ""
            isChangePlayer = true
            showingPlayerPrompt = true
            return
        }
        
        if playerName.isEmpty
        {
            playerName = ""
            isChangePlayer = true
            showingPlayerPrompt = true
        }
        else
        {
            showingGameOptions = true
        }
    }
    
    //Create new player
    private func createNewPlayer()
    {
        if playerName != "" {
            if let savedGame = loadGameState() {
                let newPlayer = Player(
                    name: playerName,
                    win: savedGame.gameWin,
                    avatar: avatars.randomElement() ?? "avatar1"
                )
                playerManager.players.append(newPlayer)
            }
        }
        
        isChangePlayer = true
        playerName = ""
        showingPlayerPrompt = true
    }
    
    //Navigate to game after create new player
    private func checkStartGame()
    {
        if !playerName.isEmpty
        {
            navigateToGameView = true
        }
    }
}




struct WelcomeScreen_Preview: PreviewProvider
{
    static var previews: some View
    {
        let convertJson = ConvertJson()
        let themeManager = ThemeManager()
        let musicManager = BackgroundMusicManager()
        let playerManager = PlayerManager()
        let playerManagerTimer = PlayerManagerTimer()
        let timeManager = TimeManager()
        let controlPlayerBalance = ControlPlayerBalance()
        
        convertJson.selectedLanguage = "en"
        
        return Group
        {
            WelcomeScreen()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .environmentObject(timeManager)
                .environmentObject(controlPlayerBalance)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("IPhone")
            
            WelcomeScreen()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .environmentObject(timeManager)
                .environmentObject(controlPlayerBalance)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("IPad")
        }
    }
}

