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

    private let changeRateCalculator = ChangeRateCalculator()

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
        if let inputRawValue = inputAmount.text {
            if let inputValue = Float(inputRawValue) {
                self.calculateButton.configuration?.showsActivityIndicator = true
                changeRateCalculator.calculate(amount: inputValue) { result in
                    if let result = result {
                        let resultAmount = String(format: "%.2f", result)
                        self.resultLabel.text = "$\(resultAmount)"
                        self.calculateButton.configuration?.showsActivityIndicator = false
                    }
                }
            } else {
                showAlert()
            }
        }
    }

    private func showAlert() {
        let alertVC = UIAlertController(
            title: nil,
            message: "Veuillez saisir un montant",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true)
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
