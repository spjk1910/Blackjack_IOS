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

struct LeaderboardView: View
{
    @EnvironmentObject var controlPlayerBalance: ControlPlayerBalance
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var readJson: ConvertJson
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var musicManager: BackgroundMusicManager
    @EnvironmentObject var playerManager: PlayerManager
    @EnvironmentObject var playerManagerTimer:  PlayerManagerTimer
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @State private var selectedTab: TabItem = .standard
    
    var body: some View
    {
        NavigationStack {
            ZStack {
                Color(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                    .ignoresSafeArea()
                
                VStack {
                    
                    if isPhone()
                    {
                        Spacer()
                    }
                    //Button to turn back to WelcomeScreen
                    HStack {
                        NavigationLink(destination: WelcomeScreen()) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: isPhone() ? 20 : 40, weight: .bold))
                                    .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                
                                Text(readJson.localizedString(forKey: "back"))
                                    .font(.custom("MTD-Afecta", size: isPhone() ? 30 : 50))
                                    .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                    .padding(.top, isPhone() ? 4 : 6)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "MouseClick")})
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.bottom, isPhone() ? 10 : 20)
                    
                    //Title
                    Text(readJson.localizedString(forKey: "leaderboard").uppercased())
                        .font(.custom("MTD-Afecta", size: isPhone() ? 70 : 100))
                        .foregroundStyle(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                        .padding()
                    // TabView for Standard and Timer Mode
                    LeaderboardTabView(selectedTab: $selectedTab)
                    
                    if selectedTab == .standard {
                        StandardLeaderboardView()
                    } else {
                        TimerLeaderboardView()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear
            {
                //Load file save
                playerManager.loadPlayers()
                playerManagerTimer.loadPlayers()
                
                readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi"
                
                if musicManager.isMusicOn
                {
                    musicManager.setMusicState(isOn: true)
                }
            }
            .onDisappear
            {
                //Save into file
                playerManager.savePlayers()
                playerManagerTimer.savePlayers()
            }
        }
    }
}

//RankRow class to show each player and their rank on leaderboard
struct RankRow: View
{
    @EnvironmentObject var readJson: ConvertJson
    
    var name: String
    var win: String
    var imageName: String
    var rank: Int
    
    var body: some View
    {
        HStack
        {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            
            VStack(alignment: .leading)
            {
                Text(name)
                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 24))
                    .foregroundStyle(Color("Light"))
                HStack {
                    Text("\(readJson.localizedString(forKey: "rank")): \(rank)")
                        .font(.custom("iCiel Altus", size: isPhone() ? 25 : 24))
                        .foregroundStyle(Color("Light"))
                    Text("\(readJson.localizedString(forKey: "win")): \(win)")
                    
                        .font(.custom("iCiel Altus", size: isPhone() ? 25 : 24))
                        .foregroundStyle(Color("Light"))
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color("Arrow"))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

//LeaderboardView for standard mode
struct StandardLeaderboardView: View {
    @EnvironmentObject var playerManager: PlayerManager
    var body: some View {
        VStack(alignment: .leading) {
            if playerManager.players.isEmpty {
                // Display a message if there are no players
                Text("No players available.")
                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 24))
                    .foregroundStyle(Color("Light"))
                    .padding()
                    .background(Color("Arrow"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    VStack {
                        ForEach(Array(sortedPlayers.enumerated()), id: \.element.id) { index, player in
                            RankRow(name: player.name, win: String(player.win), imageName: player.avatar, rank: index + 1)
                        }
                    }
                    .padding(.top, 5)
                }
                .background(Color.brown.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
    
    private var sortedPlayers: [Player] {
        playerManager.players
            .sorted { $0.win > $1.win }
    }
}

//LeaderboardView for timer mode
struct TimerLeaderboardView: View {
    @EnvironmentObject var playerManager: PlayerManagerTimer
    
    var body: some View {
        VStack(alignment: .leading) {
            if playerManager.players.isEmpty {
                // Display a message if there are no players
                Text("No players available.")
                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 24))
                    .foregroundStyle(Color("Light"))
                    .padding()
                    .background(Color("Arrow"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            } else {
                ScrollView {
                    VStack {
                        ForEach(Array(sortedPlayers.enumerated()), id: \.element.id) { index, player in
                            RankRow(name: player.name, win: String(player.win), imageName: player.avatar, rank: index + 1)
                        }
                    }
                    .padding(.top, 5)
                }
                .background(Color.brown.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
    
    //Sort player by win
    private var sortedPlayers: [Player] {
        playerManager.players
            .sorted { $0.win > $1.win }
    }
}


struct LeaderboardView_Preview: PreviewProvider
{
    static var previews: some View {
        let playerManager = PlayerManager()
        let playerManagerTimer = PlayerManagerTimer()
        let convertJson = ConvertJson()
        let themeManager = ThemeManager()
        let musicManager = BackgroundMusicManager()
        let controlPlayerBalance = ControlPlayerBalance()
        let timeManager = TimeManager()
        
        return Group {
            LeaderboardView()
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .environmentObject(timeManager)
                .environmentObject(controlPlayerBalance)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
            
            LeaderboardView()
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
