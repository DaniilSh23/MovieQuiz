//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Лада on 28.05.2024.
//

import Foundation


protocol StatisticServiceProtocol {
    // Протокол, определяющий основу для логики подсчета статистики квиза/
    
    var gamesCount: Int {get} // Количество сыграных квизов
    var bestGame: GameResult {get} // Результат лучшей попытки
    var totalAccuracy: Double {get} // Средняя точность ответов
    
    func store(correct count: Int, total amount: Int) // метод для сохранения данных
}
