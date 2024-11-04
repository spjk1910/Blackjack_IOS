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

// A view that displays options for continuing the current game, starting a new game, or canceling.
struct GameOptionView: View {
    @EnvironmentObject var readJson: ConvertJson // Environment object used for JSON conversion (if needed)
    @Binding var isPresented: Bool // Binding to control the presentation of the view
    var continueAction: () -> Void // Action to continue the current game
    var newGameAction: () -> Void // Action to start a new game

    var body: some View {
        ZStack {
            // Background overlay to dim the screen when the options view is presented
            if isPresented {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    }
                
                // Options menu
                VStack(spacing: 20) {
                    // Title
                    Text("Select an Option")
                        .font(.custom("MTD-Afecta", size: isPhone() ? 45 : 65))
                        .foregroundStyle(Color("Dark"))
                        .padding()
                    
                    // Continue Current Game Button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                        continueAction()
                    }) {
                        Text("Continue Current Game")
                            .frame(maxWidth: .infinity)
                            .font(.custom("iCiel Altus", size: isPhone() ? 24 : 45))
                            .padding()
                            .background(.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    // Play New Game Button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                        newGameAction()
                    }) {
                        Text("Play New Game")
                            .frame(maxWidth: .infinity)
                            .font(.custom("iCiel Altus", size: isPhone() ? 24 : 45))
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    // Cancel Button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .font(.custom("iCiel Altus", size: isPhone() ? 24 : 45))
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .frame(width: isPhone() ? 300 : 400) // Adjust the frame size based on the device
            }
        }
    }
}

struct GameOptionView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for iPhone
            GameOptionView(
                isPresented: .constant(true),
                continueAction: {
                    print("Continue Current Game")
                },
                newGameAction: {
                    print("Play New Game")
                }
            )
            .previewDevice("iPhone 15 Pro")
            .previewDisplayName("iPhone 15 Pro")
            
            // Preview for iPad
            GameOptionView(
                isPresented: .constant(true),
                continueAction: {
                    print("Continue Current Game")
                },
                newGameAction: {
                    print("Play New Game")
                }
            )
            .previewDevice("iPad Pro (11-inch) (4th generation)")
            .previewDisplayName("iPad Pro")
        }
    }
}
