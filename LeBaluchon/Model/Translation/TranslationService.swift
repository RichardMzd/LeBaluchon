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
    
    
    let apiKey = "AIzaSyAJ6HSwVtaEhSx5NFX42X5OZDsYt6-B4Ls"
    let session = URLSession(configuration: .default)
    var langSource = "fr"
    var langTarget = "en"
    private var task: URLSessionDataTask?
    
    
    func changeLanguage(source: String, target: String) {
        TranslationService.shared.langSource = source
        TranslationService.shared.langTarget = target
        }
    
    func translate(source: String, q: String, target: String, completion: @escaping (Translate?) -> Void)  {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "source", value: langSource),
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "target", value: langTarget),
            URLQueryItem(name: "format", value: "text"),]
        
        guard let urlTranslate = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlTranslate) else { return }
        
        task = session.dataTask(with: url)  { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(nil)
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(Translate.self, from: data)
                    completion(responseJSON)
                } catch {
                    completion(nil)
                    print("Error")
                }
            }
        }
        task?.resume()
    }
}
