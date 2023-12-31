//
//  ChangeRateViewController.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 04/09/2023.
//

import UIKit

class ChangeRateViewController: UIViewController {

    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!

    private let changeRateCalculator = ChangeRateService(
        urlGenerator: ChangeRateUrlGenerator(),
        session: URLSession(configuration: .default),
        cache: ChangeRateCache()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        inputAmount.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.937254902, green: 0.4392156863, blue: 0.6078431373, alpha: 1).cgColor, #colorLiteral(red: 0.9803921569, green: 0.5764705882, blue: 0.4470588235, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        mainView.layer.cornerRadius = 30
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        inputAmount.borderStyle = UITextField.BorderStyle.roundedRect
    }

    @IBAction func calculateChangeRate(_ sender: UIButton) {
        guard let inputRawValue = inputAmount.text, let inputValue = Double(inputRawValue) else {
            showAlert(title: K.common.ok, message: K.changeRate.strings.requestAmount)
            return
        }

        startLoading(button: calculateButton)
        changeRateCalculator.calculate(amount: inputValue) { [weak self] result in
            guard let self else { return }
            switch result {
                case .failure(let error):
                self.showAlert(title:K.common.ok, message: error.rawValue)
                case .success(let result):
                    let resultAmount = String(format: "%.2f", result)
                    self.resultLabel.text = "$\(resultAmount)"
                self.stopLoading(button: self.calculateButton, text: K.changeRate.strings.cta)
            }
        }
    }
}

extension ChangeRateViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return inputAmount.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
