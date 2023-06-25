//
//  BestGame.swift
//  MovieQuiz
//
//  Created by admin on 04.06.2023.
//
//
import Foundation

struct BestGame: Codable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: BestGame) -> Bool {
        correct > another.correct
    }
}

