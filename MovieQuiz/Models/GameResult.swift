//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Лада on 28.05.2024.
//

import Foundation


struct GameResult: Codable {
    
    let correct: Int
    let total: Int
    let date: Date
    
    func isNewRecord(bestResult: GameResult) -> Bool {
        // метод сравнения рекордов
        return self.correct > bestResult.correct
    }
}
