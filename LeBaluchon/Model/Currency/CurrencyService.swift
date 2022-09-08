//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 12/08/2022.
//

import Foundation

class CurrencyService {
    static var shared = CurrencyService()
    private init() {}
    
    private static let urlRates = URL(string: "https://api.apilayer.com/exchangerates_data/latest?apikey=IKKzslSMVxgd8AUTUKA46kUWSRutPk7d")!
    
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
            self.session = session
        }
    
    var changeSource = Rates.CodingKeys.eur.rawValue
    var changeTarget = Rates.CodingKeys.usd.rawValue
    
    func changeCurrency(source: String, target: String) {
        CurrencyService.shared.changeSource = source
        CurrencyService.shared.changeTarget = target
    }
    
    func getExchange(base: String, q: String, target: String ,completion: @escaping (Bool, Currency?) -> Void) {
        var urlComponents = URLComponents()
        var request = URLRequest(url: CurrencyService.urlRates)
        request.httpMethod = "Get"

        urlComponents.queryItems = [
            URLQueryItem(name: "source", value: base),
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "format", value: "text"),]
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    completion(false, nil)
                    return
                }
                let currencyResponse: Currency = responseJSON
                completion(true, currencyResponse)
            }
        }
        task?.resume()
    }
}

enum NetworkError: Error {
    case noData, noResponse, undecodableData
}


