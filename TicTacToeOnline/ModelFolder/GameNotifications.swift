//
//  GameNotifications.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/10/22.
//

import SwiftUI

enum GameState {
    case started
    case waitingForPlayer
    case finished
}

struct GameNotification {
    static let waitingForPlayer = "Waiting for player"
    static let gameHasStarted = "Game has started"
    static let gameFinished = "Player left the game, game finished."
}
