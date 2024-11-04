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
import AVKit

struct HowToPlayDetailView: View {
    var animation: Namespace.ID
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var readJson: ConvertJson
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @EnvironmentObject var selectedObject: SelectedObject // Access through @EnvironmentObject
    @State private var player = AVPlayer()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    //Separator
                    Rectangle()
                        .fill(Color("Arrow"))
                        .frame(height: 3)
                        .padding()
                    
                    HStack {
                        
                        Spacer()
                        //Title of View
                        Text(readJson.localizedString(forKey: "\(selectedObject.name)"))
                            .font(.custom("MTD-Afecta", size: isPhone() ? 70 : 100))
                            .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                            .padding()
                        
                        Spacer()
                        //Button to exit current view
                        Image(systemName: "arrow.down.forward.and.arrow.up.backward.circle")
                            .font(.system(size: isPhone() ? 30 : 50))
                            .foregroundStyle(Color("Button"))
                            .padding(.trailing)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                    selectedObject.isShowing.toggle()
                                }
                            }
                    }
                    
                    //Separator
                    Rectangle()
                        .fill(Color("Arrow"))
                        .frame(height: 3)
                        .padding()
                    
                    switch selectedObject.name {
                    case "objective": //Objective View
                        Text(readJson.localizedString(forKey: "\(selectedObject.name)Description"))
                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                            .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.1)
                            .padding()
                        
                    case "cardValues": //CardValues View
                        VStack
                        {
                            //CardValues View in English
                            if selectedLanguage == "English" {
                                VStack(alignment: .leading, spacing: isPhone() ? 16 : 32) {
                                    HStack(alignment: .top) {
                                        Text("Number Cards \n(2 - 10):")
                                            .underline(true)
                                            .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                            .frame(width: isPhone() ? 200 : 400, alignment: .leading) // Adjust width based on your needs
                                        Text("Worth at face value (For example: a 2 is worth 2 points, a 5 is worth 5 points).")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    
                                    HStack(alignment: .top) {
                                        Text("Face Cards \n(Jack, Queen, King):")
                                            .underline(true)
                                            .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                            .frame(width: isPhone() ? 200 : 400, alignment: .leading)
                                        Text("\nWorth 10 points.")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    
                                    HStack(alignment: .top) {
                                        Text("Aces (A):")
                                            .underline(true)
                                            .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                            .frame(width: isPhone() ? 200 : 400, alignment: .leading)
                                        Text("Worth either 1 or 11 points, depending on which value benefits your hand more.")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                }
                                .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                                .minimumScaleFactor(0.1)
                            } else {
                                //CardValues View in Vietnamese
                                VStack(alignment: .leading, spacing: isPhone() ? 16 : 32) {
                                    HStack(alignment: .top) {
                                        Text("Các Lá Bài Số \n(2 - 10):")
                                            .underline(true)
                                            .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                            .frame(width: isPhone() ? 250 : 400, alignment: .leading) // Fixed width to align all labels
                                        Text("Số điểm tương ứng với số trên mặt lá bài (Ví dụ: Lá 2 được tính là 2 điểm, lá 5 được tính là 5 điểm).")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    
                                    HStack(alignment: .top) {
                                        Text("Các Lá Bài Hình \n(Bồi, Đầm, Già):")
                                            .underline(true)
                                            .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                            .frame(width: isPhone() ? 250 : 400, alignment: .leading) // Same fixed width as above
                                        Text("Mỗi lá bài được tính 10 điểm.")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    
                                    HStack(alignment: .top) {
                                        Text("Lá Át (A):")
                                            .underline(true)
                                            .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                            .frame(width: isPhone() ? 250 : 400, alignment: .leading) // Same fixed width as above
                                        Text("Có thể tính linh hoạt là 1 điểm hoặc 11 điểm tùy vào giá trị nào có lợi cho người chơi.")
                                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                }
                                .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                                .minimumScaleFactor(0.1)
                            }
                            
                            Image("cardValueImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        }
                        
                    case "gameModeAndDifficulty": //Gamemode and Diffuculty View
                        VStack
                        {
                            Text("\(readJson.localizedString(forKey: "mode"))")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "mode1")): ")
                                    .underline(true)
                                    .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                    .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                Text("\(readJson.localizedString(forKey: "modeFullDescription1"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "mode2")): ")
                                    .underline(true)
                                    .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                    .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                Text("\(readJson.localizedString(forKey: "modeFullDescription2"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            Text("\(readJson.localizedString(forKey: "difficulty"))")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                                .padding()
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "difficulty1")): ")
                                    .underline(true)
                                    .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                    .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                Text("\(readJson.localizedString(forKey: "difficultyFullDescription1"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "difficulty2")): ")
                                    .underline(true)
                                    .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                    .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                Text("\(readJson.localizedString(forKey: "difficultyFullDescription2"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "difficulty3")): ")
                                    .underline(true)
                                    .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                    .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                Text("\(readJson.localizedString(forKey: "difficultyFullDescription3"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                        }
                        .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                        .minimumScaleFactor(0.1)
                        
                    case "gamePlay": //GamePlay View
                        VStack
                        {
                            Text("\(readJson.localizedString(forKey: "setup"))")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "setupDescription"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            //Show video of How to start game
                            if let videoURL = Bundle.main.url(forResource: isPhone() ? "setupGamePlayIP" : "setupGamePlayIpad", withExtension: "mov") {
                                VideoPlayer(player: AVPlayer(url: videoURL))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width)
                                    .padding()
                                    .clipped()
                            } else {
                                Text("Video not found") //Print error if video not found
                                    .foregroundColor(.red)
                            }
                            
                            Text("\(readJson.localizedString(forKey: "playerTurn"))")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                                .padding()
                            VStack(alignment: .leading) {
                                
                                Text("\(readJson.localizedString(forKey: "playerTurnDescription"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                
                                HStack(alignment: .top) {
                                    Text("\(readJson.localizedString(forKey: "hit")): ")
                                        .underline(true)
                                        .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                        .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                    Text("\(readJson.localizedString(forKey: "playerTurnDescriptionHit"))")
                                        .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding()
                                
                                HStack(alignment: .top) {
                                    Text("\(readJson.localizedString(forKey: "stand")): ")
                                        .underline(true)
                                        .font(.custom("iCiel Altus", size: isPhone() ? 35 : 70))
                                        .frame(width: isPhone() ? 250 : 400, alignment: .leading)
                                    Text("\(readJson.localizedString(forKey: "playerTurnDescriptionStand"))")
                                        .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            Text("\(readJson.localizedString(forKey: "dealerTurn"))")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "dealerTurnDescription"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            Text("\(readJson.localizedString(forKey: "winlose"))")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "winloseDescription"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            
                            Text("Blackjack")
                                .font(.custom("iCiel Altus", size: isPhone() ? 50 : 90))
                            HStack(alignment: .top)
                            {
                                Text("\(readJson.localizedString(forKey: "blackjackDescription"))")
                                    .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            
                            
                        }
                        .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                        .minimumScaleFactor(0.1)
                        
                        
                    default: //Defaylt view ~ No View
                        Text("Crashed View")
                            .font(.custom("iCiel Altus", size: isPhone() ? 30 : 60))
                            .foregroundStyle(Color(themeManager.colorScheme == .dark ? Color("Light") : Color("Dark")))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.1)
                            .padding()
                    }
                    
                }
                .frame(width: geometry.size.width) // Make sure the VStack takes the full width
                .padding(.bottom)
            }
            .background(Color(themeManager.colorScheme == .dark ? Color("Dark") : Color("Light")).ignoresSafeArea())
        }
        .onAppear
        {
            readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi"
        }
    }
}
