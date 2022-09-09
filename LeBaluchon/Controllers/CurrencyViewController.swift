//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 08/06/2022.
//

import Foundation
import UIKit
import Lottie

class CurrencyViewController: UIViewController, UITextViewDelegate {
    
    // MARK: @IBOUTLETS & PROPRETIES
    @IBOutlet private weak var animationIcon: AnimationView!
    @IBOutlet weak var upperTextView: UITextView!
    @IBOutlet weak var lowerTextView: UITextView!
    @IBOutlet weak var firstCurrencyButton: UIButton!
    @IBOutlet weak var secondCurrencyButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    let placeholder = "Saisissez le montant"
    let currencies : [Currencies]? = [.euro, .dollar]
    var sourceKeys : String = Currencies.euro.currenciesKeys
    var targetKeys : String = Currencies.dollar.currenciesKeys
    var sourceNames: String = Currencies.euro.currenciesNames
    var targetNames: String = Currencies.dollar.currenciesNames
    var baseCurrency: Double = 0.00
    var targetCurrency: Double = 0.00
    var baseValue: Double = 0.00
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animationIcon.animation = Animation.named("Lottie_Currency")
        self.animationIcon.loopMode = .loop
        self.animationIcon.contentMode = .scaleAspectFit
        
        self.currencyPickerView.isHidden = true
        self.currencyPickerView.delegate = self
        self.currencyPickerView.dataSource = self
        
        self.swapButton.layer.cornerRadius = swapButton.bounds.size.height / 2
        self.swapButton.clipsToBounds = false
        
        self.firstCurrencyButton.setTitle(sourceNames, for: .normal)
        self.firstCurrencyButton.setTitleColor(.black, for: .normal)
        self.secondCurrencyButton.setTitle(targetNames, for: .normal)
        self.secondCurrencyButton.setTitleColor(.black, for: .normal)
        
        self.upperTextView.delegate = self
        self.upperTextView.text = placeholder
        self.upperTextView.textColor = .lightGray
        
        self.setupTextView(textView: upperTextView)
        self.setupTextView(textView: lowerTextView)
        
        self.textViewDidBeginEditing(upperTextView)
        self.textViewDidEndEditing(upperTextView)
        self.textViewDelegate()
        
