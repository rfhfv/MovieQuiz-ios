//
//  MovieQuizUITestsNew.swift
//  MovieQuizUITestsNew
//
//  Created by admin on 25.06.2023.
//

import XCTest

final class MovieQuizUITestsNew: XCTestCase {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
       
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
           sleep(3)

           let indexLabel = app.staticTexts["Index"]

           let firstPoster = app.images["Poster"]
           let firstPosterData = firstPoster.screenshot().pngRepresentation

           app.buttons["Yes"].tap()
           sleep(3)

           let secondPoster = app.images["Poster"]
           let secondPosterData = secondPoster.screenshot().pngRepresentation

           XCTAssertNotEqual(firstPosterData, secondPosterData)
           XCTAssertEqual(indexLabel.label, "2/10")
       }
    
    func testNoButton() {
        sleep(3)

        let indexLabel = app.staticTexts["Index"]

        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }

 
    func testGameFinish() {
        sleep(4)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(4)
        }
        
        sleep(4)
        let alert = app.alerts["GameResults"]
       
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    
    func testAlertDismiss() {
        sleep(4)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(4)
        }
        sleep(4)
        let alert = app.alerts["GameResults"]
        alert.buttons.firstMatch.tap()

        sleep(4)

        let indexLabel = app.staticTexts["Index"]

        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
