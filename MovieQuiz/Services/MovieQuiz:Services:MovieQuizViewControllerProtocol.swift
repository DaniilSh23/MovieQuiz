//
//  MovieQuiz:Services:MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Лада on 01.07.2024.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {    
    func showAnswerResult(isCorrect: Bool)
    func showNetworkError(message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showQuestion(quiz question: QuizStepViewModel)
    var alertDelegate: AlertPresenterProtocol? {get set}
}
