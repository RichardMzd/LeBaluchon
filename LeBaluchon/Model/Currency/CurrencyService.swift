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
        
    let apiKey = "6N8X7HSSoNgvDCsE1t2NulVTCw6w934w"
    let session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    var changeSource = "EUR"
    var changeTarget = "USD"
    
    func changeLanguage(source: String, target: String) {
        CurrencyService.shared.changeSource = source
        CurrencyService.shared.changeTarget = target
        }
    
    func getExchange(completion: @escaping (Currency?) -> Void) {
            guard let exchangeUrl = URL(string: "https://api.apilayer.com/fixer/latest?access_key=6N8X7HSSoNgvDCsE1t2NulVTCw6w934w&symbols=USD") else { return }
        
            task?.cancel()
            task = session.dataTask(with: exchangeUrl, completionHandler: { (data, response, error) in
                
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(nil)
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(Currency.self, from: data)
                    completion(responseJSON)
                } catch {
                    completion(nil)
                    print("Error")
                }
            })
            task?.resume()
        }
}

enum NetworkError: Error {
    case noData, noResponse, undecodableData
}

//    func convert(completion: @escaping (Currency?) -> Void)  {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.apilayer.com"
//        urlComponents.path = "/fixer/convert"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "key", value: apiKey),
//            URLQueryItem(name: "from", value: changeSource),
//            URLQueryItem(name: "q", value: q),
//            URLQueryItem(name: "to", value: changeTarget),
//            URLQueryItem(name: "amount", value: "text"),]
//
//        guard let urlTranslate = urlComponents.url?.absoluteString else { return }
//        guard let url = URL(string: urlTranslate) else { return }
//
//        task = session.dataTask(with: url)  { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let data = data, error == nil else {
//                    completion(nil)
//                    return
//                }
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    completion(nil)
//                    return
//                }
//                do {
//                    let responseJSON = try JSONDecoder().decode(Currency.self, from: data)
//                    completion(responseJSON)
//                } catch {
//                    completion(nil)
//                    print("Error")
//                }
//            }
//        }
//        task?.resume()
//    }

