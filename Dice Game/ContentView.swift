//
//  ContentView.swift
//  Dice Game
//
//  Created by Chase Hashiguchi on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var rotation = 0.0
    @State private var Dice1 = 0
    @State private var Dice2 = 0
    @State private var score = 0
    @State private var highScore = 0
    @State private var guess = ""
    @State private var isGameOver = false
    @State private var turnMessage = ""
    @State private var guessDice1 = ""
    @State private var guessDice2 = ""
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
                    Image("pips \(Dice1)")
                        .resizable()
                        .frame(width: 175, height: 175, alignment: .center)
                        .rotationEffect(.degrees(rotation))
                        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 1, z: 0))
                        .padding()
                    Image("pips \(Dice2)")
                        .resizable()
                        .frame(width: 175, height: 175, alignment: .center)
                        .rotationEffect(.degrees(rotation))
                        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 1, z: 0))
                }
                .padding()
                HStack {
                    TextField("Enter guess for Dice 1", text: $guessDice1)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title)
                        .onChange(of: guessDice1) { newValue in
                            // Allow only numeric input
                            guessDice1 = newValue.filter { $0.isNumber }
                        }
                    
                    TextField("Enter guess for Dice 2", text: $guessDice2)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title)
                        .onChange(of: guessDice2) { newValue in
                            // Allow only numeric input
                            guessDice2 = newValue.filter { $0.isNumber }
                        }
                }
                Button("Roll") {
                    if !isGameOver {
                        chooseRandom(times: 3)
                        withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                            rotation += 360
                        }
                        checkGuess()
                    }
                }
                .buttonStyle(CustomButtonStyle())
                Spacer()
                if isGameOver {
                    VStack {
                        Text(turnMessage)
                            .font(.title)
                            .foregroundColor(.red)
                            .padding()
                        
                        // OK button to continue and reset for next player
                        Button("OK") {
                            // Check if the current score is higher than the high score
                            if score > highScore {
                                highScore = score
                            }
                            // Reset the current score and continue to the next player
                            score = 0
                            isGameOver = false
                            turnMessage = ""
                        }
                        .buttonStyle(CustomButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
    func chooseRandom(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Dice1 = Int.random(in: 1...6)
                Dice2 = Int.random(in: 1...6)
                chooseRandom(times: times - 1)
            }
        }
    }
    
    func checkGuess() {
        // Convert the entered guesses for both dice into integers
        if let enteredGuessDice1 = Int(guessDice1), let enteredGuessDice2 = Int(guessDice2) {
            // Check if both entered guesses match the dice rolls
            if enteredGuessDice1 == Dice1 && enteredGuessDice2 == Dice2 {
                score += 1  // Increase score if the guess is correct
                // Do not change turn if the guess is correct
                turnMessage = ""  // Clear any "Next Player" message
                isGameOver = false  // Keep the current player's turn active
            } else {
                // If the guess is incorrect, end the turn and show the next player message
                turnMessage = "Next Player"
                isGameOver = true  // End the current player's turn
            }
        }
        
        // Clear both guess fields after checking
        guessDice1 = ""
        guessDice2 = ""
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


