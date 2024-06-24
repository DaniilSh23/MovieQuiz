//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Лада on 27.05.2024.
//

import Foundation


protocol QuestionFactoryDelegate: AnyObject {
    // Протокол для реализации делегата фабрики вопросов
    
    func didReceiveNextQuestion(question: QuizQuestion?)
}
