//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 29/07/2022.
//

import Foundation

class TranslationService {
    static var shared = TranslationService()
    private init() {}
    static var test = ""
    private static let quoteUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?q=\(TranslationService.test)&target=en&source=fr&key=AIzaSyAJ6HSwVtaEhSx5NFX42X5OZDsYt6-B4Ls&formatText=text")!

    private var task: URLSessionDataTask?
    
    func getTranslation(callback: @escaping (Bool, Translate?) -> Void) {
        var request = URLRequest(url: TranslationService.quoteUrl)
        request.httpMethod = "GET"
                
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(Translate.self, from: data)
                        callback(true, responseJSON)
                } catch {
                    callback(false, nil)
                    print("Error")
                }
            }
        }
        task?.resume()
    }
    
    func getUserText(textEnter: String) {
        TranslationService.test = textEnter
    }
}
