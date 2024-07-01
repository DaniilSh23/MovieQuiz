//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Лада on 28.06.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuestion(quiz question: MovieQuiz.QuizStepViewModel) { }
    
    var alertDelegate: (any MovieQuiz.AlertPresenterProtocol)?
    
    func showAnswerResult(isCorrect: Bool) { }
    func showNetworkError(message: String) { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
}

final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")

    }

}
