//
//  TranslationViewController.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 04/09/2023.
//

import UIKit

class TranslationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var targetTextView: UITextView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3960784314, green: 0.3058823529, blue: 0.6392156863, alpha: 1).cgColor, #colorLiteral(red: 0.9176470588, green: 0.6862745098, blue: 0.7843137255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        mainView.layer.cornerRadius = 30
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let uiEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        sourceTextView.layer.borderWidth = 0.5
        sourceTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        sourceTextView.layer.cornerRadius = 15
        sourceTextView.textContainerInset = uiEdgeInsets
        targetTextView.layer.borderWidth = 0.5
        targetTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        targetTextView.layer.cornerRadius = 15
        targetTextView.textContainerInset = uiEdgeInsets
    }


    @IBAction func onTranslateButtonPressed(_ sender: Any) {
        if sourceTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert()
            return
        }

        translateButton.configuration?.showsActivityIndicator = true
        Translator.translate(sourceTextView.text) { translatedText in
            if let translatedText = translatedText {
                self.targetTextView.text = translatedText
                self.translateButton.configuration?.showsActivityIndicator = false
            }
        }
    }

    private func showAlert() {
        let alertVC = UIAlertController(
            title: nil,
            message: "Veuillez saisir un texte à traduire",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true)
    }
}

extension TranslationViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return sourceTextView.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
