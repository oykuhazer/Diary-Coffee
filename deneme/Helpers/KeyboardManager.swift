//
//  KeyboardManager.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 26.10.2024.
//

import UIKit

class KeyboardManager {
    // Klavyeyi büyük harf modu ile açma ayarı
    func configureUppercaseKeyboard(for textField: UITextField) {
        textField.autocapitalizationType = .allCharacters
    }

    // Dokunmayla klavyeyi kapatma işlevi
    func addTapToDismissKeyboard(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
}
