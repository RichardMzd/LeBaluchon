//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 08/06/2022.
//

import Foundation
import UIKit
import Lottie

class WeatherViewController: UIViewController {
    
// MARK: @IBOUTLETS & PROPRETIES
    @IBOutlet weak var weatherAnimationView: AnimationView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            setTextField(text: "Chercher une ville", textField: searchTextField)
        }
    }
    let gradientLayer = CAGradientLayer()
    let searchImage = UIImage(named: "search")
    
// MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        fecthWeatherDataSearch(city: "Paris")
        
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.clipsToBounds = true
        searchTextField.layer.borderWidth = 0.5
        
        searchButton.layer.cornerRadius = searchButton.frame.size.width/2
        searchButton.layer.borderWidth = 0.5
        searchButton.setImage(searchImage, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
        fecthWeatherDataSearch(city: "Paris")
    }
  
// MARK: UI Methods settings
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setTextField(text: String, textField: UITextField) {
            let blackPlaceholderText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                textField.attributedPlaceholder = blackPlaceholderText
        }
    
// MARK: Methods
    
    // Method that display the icon animation according to the weather and location
    func displayWeatherAnimation(weatherInfo: MainWeather) {
        self.weatherAnimationView.animation = Animation.named(weatherInfo.upDatePic(image: weatherInfo.weather?.first?.icon ?? "Nopic"))
        self.weatherAnimationView.loopMode = .loop
        self.weatherAnimationView.contentMode = .scaleAspectFit
        self.weatherAnimationView.play()
    }
    // Method which gives city, country, temperature, weather conditions and sunrise/sunset time informations
    func fecthWeatherDataSearch(city: String) {
        WeatherService.shared.getWeather(city: city) { (true, result) in
                switch result {
                case .some(let weatherInfo):
                    DispatchQueue.main.async {
                        self.cityLabel.text = weatherInfo.name ?? "Madrid"
                        self.countryLabel.text = weatherInfo.sys?.country  ?? "Japan"
                        self.temperatureLabel.text = "\(Int(weatherInfo.main?.temp ?? 22)/10) °C"
                        self.weatherConditionLabel.text = weatherInfo.weather?.first?.description.capitalizeFirstLetter ?? "Couvert"
                        self.displayWeatherAnimation(weatherInfo: weatherInfo)
                        self.sunriseLabel.text = "🌅 : \(weatherInfo.timeStamp(time: weatherInfo.sys?.sunrise ?? 0))"
                        self.sunsetLabel.text = "🌇 : \(weatherInfo.timeStamp(time: weatherInfo.sys?.sunset ?? 0))"
                    }
                case .none:
                    DispatchQueue.main.async {
                        let description = "\nSaisis un nom de ville correct."
                        print(description)
                    }
                }
            }
        }
    
    // Method that check if the textField is empty
    func textFieldEmpty(textfield: UITextField) {
        if textfield.text?.isEmpty == true {
            self.alertWithValueError(value: "Erreur", message: "Veuilez saisir une ville !")
        }
    }
    
    // IBAction
    @IBAction func searchCity(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        fecthWeatherDataSearch(city: searchTextField.text ?? "Tokyo")
        textFieldEmpty(textfield: searchTextField)
    }
    
}
