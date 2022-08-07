//
//  GameButton.swift
//  TicTacToeOnline
//
//  Created by Atakan Apan on 8/7/22.
//

import SwiftUI

struct GameButton: View {
    
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 300, height: 50, alignment: .center)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(25)
    }
}

struct GameButton_Previews: PreviewProvider {
    static var previews: some View {
        GameButton(title: "Play", backgroundColor: .green)
    }
}
