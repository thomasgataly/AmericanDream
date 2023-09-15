//
//  AbstractController.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 15/09/2023.
//

import UIKit

class AbstractController:UIViewController {
    func showAlert(title:String, message:String) {
        let alertVC = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: title, style: .cancel, handler: nil))
        self.present(alertVC, animated: true)
    }

    func startLoading(button:UIButton) {
        button.setTitle("", for: .normal)
        button.configuration?.showsActivityIndicator = true
    }

    func stopLoading(button:UIButton, text:String) {
        button.setTitle(text, for: .normal)
        button.configuration?.showsActivityIndicator = false
    }
}
