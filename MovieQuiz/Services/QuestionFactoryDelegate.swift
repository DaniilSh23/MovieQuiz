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
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
