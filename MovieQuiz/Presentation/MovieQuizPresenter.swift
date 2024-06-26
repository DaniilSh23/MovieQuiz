//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Лада on 26.06.2024.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
        
        let questionStep = QuizStepViewModel( // Создаём константу questionStep и вызываем конструктор QuizStepViewModel
            image: UIImage(data: model.image) ?? UIImage(), // Инициализируем картинку с помощью конструктора UIImage(named: ); если картинки с таким названием не найдётся, подставляем пустую
            question: model.text, // Просто забираем уже готовый вопрос из мокового вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // Высчитываем номер вопроса с помощью переменной текущего вопроса currentQuestionIndex и массива со списком вопросов questions
        return questionStep
    }
}

