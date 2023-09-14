//
//  WeatherViewController.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 04/09/2023.
//

import UIKit

final class WeatherViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainCityName: UILabel!
    @IBOutlet weak var mainCityWeatherIcon: UIImageView!
    @IBOutlet weak var mainCityTemperature: UILabel!
    @IBOutlet weak var mainCityWeatherDescription: UILabel!

    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var cityWeatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityWeatherDescription: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let cityName = cityInput.text else {
            showAlert()
            return
        }
        searchCityWeather(cityName: cityName)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0, green: 0, blue: 0.2745098039, alpha: 1).cgColor, #colorLiteral(red: 0.1098039216, green: 0.7098039216, blue: 0.8784313725, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        mainView.layer.cornerRadius = 30
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        cityInput.borderStyle = UITextField.BorderStyle.roundedRect
        searchMainCityWeather()
    }

    private func searchMainCityWeather() {
        startLoading()
        WeatherService.getWeather(cityName: "New York") { description, icon, temperature in
            self.mainCityName.text = "New York"
            self.mainCityWeatherDescription.text = description.capitalizedSentence
            self.mainCityTemperature.text = "\(String(format: "%.0f",temperature)) °C"
            self.mainCityWeatherIcon.load(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
            self.stopLoading()
        }
    }

    private func searchCityWeather(cityName:String) {
        startLoading()
        WeatherService.getWeather(cityName: cityName) { description, icon, temperature in
            self.cityName.text = cityName
            self.cityWeatherDescription.text = description.capitalizedSentence
            self.cityTemperature.text = "\(String(format: "%.0f",temperature)) °C"
            self.cityWeatherIcon.load(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
            self.stopLoading()
        }
    }

    private func startLoading() {
        searchButton.titleLabel?.text = ""
        searchButton.configuration?.showsActivityIndicator = true
    }

    private func stopLoading() {
        searchButton.titleLabel?.text = "OK"
        searchButton.configuration?.showsActivityIndicator = false
    }

    private func showAlert() {
        let alertVC = UIAlertController(
            title: nil,
            message: "Veuillez saisir le nom d'une ville",
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true)
    }
}
