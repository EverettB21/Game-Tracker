//
//  Player.swift
//  ScoreKeeper
//
//  Created by Everett Brothers on 10/16/23.
//

import Foundation

struct Player: Comparable, Codable {
    var name: String
    var score: Int
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.score < rhs.score
    }
}
