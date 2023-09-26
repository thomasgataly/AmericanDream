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
            showAlert(title: K.common.ok, message: K.weather.strings.requestCity)
            return
        }
        searchCityWeather(cityName: cityName)
    }

    private let weatherService = WeatherService(urlGenerator: WeatherUrlGenerator(),session: URLSession(configuration: .default))

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
        startLoading(button: searchButton)
        weatherService.getWeather(cityName: K.weather.strings.mainCity) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: K.common.ok, message: error.rawValue)
                    self.stopLoading(button: self.searchButton, text: K.common.ok)
                case.success(let weather):
                    self.mainCityName.text = K.weather.strings.mainCity
                    self.mainCityWeatherDescription.text = weather.weather[0].description.capitalizedSentence
                    self.mainCityTemperature.text = "\(String(format: "%.0f", weather.temperature.temp)) °C"
                    self.mainCityWeatherIcon.load(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")!)
                    self.stopLoading(button: self.searchButton, text: K.common.ok)
                }
            }
        }
    }

    private func searchCityWeather(cityName: String) {
        startLoading(button: searchButton)
        weatherService.getWeather(cityName: cityName) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: K.common.ok, message: error.rawValue)
                    self.stopLoading(button: self.searchButton, text: K.common.ok)
                case.success(let weather):
                    self.cityName.text = cityName.capitalizedSentence
                    self.cityWeatherDescription.text = weather.weather[0].description.capitalizedSentence
                    self.cityTemperature.text = "\(String(format: "%.0f", weather.temperature.temp)) °C"
                    self.cityWeatherIcon.load(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")!)
                    self.stopLoading(button: self.searchButton, text: K.common.ok)
                    self.cityInput.text?.removeAll()
                }
            }
        }
    }
}
