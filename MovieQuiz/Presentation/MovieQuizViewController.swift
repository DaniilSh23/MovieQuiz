import UIKit

final class MovieQuizViewController: UIViewController {
    // Вью-класс для основного экрана с вопросами квиза
    
    var alertDelegate: AlertPresenterProtocol = AlertPresenter()
//    var correctAnswers = 0
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
    
//    // MARK: - QuestionFactoryDelegate
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        // проверка, что вопрос не nil
//        guard let question = question else {
//            return
//        }
//
//        presenter.currentQuestion = question
//        let viewModel = presenter.convert(model: question)
//        
//        // Оборачиваем метод show, чтобы изменения на экране точно выполнились в главной очереди.
//        DispatchQueue.main.async {
//            [weak self] in self?.show(quiz: viewModel)
//        }
//        show(quiz: viewModel)
//    }
    
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
    
//    func didLoadDataFromServer() {
//        // Метод для выполнения действий в случае успешной загрузки данных по сети
//        
//        self.hideLoadingIndicator()
//        presenter.questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        // Метод для обработки неудачного запроса данных от апи
//    
//        self.showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
//    }
//    
//    private func showNetworkError(message: String) {
//        // Функция, которая отображает алерт с ошибкой загрузки
//        
//        self.hideLoadingIndicator() // скрываем индикатор загрузки
//        
//        // показываем алерт с ошибкой загрузки данных по сети"
//        let alertModel = AlertModel(
//            title: "Что-то пошло не так(",
//            message: "Невозможно загрузить данные",
//            buttonText: "Попробовать еще раз",
//            completion: {[weak self] in
//                guard let self = self else { return }
//                
//                presenter.resetQuestionIndex()
//                // TODO: тут надо дописать логику повторного запроса на получение данных о фильмах по API
//            }
//        )
//        self.alertDelegate.show(alertModel: alertModel)
//    }
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
