//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Лада on 27.05.2024.
//

import UIKit


protocol AlertPresenterProtocol {
    // Протокол на который подпишется класс алерта
    
    var alertController: UIViewController? { get set }
    func show(alertModel: AlertModel)
}
