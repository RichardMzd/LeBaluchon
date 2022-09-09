//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 26/08/2022.
//
import Foundation

class WeatherService {
//MARK: Singleton pattern
    static var shared = WeatherService()
    private init() {}
    
//MARK: Properties
    let apiKey = "04015d712e38f8bbd9e79697027ccbde"
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
// MARK: Methods
    func getWeather(city: String, completion: @escaping (Bool, MainWeather?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "unit", value: "metric"),
            URLQueryItem(name: "lang", value: "fr")]
        
        guard let urlWeather = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlWeather) else { return }
        
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(false, nil)
                    return
                }
                print("Data OK")
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(false, nil)
                    return
                }
                print("Response status OK")
                guard let responseJSON = try? JSONDecoder().decode(MainWeather.self, from: data) else {
                    completion(false, nil)
                    return
                }
                print("JSON OK")
                let searchWheather: MainWeather = responseJSON
                completion(true, searchWheather)
            }
        }
        task?.resume()
    }
}
