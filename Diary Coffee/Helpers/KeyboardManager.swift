//
//  KeyboardManager.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 26.10.2024.
//

import UIKit

class KeyboardManager {
   
    func configureUppercaseKeyboard(for textField: UITextField) {
        textField.autocapitalizationType = .allCharacters
    }

    
    func addTapToDismissKeyboard(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
}
