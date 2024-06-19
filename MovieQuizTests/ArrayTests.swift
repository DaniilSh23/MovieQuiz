//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Лада on 19.06.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz  // импортируем наше приложение квиза для тестирования


class ArrayTests: XCTestCase {
    // Класс для тестов расширения массива из директории Helpers
    
    func testGetValueOutOfRange() throws {
    // тест на взятие элемента по неправильному индексу
       
        // Given
        let array = [1, 1, 2, 3, 5]
            
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
    
    func testGetValueInRange() throws {
    // тест на успешное взятие элемента по индексу
    
        // Given
        let array = [1, 1, 2, 3, 5]     // Дан массив чисел
        
        // When
        let value = array[safe: 2]  // Когда берем элемент по индексу 2
               
        // Then
        XCTAssertNotNil(value)  // Проверяем, что элемент не nil
        XCTAssertEqual(value, 2) // И равен 2 (3 элемент массива)
    }
}
