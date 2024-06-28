//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Лада on 26.06.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var statisticService: StatisticServiceProtocol?
    var questionFactory: QuestionFactoryProtocol?
    private var correctAnswers = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
        correctAnswers = 0
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
            self.correctAnswers += 1
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
//            self.resetQuestionIndex()
            self.showQuizResult()
        } else {    // показываем следующий вопрос
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func showQuizResult() {
        // Метод для показа результатов квиза
        
        statisticService!.store(correct: self.correctAnswers, total: self.questionsAmount)
        
        // Форматируем текст для алерта
        let text = """
        Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)
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
                self?.questionFactory?.requestNextQuestion()
            })
        viewController!.alertDelegate.show(alertModel: alertModel)
    }
    
    func didLoadDataFromServer() {
        // Метод для выполнения действий в случае успешной загрузки данных по сети
        
        viewController!.hideLoadingIndicator()
        self.questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        // Метод для обработки неудачного запроса данных от апи
    
        self.showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    private func showNetworkError(message: String) {
        // Функция, которая отображает алерт с ошибкой загрузки
        
        viewController!.hideLoadingIndicator() // скрываем индикатор загрузки
        
        // показываем алерт с ошибкой загрузки данных по сети"
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: {[weak self] in
                guard let self = self else { return }
                
                self.resetQuestionIndex()
                // TODO: тут надо дописать логику повторного запроса на получение данных о фильмах по API
            }
        )
        viewController!.alertDelegate.show(alertModel: alertModel)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }

        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        
        // Оборачиваем метод show, чтобы изменения на экране точно выполнились в главной очереди.
        DispatchQueue.main.async {
            [weak self] in self?.viewController!.showQuestion(quiz: viewModel)
        }
        viewController!.showQuestion(quiz: viewModel)
    }
}

