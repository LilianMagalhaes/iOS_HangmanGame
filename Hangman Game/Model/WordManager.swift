//
//  DictionaryMode.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-05.
//
import Foundation

class WordManager {
    static let shared = WordManager()
    
    private let apiKey = "e0c98862e3msh647990220ccb3aap1bb5fejsnc76dc1892be8"
    private let baseUrl = "https://wordsapiv1.p.rapidapi.com/words/?random=true"
    
    private init() {}
    
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"
        ]
        return URLSession(configuration: config)
    }
    
    func fetchRandomWord(maxRetries: Int, completion: @escaping (Result<Word, Error>) -> Void) {
            reFetch(maxRetries: maxRetries, currentRetry: 0, completion: completion)
        }
    
    private func reFetch(maxRetries: Int, currentRetry: Int, completion: @escaping (Result<Word, Error>) -> Void) {
            fetchWord { result in
                switch result {
                case .success(let wordData):
                    completion(.success(wordData))
                case .failure(let error):
                    if currentRetry < maxRetries {
                        // Retry fetching if not exceeding maxRetries
                        self.reFetch(maxRetries: maxRetries, currentRetry: currentRetry + 1, completion: completion)
                    } else {
                        // Exceeded maxRetries, return the last error
                        completion(.failure(error))
                    }
                }
            }
        }
    
    func fetchWord(completion: @escaping (Result<Word, Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let wordData = try JSONDecoder().decode(Word.self, from: data)
                if self.isValidWordData(wordData) {
                    completion(.success(wordData))
                } else {
                    completion(.failure(NetworkError.invalidWordData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func isValidWordData(_ wordData: Word) -> Bool {
        guard wordData.word.count > 12 else {
            return false
        }
        print("wordCount: ", wordData.word.count)
        for result in wordData.results {
            if !result.definition.isEmpty &&
                !result.partOfSpeech.isEmpty &&
                result.typeOf != nil {
                return true
            }
        }
        return false
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidWordData
}





/*    func getWord(callback: @escaping (Bool, Data?) -> Void) {
 guard let url = URL(string: baseUrl + "word") else {
 callback(false, nil)
 return
 }
 task?.cancel()
 task = session.dataTask(with: url) { (data, response, error) in
 DispatchQueue.main.async {
 guard let data = data, error == nil,
 let response = response as? HTTPURLResponse, response.statusCode == 200 else {
 callback(false, nil)
 return
 }
 callback(true, data)
 }
 }
 task?.resume()
 }
 */

/*
 private func parseWordData(_ data: Data) -> (String?, String?, String?, String?) {
 do {
 let decoder = JSONDecoder()
 let wordData = try decoder.decode(Word.self, from: data)
 
 if let firstResult = wordData.results.first {
 let word = wordData.word
 let partOfSpeech = firstResult.partOfSpeech
 let definition = firstResult.definition
 let typeOf = firstResult.typeOf?.joined(separator: ", ") ?? ""
 
 return (word, definition, partOfSpeech, typeOf)
 } else {
 return (nil, nil, nil, nil)
 }
 } catch {
 print("Error decoding JSON: \(error)")
 return (nil, nil, nil, nil)
 }
 }
 */




