// Сервис для генерации вопросов квиза

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    // Фабрика для генерации вопросов квиза
    
    weak var delegate: QuestionFactoryDelegate?
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    // массив с моковыми вопросами для квиза
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            //        Картинка: The Godfather
            //        Настоящий рейтинг: 9,2
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: ДА
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            //        Картинка: The Dark Knight
            //        Настоящий рейтинг: 9
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: ДА
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            //        Картинка: Kill Bill
            //        Настоящий рейтинг: 8,1
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: ДА
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            //        Картинка: The Avengers
            //        Настоящий рейтинг: 8
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: ДА
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            //        Картинка: Deadpool
            //        Настоящий рейтинг: 8
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: ДА
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            //        Картинка: The Green Knight
            //        Настоящий рейтинг: 6,6
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: ДА
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            //        Картинка: Old
            //        Настоящий рейтинг: 5,8
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: НЕТ
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            //        Картинка: The Ice Age Adventures of Buck Wild
            //        Настоящий рейтинг: 4,3
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: НЕТ
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            //        Картинка: Tesla
            //        Настоящий рейтинг: 5,1
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: НЕТ
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            //        Картинка: Vivarium
            //        Настоящий рейтинг: 5,8
            //        Вопрос: Рейтинг этого фильма больше чем 6?
            //        Ответ: НЕТ
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
    ]
}
