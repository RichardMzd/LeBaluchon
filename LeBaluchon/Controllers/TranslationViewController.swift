//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 08/06/2022.
//

import Foundation
import UIKit
import Lottie

class TranslationViewController: UIViewController {
    
    @IBOutlet private weak var animationIcon: AnimationView!
    @IBOutlet private weak var upperTextView: UITextView!
    @IBOutlet private weak var lowerTextView: UITextView!
    @IBOutlet private weak var firstLanguageButton: UIButton!
    @IBOutlet private weak var secondLanguageButton: UIButton!
    @IBOutlet private weak var translateButton: UIButton!
    @IBOutlet private weak var reverseButton: UIButton!
    @IBOutlet private weak var languagePickerView: UIPickerView!
    
    let lang : [Languages]? = [.french, .english]
    var sourceKeys : String = Languages.french.languagesKeys
    var targetKeys : String = Languages.english.languagesKeys
    
    var sourceNames: String = Languages.french.languagesNames
    var targetNames: String = Languages.english.languagesNames
    
    let placeholder = "Entrez votre texte"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animationIcon.animation = Animation.named("Lottie_Translate")
        self.animationIcon.loopMode = .loop
        self.animationIcon.contentMode = .scaleAspectFit
        
        self.languagePickerView.isHidden = true
        self.languagePickerView.delegate = self
        self.languagePickerView.dataSource = self
        
        self.reverseButton.layer.cornerRadius = reverseButton.bounds.size.height / 2
        self.reverseButton.clipsToBounds = false
        
        self.firstLanguageButton.setTitle(sourceNames, for: .normal)
        self.firstLanguageButton.setTitleColor(.black, for: .normal)
        self.secondLanguageButton.setTitle(targetNames, for: .normal)
        self.secondLanguageButton.setTitleColor(.black, for: .normal)
        
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
        let origImage = UIImage(named: "translate_symbol")
        let switchImage = UIImage(named: "swap")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let imageButton = switchImage?.withRenderingMode(.alwaysTemplate)
        
        self.reverseButton.setImage(imageButton, for: .normal)
        self.reverseButton.tintColor = .red
        
        self.translateButton.setTitle("Traduire", for: .normal)
        self.translateButton.setTitleColor(.black, for: .normal)
        self.translateButton.setImage(tintedImage, for: .normal)
        self.translateButton.tintColor = .blue
        self.translateButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.translateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        self.translateButton.titleLabel?.font = .systemFont(ofSize: 25)
    }
    
    func updateStyle() {
        self.setupButton(button: firstLanguageButton, color: .red, width: 1)
        self.setupButton(button: secondLanguageButton, color: .red, width: 1)
        self.setupButton(button: reverseButton, color: .red, width: 1)
        self.setupButton(button: translateButton, color: .blue, width: 1)
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
    
    
    @IBAction func selectFirstLang(_ sender: Any) {
        getTranslation(pickerView: languagePickerView)
        if languagePickerView.isHidden {
            self.languagePickerView.isHidden = false
            self.upperTextView.isHidden = true
            self.lowerTextView.isHidden = true
            self.firstLanguageButton.isHidden = true
            self.secondLanguageButton.isHidden = true
            self.reverseButton.isHidden = true
        } else {
            self.languagePickerView.isHidden = true
        }
    }
    
    @IBAction func selectSecondLang(_ sender: Any) {
        getTranslation(pickerView: languagePickerView)
        if languagePickerView.isHidden {
            self.languagePickerView.isHidden = false
            self.upperTextView.isHidden = true
            self.lowerTextView.isHidden = true
            self.firstLanguageButton.isHidden = true
            self.secondLanguageButton.isHidden = true
            self.reverseButton.isHidden = true
        } else {
            self.languagePickerView.isHidden = true
        }
    }
    
    @IBAction func swapLanguage(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard sender.isSelected == false else {
            clearText()
            TranslationService.shared.changeLanguage(source: targetKeys, target: sourceKeys)
            self.firstLanguageButton.setTitle(targetNames, for: .normal)
            self.secondLanguageButton.setTitle(sourceNames, for: .normal)
            return
        }
        clearText()
        TranslationService.shared.changeLanguage(source: sourceKeys, target: targetKeys)
        self.firstLanguageButton.setTitle(sourceNames, for: .normal)
        self.secondLanguageButton.setTitle(targetNames, for: .normal)
    }
    
    @IBAction func translate() {
        TranslationService.shared.translate(source: sourceKeys , q: upperTextView.text, target: targetKeys) { result in
            guard let trans = result else {
                return
            }
            self.update(textChange: trans)
        }
    }
    
    private func update(textChange: Translate) {
        guard let translate = textChange.data.translations.first?.translatedText else {
            lowerTextView.text = nil
            return
        }
        lowerTextView.text = translate
    }
    
    private func clearText() {
        lowerTextView.text = ""
        upperTextView.text = ""
    }
    
    func getTranslation(pickerView: UIPickerView) {
        let sourceRow = pickerView.selectedRow(inComponent: 0)
        let targetRow = pickerView.selectedRow(inComponent: 1)
        
        guard let source = lang?[sourceRow].languagesKeys else { return }
        guard let target = lang?[targetRow].languagesKeys else { return }
        
        if source == target {
            print("done")
            //            self.alertSameLanguage()
        } else {
            translate()
            //            fetchDataTranslation(source: source, q: upperTextView.text ?? "no Text", target: target)
        }
    }
}


extension TranslationViewController: UITextViewDelegate {
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

extension TranslationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lang?.count ?? 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lang?[row].languagesNames
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choiceOne = pickerView.selectedRow(inComponent: 0)
        let choiceTwo = pickerView.selectedRow(inComponent: 1)
        
        sourceKeys = lang?[choiceOne].languagesKeys ?? ""
        targetKeys = lang?[choiceTwo].languagesKeys ?? ""
        
        self.firstLanguageButton.setTitle(lang?[choiceOne].languagesNames, for: .normal)
        self.firstLanguageButton.setTitleColor(.black, for: .normal)
        self.secondLanguageButton.setTitle(lang?[choiceTwo].languagesNames, for: .normal)
        self.secondLanguageButton.setTitleColor(.black, for: .normal)
        self.upperTextView.isHidden = false
        self.lowerTextView.isHidden = false
        self.firstLanguageButton.isHidden = false
        self.secondLanguageButton.isHidden = false
        self.reverseButton.isHidden = false
        
        pickerView.isHidden = true
    }
}

