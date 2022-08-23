//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 12/08/2022.
//

import Foundation

class CurrencyService {
    static var shared = CurrencyService()
//    private init() {}
    
    private static let urlRates = URL(string: "http://api.apilayer.com/fixer/latest?access_key=gk5j5CYzPEJnrtIV58NWQAmA3TOxHWW3")!

    
    private var session = URLSession(configuration: .default)
    init(session: URLSession = .shared) {
            self.session = session
        }
    
    private var task: URLSessionDataTask?
    
    var changeSource = "EUR"
    var changeTarget = "USD"
    
    func changeLanguage(source: String, target: String) {
        CurrencyService.shared.changeSource = source
        CurrencyService.shared.changeTarget = target
    }
    
    func getExchange(completion: @escaping (_ result: Currency?) -> Void) {
        var request = URLRequest(url: CurrencyService.urlRates)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.none)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.none)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    completion(.none)
                    return
                }
                completion(.some(responseJSON))
                print(responseJSON)
            }
        }
        task?.resume()
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

