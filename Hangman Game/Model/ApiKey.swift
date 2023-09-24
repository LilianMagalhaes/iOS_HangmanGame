//
//  ApiKey.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-09-23.
//

import Foundation

class WordApiKey {
    static var shared = WordApiKey()
    private let apiKey: String  = "e0c98862e3msh647990220ccb3aap1bb5fejsnc76dc1892be8"
    private init() {}
    
    func getApiKey() -> String {
        return apiKey
    }
}

class MovieApiKey {
    static var shared = MovieApiKey()
    private let apiKey: String = "44c17920&i"
    private init() {}
    
    func getApiKey() -> String {
        return apiKey
    }
}
