//
//  GameViewModel.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/7/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @Published var game = Game(id: UUID().uuidString, playerOneId: "player1", playerTwoId: "player2", blockMoveForPlayerId: "player2", winnerPlayerId: "", rematchPlayerId: [], moves: Array(repeating: nil, count: 9))
    
    private let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5] , [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    
    //MARK: Functions
    
    func processPlayerMove(for position: Int){
        
        if isSquareOccupied(in: game.moves, forIndex: position) { return }
        game.moves[position] = Move(isPlayerOne: true, boardIndex: position)
        
        //block the move
        
        //check for win
        if checkForWinCondition(for: true, in: game.moves){
            print("You have won!")
            return
        }
        
        //check for draw
        if checkForDraw(in: game.moves){
            print("Draw")
            return
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func checkForWinCondition(for playerOne: Bool, in moves: [Move?]) -> Bool {
        let playerMoves = moves.compactMap { $0 }.filter{ $0.isPlayerOne == playerOne }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
}

