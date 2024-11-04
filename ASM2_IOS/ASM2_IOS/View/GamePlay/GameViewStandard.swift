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

struct GameViewStandard: View
{
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var readJson: ConvertJson
    @EnvironmentObject var musicManager: BackgroundMusicManager
    @EnvironmentObject var playerManagerTimer: PlayerManagerTimer
    @EnvironmentObject var playerManager: PlayerManager
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var balanceController = ControlPlayerBalance()
    @State private var deck = CardDeck()
    @State private var playerCards: [CardClass] = []
    @State private var dealerCards: [CardClass] = []
    @State private var deckCards: [CardClass] = []
    @State private var dealingInProgress = false
    @State private var gameStatus: String? = nil
    @State private var isPaused = false
    @State private var isDealing = false
    @State private var isGameStart = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("playerName") private var playerReset: String?
    private let saveKey = "saveGame"
    let avatars = ["avatar1", "avatar2", "avatar3"]
    var playerName = ""
    var isChangePlayer: Bool
    
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                Color(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                    .ignoresSafeArea()
                
                //Pause button
                Button(action: {
                    SoundManager.shared.playSound(named: "MouseClick")
                    isPaused.toggle()})
                {
                    Image(systemName: "pause.rectangle.fill")
                        .font(.system(size: isPhone() ? 30 : 55))
                        .foregroundStyle(Color("Button"))
                        .padding(.leading, isPhone() ? 700 : 980)
                        .padding(.bottom, isPhone() ? 300 : 700)
                }
                
                Cover()  //Cover to prevent pause view open when clik on blank area
                
                ZStack
                {
                    //Draw a table
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("TableFabric") : Color("TableFabric")))
                        .frame(width: isPhone() ? 600 : 900, height: isPhone() ? 250 : 500)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color("TableWood"), lineWidth: 25)
                        )
                        .padding(.top, 30)
                    
                    VStack
                    {
                        HStack
                        {
                            //Show card of dealer with animation when start game
                            ForEach(dealerCards.indices, id: \.self)
                            { index in
                                if gameStatus == nil
                                {
                                    //Show Back of card when the game is still on
                                    CardView(cardName: "BackCard")
                                        .frame(width: isPhone() ? 60 : 120, height: isPhone() ? 140 : 280)
                                        .offset(x: isDealing ? 0 : 700, y: isDealing ? 0 : -400)
                                        .rotationEffect(isDealing ? .zero : .degrees(90))
                                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.3), value: isDealing)
                                }
                                else
                                {
                                    //Show dealer card when finish round
                                    CardView(cardName: dealerCards[index].cardName)
                                        .frame(width: isPhone() ? 60 : 120, height: isPhone() ? 140 : 280)
                                }
                            }
                        }
                        .padding(.top,60)
                        
                        HStack
                        {
                            //Show player card with animation when start game
                            ForEach(playerCards.indices, id: \.self) { index in
                                CardView(cardName: playerCards[index].cardName)
                                    .frame(width: isPhone() ? 60 : 100, height: isPhone() ? 140 : 280)
                                    .offset(x: isDealing ? 0 : 700, y: isDealing ? 0 : -400)
                                    .rotationEffect(isDealing ? .zero : .degrees(90))
                                    .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.3), value: isDealing)
                            }
                        }
                        .padding(.bottom,30)
                    }
                }
                
                //Assume a deck of card ~ click it to start game
                CardView(cardName: "BackCard")
                    .frame(width: isPhone() ? 60 : 120, height: isPhone() ? 140 : 280)
                    .padding(.leading,isPhone() ? 450 : 700)
                    .padding(.top,50)
                    .onTapGesture
                {
                    //prevent double click error ~ means call dealCard() 2 times
                    guard !isGameStart else { return }
                    isGameStart = true
                    
                    //Rest deck to prevent over array error
                    if deck.cardsRemaining() < 10
                    {
                        deck.createDeck()
                        deck.shuffle()
                    }
                    
                    //Deal card to player and dealer when game start
                    if playerCards.isEmpty && !isPaused
                    {
                        dealCard()
                        SoundManager.shared.playSound(named: "ShuffleCard")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                        {
                            SoundManager.shared.playSound(named: "DealCard")
                        }
                    }
                }
                
                //Show dealer name
                Text("\(readJson.localizedString(forKey: "dealer")): \(gameStatus != nil ? "\(calculateCardSum(cards: dealerCards))" : "?")")
                    .font(.custom("iCiel Altus", size: isPhone() ? 24 : 40))
                    .foregroundStyle(.white)
                    .padding(.bottom, isPhone() ? 150 : 360)
                    .padding(.trailing, isPhone() ? 460 : 680)
                
                //Show player  name
                Text("\(playerName): \(isDealing ? "\(calculateCardSum(cards: playerCards))" : "?")")
                    .font(.custom("iCiel Altus", size: isPhone() ? 24 : 40))
                    .foregroundStyle(.white)
                    .padding(.top, isPhone() ? 200 : 400)
                    .padding(.trailing, isPhone() ? 460 : 680)
                
                //Show balance of player
                Text("\(readJson.localizedString(forKey: "balance")): $\(balanceController.balance)")
                    .font(.custom("iCiel Altus", size: isPhone() ? 24 : 50))
                    .foregroundStyle(.black)
                    .padding(.top, selectedLanguage == "English" ? (isPhone() ? 355 : 645) : (isPhone() ? 350 : 680))
                    .padding(.leading, selectedLanguage == "English" ? (isPhone() ? -10 : -40) : (isPhone() ? 30 : 80))
                
                HStack
                {
                    //Show bet of game
                    Text("\(readJson.localizedString(forKey: "bet")): $\(balanceController.modeBet()) |")
                        .font(.custom("iCiel Altus", size: isPhone() ? 24 : 50))
                        .foregroundStyle(.white)
                    
                    //Show the total wins of player
                    Text("\(readJson.localizedString(forKey: "win")): \(balanceController.gameWin)")
                        .font(.custom("iCiel Altus", size: isPhone() ? 24 : 50))
                        .foregroundStyle(.white)
                }
                .padding(.top,35)
                
                HStack(spacing: 200)
                {
                    //Hit button for dealing additional card
                    Button(action: hit)
                    {
                        Text("\(readJson.localizedString(forKey: "hit"))")
                            .font(.custom("iCiel Altus",size : isPhone() ? 25 : 60))
                            .padding()
                            .background(Color("Button"))
                            .foregroundStyle(.white)
                            .frame(width: isPhone() ? 200 : 400,height: isPhone() ? 40 : 70)
                            .clipShape(Rectangle())
                    }
                    .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "DealCard")})
                    .disabled(dealingInProgress || gameStatus != nil || !isDealing || isPaused)
                    
                    //Stand button for end a round
                    Button(action: stand)
                    {
                        Text("\(readJson.localizedString(forKey: "stand"))")
                            .font(.custom("iCiel Altus",size : isPhone() ? 25 : 60))
                            .padding()
                            .background(Color("Button"))
                            .foregroundStyle(.white)
                            .frame(width: isPhone() ? 200 : 400,height: isPhone() ? 40 : 70)
                            .clipShape(Rectangle())
                    }
                    .disabled(dealingInProgress || gameStatus != nil || !isDealing || isPaused || calculateCardSum(cards: playerCards) < 16)
                }
                .padding(.top, selectedLanguage == "English" ? (isPhone() ? 355 : 645) : (isPhone() ? 350 : 680))
                .padding(.leading, selectedLanguage == "English" ? (isPhone() ? 10 : -10) : (isPhone() ? 10 : 50))
                
                if let status = gameStatus
                {
                    //Showing result of round based on gameStatus
                    if status != "You run out of Money! Game Over!" && status != "Bạn đã hết Tiền! Trò Chơi Kết Thúc!"
                    {
                        VStack
                        {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                                .shadow(radius: 10)
                                .overlay(
                                    ZStack
                                    {
                                        Text(status)
                                            .font(.custom("MTD-Afecta", size: isPhone() ? 45 : 60))
                                            .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                            .padding(.all, 20)
                                        
                                        Text("\(readJson.localizedString(forKey: "dealer")): \(calculateCardSum(cards: dealerCards))")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 28 : 48))
                                            .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                            .padding(.bottom, isPhone() ? 130 : 180)
                                            .padding(.trailing, isPhone() ? 460 : 850)
                                        
                                        Text("\(playerName): \(calculateCardSum(cards: playerCards))")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 28 : 48))
                                            .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                            .padding(.top, isPhone() ? 225 : 440)
                                            .padding(.trailing, isPhone() ? 460 : 850)
                                        
                                        VStack
                                        {
                                            dealCardForNoti(player: dealerCards)
                                            dealCardForNoti(player: playerCards)
                                        }
                                        .padding(.bottom, isPhone() ? 20 : 10)
                                        
                                        HStack
                                        {
                                            Button(action:{resetGame()})
                                            {
                                                Text("Continue")
                                                    .font(.custom("iCiel Altus", size: isPhone() ? 24 : 48))
                                                    .foregroundColor(Color("Light"))
                                                    .padding()
                                                    .background(Color("Button"))
                                                    .cornerRadius(10)
                                            }
                                            
                                            NavigationLink(destination: LeaderboardView()
                                                .onAppear {
                                                    let newPlayer = Player(name: playerName, win: balanceController.gameWin, avatar: avatars.randomElement() ?? "avatar1")
                                                    
                                                    playerManager.players.append(newPlayer)
                                                    
                                                    playerReset = ""
                                                    
                                                    balanceController.resetPlayer()
                                                    
                                                    resetGame()
                                                })
                                            {
                                                Text("End Game")
                                                    .font(.custom("iCiel Altus", size: isPhone() ? 24 : 48))
                                                    .foregroundColor(Color("Light"))
                                                    .padding()
                                                    .background(Color("Button"))
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.top, isPhone() ? 340 : 680)
                                    }
                                        .padding()
                                )
                        }
                        .padding()
                    }
                    else
                    {
                        VStack
                        {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light"))
                                .shadow(radius: 10)
                                .overlay(
                                    ZStack
                                    {
                                        Text(status)
                                            .font(.custom("MTD-Afecta", size: isPhone() ? 45 : 60))
                                            .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                            .padding(.all, 20)
                                        
                                        Text("\(readJson.localizedString(forKey: "dealer")): \(calculateCardSum(cards: dealerCards))")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 28 : 48))
                                            .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                            .padding(.bottom, isPhone() ? 130 : 180)
                                            .padding(.trailing, isPhone() ? 460 : 850)
                                        
                                        Text("\(playerName): \(calculateCardSum(cards: playerCards))")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 28 : 48))
                                            .foregroundColor(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark"))
                                            .padding(.top, isPhone() ? 225 : 440)
                                            .padding(.trailing, isPhone() ? 460 : 850)
                                        
                                        VStack
                                        {
                                            dealCardForNoti(player: dealerCards)
                                            dealCardForNoti(player: playerCards)
                                        }
                                        .padding(.bottom, isPhone() ? 20 : 10)
                                        
                                        //End game button for navigating to leaderboard when game end (player run out of money)
                                        NavigationLink(destination: LeaderboardView().onAppear {
                                            let newPlayer = Player(name: playerName, win: balanceController.gameWin, avatar: avatars.randomElement() ?? "avatar1")
                                            
                                            playerManager.players.append(newPlayer)
                                            
                                            playerReset = ""
                                            
                                            UserDefaults.standard.set(selectedLanguage == "English" ? "Easy" : "Dễ", forKey: "selectedDifficulty")
                                            
                                            balanceController.resetPlayer()
                                            
                                            resetGame()
                                        })
                                        {
                                            Text("End Game")
                                                .font(.custom("iCiel Altus", size: isPhone() ? 24 : 48))
                                                .foregroundColor(Color("Light"))
                                                .padding()
                                                .background(Color("Button"))
                                                .cornerRadius(10)
                                        }
                                        .padding(.top, isPhone() ? 340 : 680)
                                    }
                                )
                        }
                        .padding()
                    }
                }
                
                //Showing pause view when click on pause button
                if isPaused
                {
                    pauseGame()
                }
            }
            //Save game when terminate app
            .onChange(of: scenePhase) { _,newPhase in
                switch newPhase
                {
                case .inactive: isPaused = true
                case .background: saveGame()
                default: break
                }
            }
            //Set up and load save game when start game
            .onAppear
            {
                readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi"
                
                isPaused = false
                if isChangePlayer
                {
                    UserDefaults.standard.removeObject(forKey: saveKey)
                    balanceController.resetPlayer()
                }
                
                loadGame()
                
                if musicManager.isMusicOn
                {
                    musicManager.setMusicState(isOn: true)
                }
            }
            .onChange(of: gameStatus, initial: true)
            {
                oldValue, newValue in
                if newValue != nil
                {
                    soundStatusNotification()
                }
            }
            //Save game when exit
            .onDisappear
            {
                saveGame()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    //Reset game function ~ set up new round
    private func resetGame()
    {
        if balanceController.balance < balanceController.modeBet()
        {
            gameStatus = selectedLanguage == "English" ? "You run out of Money! Game Over!" : "Bạn đã hết Tiền! Trò Chơi Kết Thúc!"
        }
        else
        {
            isGameStart = false
            isPaused = false
            isDealing = false
            playerCards.removeAll()
            dealerCards.removeAll()
            deck.createDeck()
            deck.shuffle()
            gameStatus = nil
        }
    }
    
    //Deal card at the start of the game
    private func dealCard()
    {
        dealingInProgress = true
        isDealing = false
        
        playerCards.removeAll()
        dealerCards.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        {
            for i in 0..<2
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3)
                {
                    playerCards.append(deck.drawCard())
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3 + 0.15)
                {
                    dealerCards.append(deck.drawCard())
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                isDealing = true
                dealingInProgress = false
                checkBlackjack()
            }
        }
    }
    
    //Checking blackjack case
    private func checkBlackjack()
    {
        let playerSum = calculateCardSum(cards: playerCards)
        let dealerSum = calculateCardSum(cards: dealerCards)
        
        if playerSum == 21 && dealerSum == 21
        {
            gameStatus = selectedLanguage == "English" ? "Push! Both Player and Dealer have Blackjack!" : "Hòa! Bạn và Nhà Cái đều Blackjack!"
        } else if playerSum == 21
        {
            gameStatus = selectedLanguage == "English" ? "Blackjack! You Wins!" : "Blackjack! Bạn Thắng!"
            balanceController.adjustBalance(forWin: true,forDouble: false)
        } else if dealerSum == 21
        {
            gameStatus = selectedLanguage == "English" ? "Blackjack! Dealer Wins!" : "Blackjack! Nhà Cái Thắng!"
            balanceController.adjustBalance(forWin: false, forDouble: false)
        }
        
        if balanceController.balance <= 0
        {
            gameStatus = selectedLanguage == "English" ? "You run out of Money! Game Over!" : "Bạn đã hết Tiền! Trò Chơi Kết Thúc!"
        }
    }
    
    //Hit button ~ deal an additional card each time it is clicked
    private func hit()
    {
        if dealingInProgress || gameStatus != nil
        {
            return
        }
        
        if deck.cardsRemaining() < 10
        {
            deck.createDeck()
            deck.shuffle()
        }
        
        playerCards.append(deck.drawCard())
        if playerCards.count == 5
        {
            checkGameStatus()
        }
        
        if calculateCardSum(cards: playerCards) > 21
        {
            var  dealerSum = calculateCardSum(cards: dealerCards)
            while dealerSum < 17
            {
                dealerCards.append(deck.drawCard())
                if dealerCards.count == 5
                {
                    checkGameStatus()
                }
                dealerSum = calculateCardSum(cards: dealerCards)
            }
            
            checkGameStatus()
        }
    }
    
    //Stand button to end round
    private func stand()
    {
        if dealingInProgress || gameStatus != nil
        {
            return
        }
        
        SoundManager.shared.playSound(named: "StandAction")
        
        var dealerSum = calculateCardSum(cards: dealerCards)
        while dealerSum < 17
        {
            dealerCards.append(deck.drawCard())
            dealerSum = calculateCardSum(cards: dealerCards)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            checkGameStatus()
        }
    }
    
    //Compare sum of card of player and dealer and return relevant status for result
    private func checkGameStatus()
    {
        let playerSum = calculateCardSum(cards: playerCards)
        let dealerSum = calculateCardSum(cards: dealerCards)
        let playerCardCount = playerCards.count
        let dealerCardCount = dealerCards.count
        
        if playerSum > 21
        {
            if dealerSum > 21
            {
                gameStatus = selectedLanguage == "English" ? "Push! You and Dealer Busts!" : "Hòa! Bạn và Nhà Cái đều Quắc!"
            }
            else
            {
                gameStatus = selectedLanguage == "English" ? "You Busts! Dealer Wins!" : "Bạn Quắc! Nhà Cái Thắng!"
                balanceController.adjustBalance(forWin: false, forDouble: false)
            }
        }
        else if playerCardCount == 5 && playerSum <= 21 && dealerCardCount < 5
        {
            if dealerCardCount == 5 && dealerSum <= 21
            {
                gameStatus = selectedLanguage == "English" ? "Push! Both of You and Dealer has 5-Card Charlie!" : "Hòa! Bạn và Nhà Cái đều Ngủ Linh!"
            }
            else
            {
                gameStatus = selectedLanguage == "English" ? "You has 5-Card Charlie! You Wins Double!" : "Bạn Ngủ Linh! Bạn Thắng Gấp Đôi!"
                balanceController.adjustBalance(forWin: true,forDouble: true)
            }
        }
        else if dealerCardCount == 5 && dealerSum <= 21
        {
            if playerCardCount == 5 && playerSum <= 21
            {
                gameStatus = selectedLanguage == "English" ? "Push! Both of You and Dealer has 5-Card Charlie!" : "Hòa! Bạn và Nhà Cái đều Ngủ Linh!"
            }
            else
            {
                gameStatus = selectedLanguage == "English" ? "Dealer has 5-Card Charlie! You Lose Double!" : "Nhà Cái Ngủ Linh! Bạn Thua Gấp Đôi!"
                balanceController.adjustBalance(forWin: false,forDouble: true)
            }
        }
        else if dealerSum > 21
        {
            gameStatus = selectedLanguage == "English" ? "Dealer Busts! You Wins!" : "Nhà Cái Quắc! Bạn Thắng!"
            balanceController.adjustBalance(forWin: true,forDouble: false)
        }
        else if dealerSum >= playerSum
        {
            gameStatus = dealerSum > playerSum ? (selectedLanguage == "English" ? "Dealer Wins!" : "Nhà Cái Thắng!") : (selectedLanguage == "English" ? "Push!" : "Hòa!")
            
            if dealerSum > playerSum
            {
                balanceController.adjustBalance(forWin: false,forDouble: false)
            }
        }
        else if playerSum > dealerSum
        {
            gameStatus = selectedLanguage == "English" ? "You Wins!" : "Bạn Thắng!"
            balanceController.adjustBalance(forWin: true,forDouble: false)
        }
        else
        {
            gameStatus = nil
        }
        if balanceController.balance <= 0
        {
            gameStatus = selectedLanguage == "English" ? "You run out of Money! Game Over!" : "Bạn đã hết Tiền! Trò Chơi Kết Thúc!"
        }
    }
    
    //Calulate the sum of cards
    private func calculateCardSum(cards: [CardClass]) -> Int
    {
        var sum = 0
        var aceCount = 0
        
        for card in cards
        {
            sum += card.cardValue
            if card.cardValue == 11
            {
                aceCount += 1
            }
        }
        
        while sum > 21 && aceCount > 0
        {
            sum -= 10
            aceCount -= 1
        }
        
        return sum
    }
    
    //SAVE GAME function
    func saveGame()
    {
        let key = SaveGame(
            playerCards: playerCards,
            dealerCards: dealerCards,
            balance: balanceController.balance,
            gameStatus: gameStatus,
            gameWin: balanceController.gameWin,
            deckCards : deck.Deck(),
            isDealing : isDealing
        )
        
        if let encoded = try? JSONEncoder().encode(key)
        {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    //Load game function
    private func loadGame()
    {
        if let savedData = UserDefaults.standard.data(forKey: saveKey)
        {
            if let loadedGame = try? JSONDecoder().decode(SaveGame.self, from: savedData)
            {
                playerCards = loadedGame.playerCards
                dealerCards = loadedGame.dealerCards
                balanceController.balance = loadedGame.balance
                gameStatus = loadedGame.gameStatus
                balanceController.gameWin = loadedGame.gameWin
                deck.updateDeck(with: loadedGame.deckCards)
                isDealing = loadedGame.isDealing
            }
            else
            {
                resetGame()
            }
        }
        else
        {
            resetGame()
        }
    }
    
    //Set up sound for result
    private func soundStatusNotification()
    {
        guard let status = gameStatus
        else
        {
            return
        }
        
        if status.contains("Dealer Wins!") || status == "You run out of Money! Game Over!" || status.contains("Nhà Cái Thắng!") || status == "Bạn đã hết Tiền! Trò Chơi Kết Thúc!"
        {
            SoundManager.shared.playSound(named: "LoseSound")
        }
        else if status.contains("You Wins!") || status.contains("Bạn Thắng!")
        {
            SoundManager.shared.playSound(named: "WinSound")
        }
        else
        {
            SoundManager.shared.playSound(named: "DrawSound")
        }
    }
    
    //Pause game view
    private func pauseGame() -> some View
    {
        VStack(alignment: .center)
        {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 10)
                .overlay(
                    VStack(alignment: .leading, spacing: 10)
                    {
                        Text("\(readJson.localizedString(forKey: "pause"))")
                            .font(.custom("iCiel Altus", size: isPhone() ? 40 : 50))
                            .foregroundStyle(Color("Dark"))
                            .padding(.leading, selectedLanguage == "English" ? (isPhone() ? 65 : 80) : (isPhone() ? 25 : 40))
                        
                        HStack
                        {
                            NavigationLink(destination: WelcomeScreen())
                            {
                                Image(systemName: "arrow.backward.square")
                                    .font(.system(size: isPhone() ? 24 : 45))
                                    .foregroundStyle(Color("Dark"))
                                    .padding()
                            }
                            .simultaneousGesture(TapGesture().onEnded {SoundManager.shared.playSound(named: "MouseClick")})
                            
                            Button(action: {SoundManager.shared.playSound(named: "MouseClick")
                                musicManager.setMusicState(isOn: !musicManager.isMusicOn)})
                            {
                                Image(systemName: musicManager.isMusicOn ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                    .font(.system(size: isPhone() ? 24 : 45))
                                    .foregroundStyle(Color("Dark"))
                                    .padding()
                            }
                            
                            Button(action: {isPaused = false
                                SoundManager.shared.playSound(named: "MouseClick")})
                            {
                                Image(systemName: "play.square")
                                    .font(.system(size: isPhone() ? 24 : 45))
                                    .foregroundStyle(Color("Dark"))
                                    .padding()
                            }
                        }
                    }
                        .padding()
                )
                .frame(width: isPhone() ? 300 : 400, height: isPhone() ? 220 : 250)
                .padding(.top, 30)
        }
        .padding()
    }
}

//Deal card for showing on the result
private func dealCardForNoti(player: [CardClass]) -> some View
{
    HStack
    {
        ForEach(player.indices, id: \.self) { index in
            CardView(cardName: player[index].cardName)
                .frame(width: isPhone() ? 60 : 120, height: isPhone() ? 140 : 280)
        }
    }
    .padding()
}

//Cover funciton
private func Cover() -> some View
{
    ZStack
    {
        Color.clear
            .contentShape(Rectangle())
            .ignoresSafeArea()
            .frame(width: isPhone() ? 10 : 150, height: isPhone() ? 400 : 900)
            .padding(.leading, isPhone() ? 750 : 1200)
        Color.clear
            .contentShape(Rectangle())
            .ignoresSafeArea()
            .frame(width: isPhone() ? 1405 : 1710, height: isPhone() ? 400 : 900)
            .padding(.trailing,isPhone() ? 740 : 800)
        Color.clear
            .contentShape(Rectangle())
            .ignoresSafeArea()
            .frame(width: isPhone() ? 150 : 150,height: isPhone() ? 365 : 745)
            .padding(.top,100)
            .padding(.leading, isPhone() ? 750 : 1000)
        Color.clear
            .contentShape(Rectangle())
            .ignoresSafeArea()
            .frame(width: isPhone() ? 100 : 400,height: isPhone() ? 35 : 45)
            .padding(.bottom, isPhone() ? 365 : 800)
            .padding(.leading,isPhone() ? 660 : 1200)
    }
}

struct GameViewStandard_Preview: PreviewProvider
{
    static var previews: some View
    {
        let convertJson = ConvertJson()
        let themeManager = ThemeManager()
        let musicManager = BackgroundMusicManager()
        let playerManager = PlayerManager()
        let playerManagerTimer = PlayerManagerTimer()
        
        convertJson.selectedLanguage = "en"
        
        return Group
        {
            GameViewStandard(playerName: "Player", isChangePlayer: true)
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("IPhone")
            
            GameViewStandard(playerName: "Player", isChangePlayer: true)
                .environmentObject(convertJson)
                .environmentObject(themeManager)
                .environmentObject(musicManager)
                .environmentObject(playerManager)
                .environmentObject(playerManagerTimer)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro 11-inch (M4)"))
                .previewDisplayName("IPad")
        }
    }
}
