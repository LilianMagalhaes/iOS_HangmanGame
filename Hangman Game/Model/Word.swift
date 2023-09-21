//
//  Word.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-09-21.
//

import Foundation

struct Word: Decodable {
    var word: String
    let results: [WordResult]
}

struct WordResult: Decodable {
    let definition: String
    let partOfSpeech: String
    let synonyms: [String]?
    let typeOf: [String]?
}
    
