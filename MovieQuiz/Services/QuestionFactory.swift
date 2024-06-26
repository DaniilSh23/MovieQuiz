// Сервис для генерации вопросов квиза

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    // Фабрика для генерации вопросов квиза
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
            self.moviesLoader = moviesLoader
            self.delegate = delegate
        }
    
    func loadData() {
        // Метод для загрузки данных по апи
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        // Метод получения следующего вопроса
        
        // Выполняем всю логику в отдельном потоке, так как будет запрос картинки по сети
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }   // Хз че за нах и зачем вытаскивать self
            
            // Берем рандомный фильм из общего списка
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            // По дефолту ставим, что картинка будет пустыми данными и потом пробуем достать ее по сети
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }

            let rating = Float(movie.rating) ?? 0
            let ratingForQuestion = Float(Double(arc4random_uniform(UInt32(10))))
            let text = "Рейтинг этого фильма больше чем \(ratingForQuestion)?"
            let correctAnswer = rating > ratingForQuestion

            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            
            // Возвращаем вопрос в основной поток, используя для этого делегата
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate!.didReceiveNextQuestion(question: question)
            }
        }
    }
    
//    func requestNextQuestion() {
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didReceiveNextQuestion(question: nil)
//            return
//        }
//        let question = questions[safe: index]
//        delegate?.didReceiveNextQuestion(question: question)
//    }
    
    // массив с моковыми вопросами для квиза
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            //        Картинка: The Godfather
//            //        Настоящий рейтинг: 9,2
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: ДА
//            image: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            //        Картинка: The Dark Knight
//            //        Настоящий рейтинг: 9
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: ДА
//            image: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            //        Картинка: Kill Bill
//            //        Настоящий рейтинг: 8,1
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: ДА
//            image: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            //        Картинка: The Avengers
//            //        Настоящий рейтинг: 8
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: ДА
//            image: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            //        Картинка: Deadpool
//            //        Настоящий рейтинг: 8
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: ДА
//            image: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            //        Картинка: The Green Knight
//            //        Настоящий рейтинг: 6,6
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: ДА
//            image: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true
//        ),
//        QuizQuestion(
//            //        Картинка: Old
//            //        Настоящий рейтинг: 5,8
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: НЕТ
//            image: "Old",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//        QuizQuestion(
//            //        Картинка: The Ice Age Adventures of Buck Wild
//            //        Настоящий рейтинг: 4,3
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: НЕТ
//            image: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//        QuizQuestion(
//            //        Картинка: Tesla
//            //        Настоящий рейтинг: 5,1
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: НЕТ
//            image: "Tesla",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//        QuizQuestion(
//            //        Картинка: Vivarium
//            //        Настоящий рейтинг: 5,8
//            //        Вопрос: Рейтинг этого фильма больше чем 6?
//            //        Ответ: НЕТ
//            image: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false
//        ),
//    ]
}
