//
//  FirebaseReference.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/7/22.
//

import Firebase

enum FCollectionReference: String {
    case Game
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
