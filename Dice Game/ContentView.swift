//
//  ContentView.swift
//  Dice Game
//
//  Created by Chase Hashiguchi on 10/23/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var rotation = 0.0
    @State private var Dice1 = 0
    @State private var Dice2 = 0
    @State private var guess = ""
    @State private var isGameOver = false
    @State private var turnMessage = ""
    @State private var guessDice1 = ""
    @State private var guessDice2 = ""
    @State private var isDiceVisible = true
    @State private var isRolling = false
    @State private var isWinner = false
    @State private var currentPlayer = 1 // Track the current player (1 or 2)
    @State private var player1Score = 0 // Player 1's score
    @State private var player2Score = 0 // Player 2's score
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.7)
                VStack {
                    Image("MysteryDice").resizable().frame(width: 150, height: 150)
                    CustomText(text:"Dice Memory Game")
                        .font(.title)
                        .bold()
                    HStack {
                        CustomText(text: "P1 Score: \(player1Score)")
                        CustomText(text: "P2 Score: \(player2Score)")
                    }
                    CustomText(text: "Player \(currentPlayer)'s Turn")
                        .font(.title)
                        .padding()

                    HStack {
                        // Show the dice or placeholder images based on `isDiceVisible`
                        if isDiceVisible {
                            // Show actual dice faces if visible
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
                        } else {
                            // Show placeholder images while the dice are hidden (pips 0)
                            Image("pips 0")  // Placeholder for the first die
                                .resizable()
                                .frame(width: 175, height: 175, alignment: .center)
                                .padding()
                            Image("pips 0")  // Placeholder for the second die
                                .resizable()
                                .frame(width: 175, height: 175, alignment: .center)
                        }
                    }
                    // .padding()
                    HStack {
                        TextField("Enter guess for Dice 1", text: $guessDice1)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title)
                            .disabled(isGameOver) // Disable input when the game is over
                            .onChange(of: guessDice1) { newValue in
                                if !isGameOver { // Allow filtering only when the game is active
                                    guessDice1 = newValue.filter { $0.isNumber }
                                }
                            }
                        
                        TextField("Enter guess for Dice 2", text: $guessDice2)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title)
                            .disabled(isGameOver) // Disable input when the game is over
                            .onChange(of: guessDice2) { newValue in
                                if !isGameOver { // Allow filtering only when the game is active
                                    guessDice2 = newValue.filter { $0.isNumber }
                                }
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
                    NavigationLink("How to Play", destination: InstructionsView())
                        .font(Font.custom("Marker Felt", size: 24))
                    Spacer()
                    if isWinner {
                        VStack {
                            Text("You Win!")
                                .font(.title)
                                .foregroundColor(.green)
                                .padding()
                            
                            // Reset button to restart the game
                            Button("Reset") {
                                resetGame()  // Reset the game and start over
                            }
                            .buttonStyle(CustomButtonStyle())
                            .padding()
                        }
                    }
                    
                    // Display the turn-over message and button to continue if game over
                    if isGameOver && !isWinner {
                        VStack {
                            Text(turnMessage)
                                .font(.title)
                                .foregroundColor(.red)
                                .padding()
                            
                            // OK button to continue and reset for next player
                            Button("OK") {
                                isGameOver = false
                                turnMessage = ""
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func chooseRandom(times: Int) {
        guard !isGameOver else { return } // Stop rolling if the game is over
        
        isDiceVisible = true
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Dice1 = Int.random(in: 1...6)
                Dice2 = Int.random(in: 1...6)
                chooseRandom(times: times - 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                // Hide the dice after the 3 seconds viewing period
                isDiceVisible = false
                checkGuess()  // Check the guess after the dice are shown
            }
        }
    }
    
    func checkGuess() {
        if let enteredGuessDice1 = Int(guessDice1), let enteredGuessDice2 = Int(guessDice2) {
            if enteredGuessDice1 == Dice1 && enteredGuessDice2 == Dice2 {
                // Correct guess: Add score to the current player
                if currentPlayer == 1 {
                    player1Score += 1
                } else {
                    player2Score += 1
                }
                // Check if the current player has won
                if (currentPlayer == 1 && player1Score >= 20) || (currentPlayer == 2 && player2Score >= 20) {
                    isWinner = true
                    turnMessage = "Player \(currentPlayer) Wins!"
                    isGameOver = true
                }
                SoundManager.shared.playSound(named: "Correct")
            } else {
                // Incorrect guess: End turn and switch player
                turnMessage = "Incorrect! Player \(currentPlayer == 1 ? 2 : 1)'s Turn"
                SoundManager.shared.playSound(named: "Incorrect")
                isGameOver = true
                // Switch player
                currentPlayer = currentPlayer == 1 ? 2 : 1
            }
        }
        
        // Clear guess fields
        guessDice1 = ""
        guessDice2 = ""
    }
    
func resetGame() {
    // Reset all game-related variables to start fresh
    isDiceVisible = true
    isRolling = false
    isGameOver = false
    isWinner = false
    Dice1 = 0
    Dice2 = 0
    rotation = 0.0
    guessDice1 = ""
    guessDice2 = ""
    turnMessage = ""
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
                Image("MysteryDice").resizable().frame(width: 200, height: 200)
                Text("Dice Memory Game").font(.title)
                VStack(alignment: .leading) {
                    Text("In Dice Memory Game, players take induvidual turns. Each turn, a player rolls a pair of die then are given three seconds to memorize the values to guess.")
                        .padding()
                    Text("If the player guesses a die incorrectly, there turn ends and it's the next players turn.")
                        .padding()
                    Text("If the player guesses correctly, it is added to their score until they lose, which turns into the high score if their score is higher than the current high score shown.")
                        .padding()
                    Text("A player wins the game when the game scores becomes 20 on their turn")
                        .padding()
                }
                Spacer()
            }
        }
    }
}

class SoundManager { // made class to play sounds
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return } // gaurd is a statement that handles situtaions where a condition fails
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
