//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Лада on 26.05.2024.
//

import Foundation


protocol QuestionFactoryProtocol {
    // Протокол реализации фабрики генерации вопросов
    
    func loadData()
    func requestNextQuestion()
}
