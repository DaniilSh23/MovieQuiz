import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // Вью-класс для основного экрана с вопросами квиза
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertDelegate: AlertPresenterProtocol = AlertPresenter()
    private var correctAnswers = 0
    private var statisticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()
    
    @IBOutlet weak private var questionTitleLabel: UILabel!
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionText: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var yesButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка скругления рамки
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 0 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        // Установка шрифтов для лейблов и кнопок, так как они не отображаются в стори борде
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionText.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        // Установка кнопкам скругленных краев, так как настройка в стори борде, взятая из урока, ничего не меняет
        noButton.layer.cornerRadius = 15
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.layer.cornerRadius = 15
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        // Делегат алерта
        let alertDelegate = AlertPresenter()
        alertDelegate.alertController = self
        self.alertDelegate = alertDelegate
        
        // Делегат фабрики вопросов
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)  // Создаём экземпляр фабрики для ее настройки
        
        statisticService = StatisticService()
        
        showLoadingIndicator()
        self.questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        // Оборачиваем метод show, чтобы изменения на экране точно выполнились в главной очереди.
        DispatchQueue.main.async {
            [weak self] in self?.show(quiz: viewModel)
        }
        show(quiz: viewModel)
    }
    
    private func clickButtonAction(_ userAnswer: Bool){
        // Функция с логикой нажатия на кнопку Да или Нет
        
        guard let thisQuestion = currentQuestion else {return}
        
        // Проверяем правильность ответа пользователя
        if userAnswer == thisQuestion.correctAnswer {
            correctAnswers += 1
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // через 1 секунду показываем следующий вопрос
            
            guard let self = self else { return } // разворачиваем слабую ссылку
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        // приватный метод, который содержит логику перехода в один из сценариев (показать следующий вопрос/показать результаты квиза)
        
        if presenter.isLastQuestion() {    // состояние "Результат квиза"
            presenter.resetQuestionIndex()
            showQuizResult()
        } else {    // показываем следующий вопрос
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        // приватный метод, который меняет цвет рамки
        // принимает на вход булевое значение и ничего не возвращает
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку красной/зеленой в зависимости от правильности ответа
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    }
    
    private func showQuizResult() {
        // Метод для показа результатов квиза
        
        statisticService!.store(correct: correctAnswers, total: presenter.questionsAmount)
        
        // Форматируем текст для алерта
        let text = """
        Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
        Количество сыгранных квизов: \(statisticService!.gamesCount)
        Рекорд: \(statisticService!.bestGame.correct)/\(statisticService!.bestGame.total) (\(statisticService!.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%"
        """
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз",
            completion: {[weak self] in
                self?.presenter.resetQuestionIndex()
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            })
        self.alertDelegate.show(alertModel: alertModel)
        correctAnswers = 0
    }
    
    private func show(quiz question: QuizStepViewModel) {
        // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
        
        // Накидываем контент на экран
        imageView.image = question.image
        questionText.text = question.question
        indexLabel.text = question.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // Действие по нажатию на кнопку Нет
        clickButtonAction(false)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // Действие по нажатию на кнопку Да
        clickButtonAction(true)
    }
    
    private func showLoadingIndicator() {
        // Функция для отображения индикатора загрузки
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        // Функция для скрытия индикатора загрузки
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        // Функция, которая отображает алерт с ошибкой загрузки
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        // показываем алерт с ошибкой загрузки данных по сети"
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: {[weak self] in
                guard let self = self else { return }
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                // TODO: тут надо дописать логику повторного запроса на получение данных о фильмах по API
            }
        )
        self.alertDelegate.show(alertModel: alertModel)
        correctAnswers = 0
    }
    
    func didLoadDataFromServer() {
        // Метод для выполнения действий в случае успешной загрузки данных по сети
        
        hideLoadingIndicator()
        self.questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        // Метод для обработки неудачного запроса данных от апи
    
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
}



/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
