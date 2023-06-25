//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by admin on 24.06.2023.
//

import Foundation

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
