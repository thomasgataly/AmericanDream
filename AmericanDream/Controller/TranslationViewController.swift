//
//  TranslationViewController.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 04/09/2023.
//

import UIKit

struct Country {
    let shortCode:String
    let name:String
    let flag: UIImage

    init(shortCode: String, name: String, flag: UIImage) {
        self.shortCode = shortCode
        self.name = name
        self.flag = flag
    }
}

class TranslationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var targetTextView: UITextView!
    @IBOutlet weak var firstFlag: UIImageView!
    @IBOutlet weak var firstCountry: UILabel!
    @IBOutlet weak var secondFlag: UIImageView!
    @IBOutlet weak var secondCountry: UILabel!

    var translationDirection = [
        Country(shortCode: "fr", name: "Français", flag: UIImage(named: "fr")!),
        Country(shortCode: "en", name: "Anglais", flag: UIImage(named: "us")!)
    ]

    private let translator = Translator(
        url: URL(string: K.translatorApi.endpoint)!,
        session: URLSession(configuration: .default),
        apiKey: K.translatorApi.apiKey
    )

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

    @IBAction func onTranslateButtonPressed(_ sender: UIButton) {
        if sourceTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(title: "OK", message: "Veuillez saisir un texte à traduire")
            return
        }

        startLoading(button: translateButton)
        let source = translationDirection[0].shortCode
        let target = translationDirection[1].shortCode
        translator.translate(text:sourceTextView.text, source: source, target: target) { result in
            DispatchQueue.main.async {
                switch result {
                    case .failure(let error):
                        self.showAlert(title: "OK", message: error.rawValue)
                        self.stopLoading(button: self.translateButton, text: "TRADUIRE")
                    case .success(let translatedText):
                        self.targetTextView.text = translatedText
                        self.stopLoading(button: self.translateButton, text: "TRADUIRE")
                }
            }
        }
    }

    @IBAction func onReverseButtonPressed(_ sender: UIButton) {
        translationDirection.reverse()
        firstFlag.image = translationDirection[0].flag
        firstCountry.text = translationDirection[0].name
        secondFlag.image = translationDirection[1].flag
        secondCountry.text = translationDirection[1].name
        sourceTextView.text = ""
        targetTextView.text = ""
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
