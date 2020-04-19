//
//  ContentView.swift
//  PRS
//
//  Created by Stephen Ceresia on 2020-04-16.
//  Copyright © 2020 Stephen Ceresia. All rights reserved.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var userSelection: GameButtonType?
    @Published var cpuSelection: GameButtonType = .none
    
    @Published var paperSelected: Bool = false
    @Published var hammerSeleced: Bool = false
    @Published var scissorsSelected: Bool = false
}

struct ContentView: View {
    @ObservedObject var model = ContentViewModel()
    @State var isSelected: Bool = false
    @State var message: String = "READY"

    let msgWin = "✅"
    let msgLose = "❌"
    let msgTie = "🤷‍♀️"
    let msgDefault = "READY"
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("PAPER. HAMMER. SCISSORS.")
                    .font(.largeTitle).fontWeight(.black)
                    .padding()
                
                Spacer()
                
//                Text("YOU")
//                    .foregroundColor(.blue)
//                    .font(.largeTitle).fontWeight(.black)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading)

                HStack {
                    GameButton(model: self.model, isSelected: self.$model.paperSelected, type: .paper)
                        .padding()
                    
                    Spacer()
                    
                    GameButton(model: self.model, isSelected: self.$model.hammerSeleced, type: .hammer)
                        .padding()
                    
                    Spacer()
                    
                    GameButton(model: self.model, isSelected: self.$model.scissorsSelected, type: .scissors)
                        .padding()
                }
                .padding([.leading, .top, .bottom])
                
                Button(action: {
                    self.playTapped()
                    self.updateResult()
                }) {
                    Text("GO")
                        .font(.largeTitle).fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(self.model.userSelection != nil && self.model.cpuSelection == .none ? .green : .systemGray))
                        .cornerRadius(10)
                }
                .padding()
                .disabled(self.model.userSelection == nil || self.model.cpuSelection != .none)
                
//                Text("CPU")
//                    .foregroundColor(.red)
//                    .font(.largeTitle).fontWeight(.black)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading)

                
                CPUChoice(model: self.model, type: self.$model.cpuSelection)
                
                // Result
                Text(self.message)
                    .font(.largeTitle).fontWeight(.black)
                    .padding()
                
                // reset
                Button(action: {
                    self.reset()
                }) {
                    Text(verbatim: "RESET")
                        .font(.largeTitle).fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(self.model.cpuSelection != .none ? .red : .systemGray))
                        .cornerRadius(10)
                }
                .padding()
                .disabled(self.model.cpuSelection == .none)
            }
        }
    }
    
    func playTapped() {
        let randomInt = Int.random(in: 0..<3)
        self.model.cpuSelection = GameButtonType(rawValue: randomInt) ?? .none
    }
    
    func updateResult() {
        
        switch self.model.userSelection {
        case .hammer:
            if self.model.cpuSelection == .scissors {
                self.message = msgWin
            } else if self.model.cpuSelection == .paper {
                self.message = msgLose
            } else {
                self.message = msgTie
            }
        case .scissors:
            if self.model.cpuSelection == .paper {
                self.message = msgWin
            } else if self.model.cpuSelection == .hammer {
                self.message = msgLose
            } else {
                self.message = msgTie
            }
        case .paper:
            if self.model.cpuSelection == .hammer {
                self.message = msgWin
            } else if self.model.cpuSelection == .scissors {
                self.message = msgLose
            } else {
                self.message = msgTie
            }
        default:
            self.message = msgDefault
        }
    }
    
    func reset() {
        self.model.cpuSelection = .none
        self.model.userSelection = nil
        self.model.paperSelected = false
        self.model.hammerSeleced = false
        self.model.scissorsSelected = false
        self.message = msgDefault
    }
    
}

func getImageName(_ type: GameButtonType) -> String {
    switch type {
    case .paper:
        return "doc"
    case .hammer:
        return "hammer"
    case .scissors:
        return "scissors"
    case .none:
        return "questionmark.square"
    }
}

struct CPUChoice: View {
    @ObservedObject var model: ContentViewModel
    @Binding var type: GameButtonType
    
    var body: some View {
        Image(systemName: getImageName(type))
            .font(.system(size: 62))
            .foregroundColor(.red)
            .padding()
    }
    
}

enum GameButtonType: Int {
    case paper, hammer, scissors, none
}

struct GameButton: View {
    @ObservedObject var model: ContentViewModel
    @Binding var isSelected: Bool
    var type: GameButtonType
    
    var color: Color {
        return isSelected && self.type == self.model.userSelection ? .green : .blue
    }
    
    var body: some View {
        Button(action: {
            if !self.isSelected {
                self.isSelected = true
                self.model.userSelection = self.type
            } else {
                self.isSelected = false
                self.model.userSelection = nil
            }
        }) {
            Image(systemName: getImageName(self.type))
                .font(.system(size: 62))
                .foregroundColor(color)
        }
        .disabled(self.model.cpuSelection != .none)
        .overlay(
            Circle()
                .stroke(color, lineWidth: 4)
                .frame(width: 100, height: 100)
        )
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
