import UIKit

final class MovieQuizViewController: UIViewController {
    // Вью-класс для основного экрана с вопросами квиза
    
    var alertDelegate: AlertPresenterProtocol = AlertPresenter()
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
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: presenter)  // Создаём экземпляр фабрики для ее настройки
        
        presenter.statisticService = StatisticService()
        
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        
        presenter.viewController = self
    }
    
    func showAnswerResult(isCorrect: Bool) {
        // приватный метод, который меняет цвет рамки
        // принимает на вход булевое значение и ничего не возвращает
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку красной/зеленой в зависимости от правильности ответа
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    }
    
    func showQuestion(quiz question: QuizStepViewModel) {
        // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает

        // Накидываем контент на экран
        imageView.image = question.image
        questionText.text = question.question
        indexLabel.text = question.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // Действие по нажатию на кнопку Нет
        presenter.clickButtonAction(false)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // Действие по нажатию на кнопку Да
        presenter.clickButtonAction(true)
    }
    
    func showLoadingIndicator() {
        // Функция для отображения индикатора загрузки
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        // Функция для скрытия индикатора загрузки
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
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
