//
//  MessageAlerts.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 05/09/2022.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK: Alert methods    
    //method to detect error in API Call request
    func alertServerAccess(error: String) {
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // alert when user wants to use the same language to translate as the first choice
    func alertSameLanguage(message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //alert when the value is incorrect and has a specific message
    func alertWithValueError(value: String, message : String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
