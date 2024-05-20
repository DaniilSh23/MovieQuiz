import UIKit

final class MovieQuizViewController: UIViewController {
    // Вью-класс для основного экрана с вопросами квиза
    
    @IBOutlet weak private var questionTitleLabel: UILabel!
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionText: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка скругления рамки
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 0 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        // Установка шрифтов для лейблов, так как они не отображаются в стори борде
        questionTitleLabel.font = UIFont(name: "YS Display-Medium.ttf", size: 20)
        indexLabel.font = UIFont(name: "YS Display-Medium.ttf", size: 20)
        questionText.font = UIFont(name: "YS Display-Bold.ttf", size: 23)
        
        // Установка кнопкам скругленных краев, так как настройка в стори борде, взятая из урока, ничего не меняет
        noButton.layer.cornerRadius = 15
        noButton.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        yesButton.layer.cornerRadius = 15
        yesButton.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        
        
        let quizQuestion = convert(model: questions[currentQuestionIndex])
        show(quizQuestion: quizQuestion)
    }
    
    private func clickButtonAction(_ userAnswer: Bool){
        // Функция с логикой нажатия на кнопку Да или Нет
        
        // Проверяем правильность ответа пользователя
        let correctQuizAnswer = questions[currentQuestionIndex].correctAnswer
        if userAnswer == correctQuizAnswer {
            correctAnswers += 1
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // через 1 секунду показываем следующий вопрос
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        // приватный метод, который содержит логику перехода в один из сценариев (показать следующий вопрос/показать результаты квиза)
        
        if currentQuestionIndex == questions.count - 1 {    // состояние "Результат квиза"
            currentQuestionIndex = 0
            showQuizResult()
        } else {    // показываем следующий вопрос
            currentQuestionIndex += 1
            let quizQuestion = convert(model: questions[currentQuestionIndex])
            show(quizQuestion: quizQuestion)
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
        
        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: "Этот раунд окончен!", // заголовок всплывающего окна
            message: "Ваш результат: \(correctAnswers)/10", // текст во всплывающем окне
            preferredStyle: .alert
        ) // preferredStyle может быть .alert или .actionSheet
        
        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            correctAnswers = 0
            let quizQuestion = self.convert(model: questions[currentQuestionIndex])
            self.show(quizQuestion: quizQuestion)
        }
        
        // добавляем в алерт кнопку
        alert.addAction(action)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
        
        let questionStep = QuizStepViewModel( // Создаём константу questionStep и вызываем конструктор QuizStepViewModel
            image: UIImage(named: model.image) ?? UIImage(), // Инициализируем картинку с помощью конструктора UIImage(named: ); если картинки с таким названием не найдётся, подставляем пустую
            question: model.text, // Просто забираем уже готовый вопрос из мокового вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // Высчитываем номер вопроса с помощью переменной текущего вопроса currentQuestionIndex и массива со списком вопросов questions
        return questionStep
    }
    
    private func show(quizQuestion question: QuizStepViewModel) {
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
}



private struct QuizStepViewModel {
    // Структура - вью модель для состояния "Вопрос показан"
    
    // картинка с афишей фильма с типом UIImage
    let image: UIImage
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}


private struct QuizQuestion {
    // Структура, отражающая данные, необходимые для экрана с вопросом квиза
    
    let image: String
    let text: String
    let correctAnswer: Bool
}


// переменная с индексом текущего вопроса, начальное значение 0
// (по этому индексу будем искать вопрос в массиве)
private var currentQuestionIndex = 0

// переменная со счётчиком правильных ответов
private var correctAnswers = 0

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
