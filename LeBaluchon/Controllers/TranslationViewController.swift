//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 08/06/2022.
//

import Foundation
import UIKit
import Lottie

class TranslationViewController: UIViewController, UITextViewDelegate {
    
// MARK: @IBOUTLETS & PROPRETIES
    @IBOutlet private weak var animationIcon: AnimationView!
    @IBOutlet weak var upperTextView: UITextView!
    @IBOutlet weak var lowerTextView: UITextView!
    @IBOutlet weak var firstLanguageButton: UIButton!
    @IBOutlet weak var secondLanguageButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var languagePickerView: UIPickerView!
    
    let placeholder = "Entrez votre texte"
    let languages : [Languages]? = [.french, .english]
    var sourceKeys : String = Languages.french.languagesKeys
    var targetKeys : String = Languages.english.languagesKeys
    var sourceNames: String = Languages.french.languagesNames
    var targetNames: String = Languages.english.languagesNames
    
// MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animationIcon.animation = Animation.named("Lottie_Translate")
        self.animationIcon.loopMode = .loop
        self.animationIcon.contentMode = .scaleAspectFit
        
        self.languagePickerView.isHidden = true
        self.languagePickerView.delegate = self
        self.languagePickerView.dataSource = self
        
        self.swapButton.layer.cornerRadius = swapButton.bounds.size.height / 2
        self.swapButton.clipsToBounds = false
        
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
    
// MARK: UI Methods settings
    func setButtonStyle() {
        let origImage = UIImage(named: "translate_symbol")
        let switchImage = UIImage(named: "swap")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let imageButton = switchImage?.withRenderingMode(.alwaysTemplate)
        
        self.swapButton.setImage(imageButton, for: .normal)
        self.swapButton.tintColor = .red
        self.swapButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
        
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
        self.setupButton(button: swapButton, color: .red, width: 1)
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
    
// MARK: @IBACTIONS
    
    // Left pickerView appear while clicking on it
    @IBAction func selectFirstLang(_ sender: Any) {
        getTranslation(pickerView: languagePickerView)
        if languagePickerView.isHidden {
            self.languagePickerView.isHidden = false
            self.upperTextView.isHidden = true
            self.lowerTextView.isHidden = true
            self.firstLanguageButton.isHidden = true
            self.secondLanguageButton.isHidden = true
            self.swapButton.isHidden = true
        } else {
            self.languagePickerView.isHidden = true
        }
    }
    
    // Right pickerView appear while clicking on it
    @IBAction func selectSecondLang(_ sender: Any) {
        getTranslation(pickerView: languagePickerView)
        if languagePickerView.isHidden {
            self.languagePickerView.isHidden = false
            self.upperTextView.isHidden = true
            self.lowerTextView.isHidden = true
            self.firstLanguageButton.isHidden = true
            self.secondLanguageButton.isHidden = true
            self.swapButton.isHidden = true
        } else {
            self.languagePickerView.isHidden = true
        }
    }
    
    // IBAction to switch the languages
    @IBAction func swapLanguage(_ sender: UIButton) {
        sender.isSelected = !swapButton.isSelected
        guard sender.isSelected == false else {
            clearText()
            TranslationService.shared.changeLanguage(source: sourceKeys, target: targetKeys)
            self.firstLanguageButton.setTitle(targetNames, for: .normal)
            self.secondLanguageButton.setTitle(sourceNames, for: .normal)
            return
        }
        clearText()
        TranslationService.shared.changeLanguage(source: targetKeys, target: sourceKeys)
        self.firstLanguageButton.setTitle(sourceNames, for: .normal)
        self.secondLanguageButton.setTitle(targetNames, for: .normal)
    }
    
    // IBAction to get the translation
    @IBAction func translate() {
        textViewEmpty(textview: upperTextView)
        if swapButton.isSelected {
            TranslationService.shared.translate(source: targetKeys , q: upperTextView.text, target: sourceKeys) { (true, result) in
                guard let trans = result else { return }
                self.update(textChange: trans)
            }
        } else {
            TranslationService.shared.translate(source: sourceKeys , q: upperTextView.text, target: targetKeys) { (true, result) in
                guard let trans = result else { return }
                self.update(textChange: trans)
            }
        }
    }
    
// MARK: Methods
    
    // Method that check if the texView is empty
    func textViewEmpty(textview: UITextView) {
        if textview.text.isEmpty {
            self.alertWithValueError(value: "Erreur", message: "Veuilez entrez du texte !")
        }
    }
    
    // Method which gives the result
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
    
   // Method that allows not to translate two same languages
    func getTranslation(pickerView: UIPickerView) {
        let sourceRow = pickerView.selectedRow(inComponent: 0)
        let targetRow = pickerView.selectedRow(inComponent: 1)
        
        guard let source = languages?[sourceRow].languagesKeys else { return }
        guard let target = languages?[targetRow].languagesKeys else { return }
        
        if source == target {
            alertSameLanguage(message: "Tu ne peux pas traduire dans la même langue.")
        } else {
            translate()
        }
    }
}
