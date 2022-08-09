//
//  AlertItem.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/10/22.
//

import SwiftUI

struct AletItem: Identifiable {
    let id = UUID()
    var isForQuit = false
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let youWin = AletItem(title: Text("You Win!"), message: Text("You win this game! Do you wanna rematch?"), buttonTitle: Text("Rematch"))
    static let youLost = AletItem(title: Text("You Lost!"), message: Text("You lost this game! Do you wanna rematch?"), buttonTitle: Text("Rematch"))
    static let draw = AletItem(title: Text("Draw!"), message: Text("Draw! Do you wanna rematch?"), buttonTitle: Text("Rematch"))
    static let opponentQuit = AletItem(isForQuit: true, title: Text("Opponent Quit!"), message: Text("Your opponent has left."), buttonTitle: Text("Quit"))
}
