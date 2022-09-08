//
//  Extension.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 06/09/2022.
//

import Foundation
import UIKit

// MARK: TranslationViewController, TextView, PickerView extensions
extension TranslationViewController  {
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
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        } else {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension TranslationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.languages?.count ?? 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.languages?[row].languagesNames
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choiceOne = pickerView.selectedRow(inComponent: 0)
        let choiceTwo = pickerView.selectedRow(inComponent: 1)
        
        sourceKeys = languages?[choiceOne].languagesKeys ?? ""
        targetKeys = languages?[choiceTwo].languagesKeys ?? ""
        
        self.firstLanguageButton.setTitle(languages?[choiceOne].languagesNames, for: .normal)
        self.firstLanguageButton.setTitleColor(.black, for: .normal)
        self.secondLanguageButton.setTitle(languages?[choiceTwo].languagesNames, for: .normal)
        self.secondLanguageButton.setTitleColor(.black, for: .normal)
        self.upperTextView.isHidden = false
        self.lowerTextView.isHidden = false
        self.firstLanguageButton.isHidden = false
        self.secondLanguageButton.isHidden = false
        self.swapButton.isHidden = false
        
        pickerView.isHidden = true
    }
}

// MARK: CurrencyViewController, TextView, PickerView extensions
extension CurrencyViewController {
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
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        } else {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewEmpty(textview: UITextView) {
        if textview.text.isEmpty {
            self.alertWithValueError(value: "Erreur", message: "Veuilez saisir un montant !")
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
