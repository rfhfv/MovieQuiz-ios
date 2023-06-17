//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by admin on 04.06.2023.
//

import Foundation
import UIKit

protocol AlertPresenter {
    func show(alertModel: AlertModel)
}

final class AlertPresenterImpl {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
}

extension AlertPresenterImpl: AlertPresenter {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {  _ in
            alertModel.buttonAction()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
        
    }
}

