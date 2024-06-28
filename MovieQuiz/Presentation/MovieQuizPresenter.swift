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
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var statisticService: StatisticServiceProtocol?
    var questionFactory: QuestionFactoryProtocol?
    
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
    
    func clickButtonAction(_ userAnswer: Bool){
        // Функция с логикой нажатия на кнопку Да или Нет

        guard let thisQuestion = currentQuestion else {return}
        
        // Проверяем правильность ответа пользователя
        if userAnswer == thisQuestion.correctAnswer {
            viewController!.correctAnswers += 1
            viewController!.showAnswerResult(isCorrect: true)
        } else {
            viewController!.showAnswerResult(isCorrect: false)
        }
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // через 1 секунду показываем следующий вопрос
            
            guard let self = self else { return } // разворачиваем слабую ссылку
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        // метод, который содержит логику перехода в один из сценариев (показать следующий вопрос/показать результаты квиза)
        
        if self.isLastQuestion() {    // состояние "Результат квиза"
            self.resetQuestionIndex()
            self.showQuizResult()
        } else {    // показываем следующий вопрос
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func showQuizResult() {
        // Метод для показа результатов квиза
        
        statisticService!.store(correct: viewController!.correctAnswers, total: self.questionsAmount)
        
        // Форматируем текст для алерта
        let text = """
        Ваш результат: \(viewController!.correctAnswers)/\(self.questionsAmount)
        Количество сыгранных квизов: \(statisticService!.gamesCount)
        Рекорд: \(statisticService!.bestGame.correct)/\(statisticService!.bestGame.total) (\(statisticService!.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%"
        """
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз",
            completion: {[weak self] in
                self?.resetQuestionIndex()
                self?.viewController?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            })
        viewController!.alertDelegate.show(alertModel: alertModel)
        viewController!.correctAnswers = 0
    }
}

