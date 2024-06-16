//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Лада on 16.06.2024.
//

import Foundation


protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
