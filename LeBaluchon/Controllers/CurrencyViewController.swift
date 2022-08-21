//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 08/06/2022.
//

import Foundation
import UIKit
import Lottie

class CurrencyViewController: UIViewController {
    
    @IBOutlet private weak var animationIcon: AnimationView!
    @IBOutlet private weak var upperTextView: UITextView!
    @IBOutlet private weak var lowerTextView: UITextView!
    @IBOutlet private weak var firstCurrencyButton: UIButton!
    @IBOutlet private weak var secondCurrencyButton: UIButton!
    @IBOutlet private weak var convertButton: UIButton!
    @IBOutlet private weak var swapButton: UIButton!
    @IBOutlet private weak var currencyPickerView: UIPickerView!
    
    let currencies : [Currencies]? = [.euro, .dollar]
    var sourceKeys : String = Currencies.euro.currenciesKeys
    var targetKeys : String = Currencies.dollar.currenciesKeys
    var sourceNames: String = Currencies.euro.currenciesNames
    var targetNames: String = Currencies.dollar.currenciesNames
    
    let placeholder = "Saisissez le montant"
    
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
    }
    
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
    
    @IBAction func selectFirstCurren(_ sender: Any) {
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
    
    @IBAction func selectSecondCurren(_ sender: Any) {
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
    
    @IBAction func swapLanguage(_ sender: Any) {

    }
    
    @IBAction func convertResult() {
        CurrencyService.shared.getExchange { result in
            guard let convert = result else {
                return
            }
            self.update(textChange: convert)
        }
    }
    
    private func update(textChange: Currency) {
        guard let convert = textChange.base else {
            lowerTextView.text = nil
            return
        }
        lowerTextView.text = Rates.CodingKeys.usd.stringValue
    }
    
    private func clearText() {
        lowerTextView.text = ""
        upperTextView.text = ""
    }

    func getConversion(pickerView: UIPickerView) {
        let sourceRow = pickerView.selectedRow(inComponent: 0)
        let targetRow = pickerView.selectedRow(inComponent: 1)
        
        guard let source = currencies?[sourceRow].currenciesKeys else { return }
        guard let target = currencies?[targetRow].currenciesKeys else { return }
        
        if source == target {
            print("done")
            //            self.alertSameLanguage()
        } else {
            convertResult()
            //            fetchDataTranslation(source: source, q: upperTextView.text ?? "no Text", target: target)
        }
    }
}

extension CurrencyViewController: UITextViewDelegate {
    func textViewDelegate() {
        self.upperTextView.delegate = self
        self.upperTextView.text = placeholder
        self.upperTextView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        } else {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencies?.count ?? 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currencies?[row].currenciesNames
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choiceOne = pickerView.selectedRow(inComponent: 0)
        let choiceTwo = pickerView.selectedRow(inComponent: 1)
        
        sourceKeys = currencies?[choiceOne].currenciesKeys ?? ""
        targetKeys = currencies?[choiceTwo].currenciesKeys ?? ""

        self.firstCurrencyButton.setTitle(currencies?[choiceOne].currenciesNames, for: .normal)
        self.firstCurrencyButton.setTitleColor(.black, for: .normal)
        self.secondCurrencyButton.setTitle(currencies?[choiceTwo].currenciesNames, for: .normal)
        self.secondCurrencyButton.setTitleColor(.black, for: .normal)
        self.upperTextView.isHidden = false
        self.lowerTextView.isHidden = false
        self.firstCurrencyButton.isHidden = false
        self.secondCurrencyButton.isHidden = false
        self.swapButton.isHidden = false
        
        pickerView.isHidden = true
    }
}
