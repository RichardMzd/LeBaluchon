//
//  Weather.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 26/08/2022.
//

import Foundation
import Lottie

struct MainWeather: Decodable {
    
    let sys: Sys?
    let name: String?
    let main: Main?
    let weather: [Weather]?
    
    struct Weather: Decodable {
        let id: Int?
        let main: String?
        let description: String
        let icon: String?
    }
    
    struct Main: Decodable {
        let temp: Double?

        enum CodingKeys : String, CodingKey {
            case temp
        }
    }
    
    struct Sys: Decodable {
        let country: String?
        let sunrise: Int?
        let sunset: Int?
        
        enum CodingKeys: String, CodingKey {
            case country
            case sunrise
            case sunset
        }
    }
    
    //MARK: METHODS FOR WEATHER VIEW
    func upDatePic(image: String) -> String {
        if image == "", image != self.weather?.first?.icon {
            return "Nopic"
        } else {
            return image
        }
    }
    
    func timeStamp(time: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EE d MMMM HH:mm"
        let dateString = formatter.string(from: date)
        return String(dateString).capitalizeFirstLetter
    }
}

extension String {
       var capitalizeFirstLetter:String {
            return self.prefix(1).capitalized + dropFirst()
       }
  }
