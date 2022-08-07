//
//  Model.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/7/22.
//

import Foundation

struct Move: Codable {
    
    let isPlayerOne: Bool
    let boardIndex: Int
    
    var indicator: String {
        return isPlayerOne ? "xmark" : "circle"
    }
}

struct Game: Codable {
    let id: String
    var playerOneId: String
    var playerTwoId: String
    
    var blockMoveForPlayerId: String
    var winnerPlayerId: String
    var rematchPlayerId: [String]
    
    var moves: [Move?]
}
