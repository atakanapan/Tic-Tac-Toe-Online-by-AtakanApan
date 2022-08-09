//
//  GameViewModel.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/7/22.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var game: Game? {
        didSet {
            //check the game status
            checkIfGameIsOver()
        }
    }
    @Published var currentUser: User!
    @Published var alertItem: AletItem?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5] , [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    
    //MARK: Init
    
    init() {
        retriveUser()
        if currentUser == nil {
            saveUser()
        }
        print("We have a user with ID: ", currentUser.id)
    }
    
    
    //MARK: Functions
    
    func getTheGame(){
        FirebaseService.shared.startGame(with: currentUser.id)
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    
    func processPlayerMove(for position: Int){
        
        guard game != nil else { return }
        
        if isSquareOccupied(in: game!.moves, forIndex: position) { return }
        game!.moves[position] = Move(isPlayerOne: isPlayerOnePlaying(), boardIndex: position)
        //block the move
        game!.blockMoveForPlayerId = currentUser.id
        FirebaseService.shared.updateGame(game!)
        
        //check for win
        if checkForWinCondition(for: isPlayerOnePlaying(), in: game!.moves){
            print("You have won!")
            game!.winnerPlayerId = currentUser.id
            FirebaseService.shared.updateGame(game!)
            return
        }
        //check for draw
        if checkForDraw(in: game!.moves){
            print("Draw")
            game!.winnerPlayerId = "0"
            FirebaseService.shared.updateGame(game!)
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
    
    func quiteGame() {
        FirebaseService.shared.quiteTheGame()
    }
    
    func checkForGameStatus() -> Bool {
        //check for game!.blockMoveForPlayerId == currentUser.id otherwise (by using :) false
        return game != nil ? game!.blockMoveForPlayerId == currentUser.id : false
    }
    
    func isPlayerOnePlaying() -> Bool {
        return game != nil ? game!.playerOneId == currentUser.id : false
    }
    
    func checkIfGameIsOver() {
        alertItem = nil
        
        guard game != nil else { return }
        if game!.winnerPlayerId == "0" {
            //for draw
            alertItem = AlertContext.draw
        }
        else if game!.winnerPlayerId != "" {
            if game!.winnerPlayerId == currentUser.id {
                //for won
                alertItem = AlertContext.youWin
            }
            else {
                //for lost
                alertItem = AlertContext.youLost
                
            }
        }
    }
    
    func resetGame() {
        
    }
    
    //MARK: User Object
    
    func saveUser(){
        currentUser = User()
        do{
            print("encoding user")
            let data = try JSONEncoder().encode(currentUser)
            userData = data
        } catch { print("User cant saved") }
    }
    
    func retriveUser(){
        guard let userData = userData else { return }
        do {
            print("decoding user")
            currentUser = try JSONDecoder().decode(User.self, from: userData)
        } catch { print("No user saved") }
    }
}

