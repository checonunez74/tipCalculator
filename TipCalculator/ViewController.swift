//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Sergio Nunez on 7/31/19.
//  Copyright © 2019 OmegaOneDevelopers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tenPercentLabel: UILabel!
    @IBOutlet weak var fifteenPercentLabel: UILabel!
    @IBOutlet weak var twelvePercentLabel: UILabel!
    
    @IBOutlet weak var billTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        billTextField.delegate = self
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
       
    }
    
    deinit {
        // Stop listining to the keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // Actions
    @IBAction func calculateTipButtonPressed(_ sender: Any) {
        print("Calculate Tip")
        hideKeyboard()
        calculateAllTips()
        
    }
    
    // Methods or functions
    func hideKeyboard(){
        billTextField.resignFirstResponder()
    }
    
    func calculateAllTips() {
        
        guard let subtotal = convertCurrencyToDouble(input: billTextField.text!) else {
            print("Not a number!: \(billTextField.text!)")
            return
        }
        print("The subtotal is: \(subtotal)")
        
        //Calculate the tips
        let tip1 = calculateTip(subtootal: subtotal, tipPercentage: 10.0)
        let tip2 = calculateTip(subtootal: subtotal, tipPercentage: 15.0)
        let tip3 = calculateTip(subtootal: subtotal, tipPercentage: 20.0)
        
        // Update the UI
        tenPercentLabel.text = convertDoubleToCurrency(amount: tip1)
        fifteenPercentLabel.text = convertDoubleToCurrency(amount: tip2)
        twelvePercentLabel.text = convertDoubleToCurrency(amount: tip3)
    }
    
    func calculateTip(subtootal: Double, tipPercentage: Double) -> Double {
        return subtootal * (tipPercentage/100.0)
    }
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFomatter = NumberFormatter()
        numberFomatter.numberStyle = .currency
        numberFomatter.locale = Locale.current
        
        return numberFomatter.string(from: NSNumber(value: amount))!
    }
    
    // Add animation to keyboard
    @objc func keyBoardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name.self == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                        view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        calculateAllTips()
        return true
    }
    
}

