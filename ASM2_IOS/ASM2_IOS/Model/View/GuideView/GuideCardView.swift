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

struct GuideCardView: View {
    // Environment object for handling JSON-based localization
    @EnvironmentObject var readJson: ConvertJson
    
    // Namespace ID for animation
    var animation: Namespace.ID
    
    // Name of the guide image
    var guide: String
    
    // App storage property for selected language
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Guide image setup
            Image(guide)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: isPhone() ? 500 : 1000)
            
            HStack {
                Spacer()
                
                VStack {
                    // Displaying localized text using readJson object
                    Text(readJson.localizedString(forKey: "\(guide)"))
                        .font(.custom("MTD-Afecta", size: isPhone() ? 50 : 100))
                }
                
                Spacer()
            }
            .padding()
            .foregroundStyle(.black)
            .background(.white.opacity(0.75))
            .aspectRatio(contentMode: .fit)
            .frame(width: isPhone() ? 500 : 1000)
        }
        .onAppear {
            // Set selected language based on stored app storage value
            readJson.selectedLanguage = selectedLanguage == "English" ? "en" : "vi"
        }
    }
}
