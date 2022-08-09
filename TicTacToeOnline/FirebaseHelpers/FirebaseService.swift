//
//  FirebaseService.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/7/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

final class FirebaseService: ObservableObject{
    
    static let shared = FirebaseService()
    
    @Published var game: Game!
    
    init(){ }
    
    func createOnlineGame() {
        //save the game online
        do{
            try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch{
            print("Error creating online game ", error.localizedDescription)
        }
    }
    
    func startGame(with userId: String) {
        //check if theres game to join, if no create, if yes join and listen changes
        FirebaseReference(.Game).whereField("playerTwoId", isEqualTo: "").whereField("playerTwoId", isNotEqualTo: userId).getDocuments { querySnapshot, error in
            if error != nil{
                print("Error starting game ", error?.localizedDescription ?? "and cannot get error")
                self.createNewGame(with: userId)
                return
            }
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.game.playerTwoId = userId
                self.game.blockMoveForPlayerId = userId
                self.updateGame(self.game)
                self.listenForGameChanges()
            }
            else {
                self.createNewGame(with: userId)
            }
        }
    }
    
    func listenForGameChanges() {
        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { documentSnapshot, error in
            print("Changes recived from firebase")
            if error != nil {
                print("Error listening changes ", error?.localizedDescription ?? "and cannot get error")
                return
            }
            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    
    func createNewGame(with userId: String) {
        print("Creating game for userId ", userId)
        self.game = Game(id: UUID().uuidString, playerOneId: userId, playerTwoId: "", blockMoveForPlayerId: userId, winnerPlayerId: "", rematchPlayerId: [], moves: Array(repeating: nil, count: 9))
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func updateGame(_ game: Game) {
        print("...updating the game")
        do {
            try FirebaseReference(.Game).document(game.id).setData(from: game)
        } catch {
            print("Error updating online game", error.localizedDescription)
        }
    }
    
    func quiteTheGame() {
        guard game != nil else { return }
        FirebaseReference(.Game).document(self.game.id).delete()
    }
    
}
