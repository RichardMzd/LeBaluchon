//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 29/07/2022.
//
import Foundation

class TranslationService {
//MARK: Singleton pattern
    static var shared = TranslationService()
    private init() {}
    
//MARK: Properties
    let apiKey = "AIzaSyAJ6HSwVtaEhSx5NFX42X5OZDsYt6-B4Ls"
    static var langSource = "fr"
    static var langTarget = "en"
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
            self.session = session
        }
    
//MARK: Methods

    // Method in order to switch source & target
    func changeLanguage(source: String, target: String) {
        TranslationService.langSource = source
        TranslationService.langTarget = target
        }
    
    func translate(source: String, q: String, target: String, completion: @escaping (String, Translate?) -> Void)  {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "format", value: "text"),]
        
        guard let urlTranslate = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlTranslate) else { return }
        
        task = session.dataTask(with: url)  { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion("l'accès au serveur a échoué", nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion("erreur réseau", nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Translate.self, from: data) else {
                    completion("le statut de la réponse a échoué", nil)
                    return
                }
                let translatedResponse: Translate = responseJSON
                completion("ok", translatedResponse)
            }
        }
        task?.resume()
    }
    
}
