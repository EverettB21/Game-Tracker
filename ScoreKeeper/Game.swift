//
//  Game.swift
//  ScoreKeeper
//
//  Created by Everett Brothers on 10/17/23.
//

import Foundation

enum Setting: Codable {
    case highScore, lowScore, none
}

struct Game: Equatable, CustomStringConvertible, Codable {
    var name: String
    var players: [Player]
    var settings: Setting
    
    static var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var archiveURL = documentDirectory.appendingPathComponent("games").appendingPathExtension("plist")
    static var sampleGame = Game(name: "Game1", players: [Player(name: "Player1", score: 5)], settings: .highScore)
    
    static func saveToFile(games: [Game]) {
        let propertyEncoder = PropertyListEncoder()
        
        if let encoded = try? propertyEncoder.encode(games) {
            try? encoded.write(to: archiveURL, options: .noFileProtection)
        }
    }
    
    static func loadFromFile() -> [Game] {
        let propertyDecoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: archiveURL) {
            let decoded = try? propertyDecoder.decode([Game].self, from: data)
            return decoded ?? [sampleGame]
        }
        
        return [sampleGame]
    }
    
    var description: String {
        return "\(self.name.capitalized), players: \(self.players.count)"
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.name == rhs.name
    }
}
