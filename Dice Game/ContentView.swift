//
//  ContentView.swift
//  Dice Game
//
//  Created by Chase Hashiguchi on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var rotation = 0.0
    @State private var randomValue = 0
    @State private var randomValue1 = 0
    @State private var score = 0
    @State private var highScore = 0
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7).ignoresSafeArea()
            VStack {
                CustomText(text:"Dice Memory Game")
                    .font(.title)
                    .bold()
                HStack {
                    CustomText(text: "Score: \(score)")
                        .padding()
                    CustomText(text: "High Score: \(highScore)")
                }
                HStack{
                    Image("pips \(randomValue)")
                        .resizable()
                        .frame(width: 175, height: 175, alignment: .center)
                        .rotationEffect(.degrees(rotation))
                        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 1, z: 0))
                        .padding()
                    Image("pips \(randomValue1)")
                        .resizable()
                        .frame(width: 175, height: 175, alignment: .center)
                        .rotationEffect(.degrees(rotation))
                        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 1, z: 0))
                }
                .padding()
                Button("Roll") {
                    chooseRandom(times: 3)
                    withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                        rotation += 360
                    }
                }
                .buttonStyle(CustomButtonStyle())
                Spacer()
            }
            .padding()
        }
    }
    func chooseRandom(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue = Int.random(in: 1...6)
                randomValue1 = Int.random(in: 1...6)
                chooseRandom(times: times - 1)
            }
        }
    }
}

struct CustomText: View {
    let text: String
    var body: some View{
        Text(text).font(Font.custom("Marker Felt", size: 36))
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50)
            .font(Font.custom("Marker Felt", size: 24))
            .padding()
            .background(.red).opacity(configuration.isPressed ? 0.0 : 1.0)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
}

struct InstructionsView: View{
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7).ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("In the game of Pig, players take induvidual turns. Each turn, a player repeatdly rolls a single die until either a pig is rolled or the player decides to \"hold\".")
                        .padding()
                    Text("If the player rolls a pig, they score nothing and it becomes the next player's turn.")
                        .padding()
                    Text("If the player rolls any other number, it is added to their turn total and the player's turn continues.")
                        .padding()
                    Text("If a player choosesto \"hold\", their turn total is added to the game score, and it becomes the next player's turn.")
                        .padding()
                    Text("A player wins the game when the game scores becomes 100 or more on their turn")
                        .padding()
                }
                Spacer()
            }
        }
    }
}

    
