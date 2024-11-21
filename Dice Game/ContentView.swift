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
    var body: some View {
        VStack {
            CustomText(text:"Dice Memory Game")
                .font(.title)
                .bold()
                .padding()
            Spacer()
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
    func chooseRandom(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue = Int.random(in: 1...6)
                randomValue1 = Int.random(in: 1...6)
                chooseRandom(times: times - 1)
            }
        }
       // if times == 0 {
           // if randomValue == 1 {
             //   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //}
           // }
        //}
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
