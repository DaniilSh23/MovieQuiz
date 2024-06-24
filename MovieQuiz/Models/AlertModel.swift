//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Лада on 27.05.2024.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