        self.updateStyle()
        self.setButtonStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animationIcon.play(completion: nil)
        textViewDelegate()
        textViewDidBeginEditing(upperTextView)
        textViewDidEndEditing(upperTextView)
    }
    
    // MARK: UI Methods settings
    func setButtonStyle() {
        let origImage = UIImage(named: "currency_exchange_symbol")
        let switchImage = UIImage(named: "swap")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let imageButton = switchImage?.withRenderingMode(.alwaysTemplate)
        
        self.swapButton.setImage(imageButton, for: .normal)
        self.swapButton.tintColor = .red
        
        self.convertButton.setTitle("Convertir", for: .normal)
        self.convertButton.setTitleColor(.black, for: .normal)
        self.convertButton.setImage(tintedImage, for: .normal)
        self.convertButton.tintColor = .blue
        self.convertButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.convertButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        self.convertButton.titleLabel?.font = .systemFont(ofSize: 25)
    }
    
    func updateStyle() {
        self.setupButton(button: firstCurrencyButton, color: .red, width: 1)
        self.setupButton(button: secondCurrencyButton, color: .red, width: 1)
        self.setupButton(button: swapButton, color: .red, width: 1)
        self.setupButton(button: convertButton, color: .blue, width: 1)
    }
    
    func setupButton(button: UIButton, color: UIColor, width: CGFloat) {
        let cgColor: CGColor = color.cgColor
        
        button.layer.borderColor = cgColor
        button.layer.borderWidth = width
        button.layer.cornerRadius = button.bounds.size.height / 2.14
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.backgroundColor = .white
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3.0
    }
    
    func setupTextView(textView: UITextView) {
        textView.layer.cornerRadius = 16
        textView.layer.shadowColor = UIColor.darkGray.cgColor
        textView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        textView.layer.shadowOpacity = 0.4
        textView.layer.shadowRadius = 3.0
    }
    
    // MARK: @IBACTIONS
    
    // Left pickerView appear while clicking on it
    @IBAction func selectFirstCurren(_ sender: Any) {
        getConversion(pickerView: currencyPickerView)
        if currencyPickerView.isHidden {
            self.currencyPickerView.isHidden = false
            self.upperTextView.isHidden = true
            self.lowerTextView.isHidden = true
            self.firstCurrencyButton.isHidden = true
            self.secondCurrencyButton.isHidden = true
            self.swapButton.isHidden = true
        } else {
            self.currencyPickerView.isHidden = true
        }
    }
    
    // Right pickerView appear while clicking on it
    @IBAction func selectSecondCurren(_ sender: Any) {
        getConversion(pickerView: currencyPickerView)
        if currencyPickerView.isHidden {
            self.currencyPickerView.isHidden = false
            self.upperTextView.isHidden = true
            self.lowerTextView.isHidden = true
            self.firstCurrencyButton.isHidden = true
            self.secondCurrencyButton.isHidden = true
            self.swapButton.isHidden = true
        } else {
            self.currencyPickerView.isHidden = true
        }
    }
    
    // IBAction to switch the currencies
    @IBAction func swapCurrency(_ sender: UIButton) {
        sender.isSelected = !swapButton.isSelected
        guard swapButton.isSelected == false else {
            clearText()
            CurrencyService.shared.changeCurrency(source: sourceKeys, target: targetKeys)
            self.firstCurrencyButton.setTitle(targetNames, for: .normal)
            self.secondCurrencyButton.setTitle(sourceNames, for: .normal)
            return
        }
        clearText()
        TranslationService.shared.changeLanguage(source: targetKeys, target: sourceKeys)
        self.firstCurrencyButton.setTitle(sourceNames, for: .normal)
        self.secondCurrencyButton.setTitle(targetNames, for: .normal)
    }
    
    // IBAction to get the result
    @IBAction func getResult(_ sender: UIButton) {
        getRatesResult()
    }
    
    // MARK: Methods
    
    // Method which allows to give the conversion according to the swapButtton
    private func getRatesResult() {
        if swapButton.isSelected {
            CurrencyService.shared.getExchange(base: targetKeys, q: upperTextView.text, target: sourceKeys) { (true, result) in
                guard let trans = result else { return }
                self.updateUSD(textChange: trans)
                self.textViewEmpty(textview: self.upperTextView)
            }
        } else {
            CurrencyService.shared.getExchange(base: sourceKeys, q: upperTextView.text, target: targetKeys) { (true, result) in
                guard let trans = result else { return }
                self.updateEUR(textChange: trans)
                self.textViewEmpty(textview: self.upperTextView)
            }
        }
    }
    
    // Method that converts the value from euros to dollars
    private func updateUSD(textChange: Currency) {
        baseCurrency = Double(textChange.rates.eur)
        targetCurrency = textChange.rates.usd
        baseValue = Double(upperTextView.text!) ?? 1.00
        
        var conversion = (baseValue * targetCurrency / baseCurrency)
        conversion = round(conversion * 100) / 100
        
        if upperTextView.text != "" {
            lowerTextView.text = String(conversion)
        } else {
            var USDValue = textChange.rates.usd
            USDValue = round(USDValue * 100) / 100
            lowerTextView.text = String(USDValue)
        }
    }
    
    // Method that converts the value from dollars to euros
    private func updateEUR(textChange: Currency) {
        baseCurrency = textChange.rates.usd
        targetCurrency = Double(textChange.rates.eur)
        baseValue = Double(upperTextView.text!) ?? 1.00
        
        var conversion = (baseValue * targetCurrency / baseCurrency)
        conversion = round(conversion * 100) / 100
        
        if upperTextView.text != "" {
            lowerTextView.text = String(conversion)
        } else {
            var USDValue = textChange.rates.eur
            USDValue = Int(USDValue * 100) / 100
            lowerTextView.text = String(USDValue)
        }
    }
    
    private func clearText() {
        lowerTextView.text = ""
        upperTextView.text = ""
    }
    
    // Method that allows not to convert two same currencies
    func getConversion(pickerView: UIPickerView) {
        let sourceRow = pickerView.selectedRow(inComponent: 0)
        let targetRow = pickerView.selectedRow(inComponent: 1)
        
        guard let source = currencies?[sourceRow].currenciesKeys else { return }
        guard let target = currencies?[targetRow].currenciesKeys else { return }
        
        if source == target {
            alertWithValueError(value: "Erreur",message: "Tu ne peux pas convertir la meme devise.")
        } else {
            getRatesResult()
        }
    }
}
