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

struct HowToPlayView: View {
    @EnvironmentObject var selectedObject: SelectedObject
    var animation: Namespace.ID
    
    // Array of guide identifiers
    static let guideArray = ["objective", "cardValues", "gameModeAndDifficulty", "gamePlay"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                // Create a GuideCardView for each guide item
                ForEach(HowToPlayView.guideArray, id: \.self) { guide in
                    GuideCardView(animation: animation, guide: guide)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                // Update selectedObject and toggle visibility
                                selectedObject.name = guide
                                selectedObject.isShowing.toggle()
                            }
                        }
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 16)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.0)
                                .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                                .offset(y: phase.isIdentity ? 0 : 50)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}
