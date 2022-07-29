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
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherAnimationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
