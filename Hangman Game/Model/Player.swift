//
//  Player.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-05.
//

import Foundation
struct Player: Codable {
    let name: String
    let email: String
    var score: Int = 0
    var numberOfMatches: Int = 0
    }

