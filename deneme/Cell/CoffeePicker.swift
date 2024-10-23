//
//  CoffeePicker.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 11.10.2024.
//

import UIKit

class CoffeePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let coffeeOptions = [
        "İş Molası", "Tek Başına", "Arkadaşlarla", "Sabah", "Toplantı",
        "Öğleden Sonra", "Akşamüstü", "Gece", "Kitap Okurken", "Film İzlerken",
        "Sohbet", "Tatlıyla Beraber", "Stres", "İlham", "Doğada", "Kamp", "Seyahat"
    ]
    
    var onSelection: ((String) -> Void)?
    private var selectedOption: String?
    private let picker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Arka planı karartmak için
        
        setupPickerView()
    }

    private func setupPickerView() {
        let screenWidth = UIScreen.main.bounds.width
        let alertView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: screenWidth, height: 300))
        alertView.backgroundColor = UIColor(red: 232/255, green: 226/255, blue: 213/255, alpha: 1)
        alertView.layer.cornerRadius = 20
        alertView.clipsToBounds = true
        self.view.addSubview(alertView)
        
        picker.delegate = self
        picker.dataSource = self
        picker.frame = CGRect(x: 0, y: 60, width: screenWidth, height: 120)
        picker.backgroundColor = UIColor(red: 245/255, green: 240/255, blue: 230/255, alpha: 1)
        alertView.addSubview(picker)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        titleLabel.text = "Kahve Anı Seçimi"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = UIColor(red: 115/255, green: 104/255, blue: 94/255, alpha: 1)
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)

        let confirmButton = UIButton(type: .system)
        confirmButton.frame = CGRect(x: screenWidth / 2 - 150, y: 200, width: 130, height: 44)
        confirmButton.setTitle("✓ ONAYLA", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 22
        confirmButton.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
        
        let confirmGradient = CAGradientLayer()
        confirmGradient.colors = [
            UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1).cgColor,
            UIColor(red: 139/255, green: 105/255, blue: 85/255, alpha: 1).cgColor
        ]
        confirmGradient.frame = confirmButton.bounds
        confirmGradient.cornerRadius = 22
        confirmButton.layer.insertSublayer(confirmGradient, at: 0)
        alertView.addSubview(confirmButton)

        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: screenWidth / 2 + 20, y: 200, width: 130, height: 44)
        cancelButton.setTitle("✕ VAZGEÇ", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 22
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        let cancelGradient = CAGradientLayer()
        cancelGradient.colors = [
            UIColor(red: 177/255, green: 144/255, blue: 127/255, alpha: 1).cgColor,
            UIColor(red: 160/255, green: 110/255, blue: 90/255, alpha: 1).cgColor
        ]
        cancelGradient.frame = cancelButton.bounds
        cancelGradient.cornerRadius = 22
        cancelButton.layer.insertSublayer(cancelGradient, at: 0)
        alertView.addSubview(cancelButton)

        // Animasyonla picker'ı ekranın altından getiriyoruz
        alertView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3) {
            alertView.transform = .identity
        }
    }

    @objc private func onConfirm() {
        dismiss(animated: true) {
            if let selectedOption = self.selectedOption {
                self.onSelection?(selectedOption)
            }
        }
    }

    @objc private func onCancel() {
        dismiss(animated: true, completion: nil)
    }

    // UIPickerViewDelegate & UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coffeeOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coffeeOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = coffeeOptions[row]
    }
}


class CoffeeTypePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let coffeeOptions = [
        "Espresso", "Americano", "Cappuccino", "Latte", "Mocha",
        "Macchiato", "Flat White", "Ristretto", "Affogato", "Cortado",
        "Doppio", "Türk Kahvesi", "Irish Coffee", "Viyana Kahvesi", "Cold Brew",
        "Frappé", "Café au Lait", "Café de Olla", "Lungo", "Breve",
        "Café Bombón", "Mazagran", "Shakerato", "Romano"
    ]
    
    var onSelection: ((String) -> Void)?
    private var selectedOption: String?
    private let picker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Arka planı karartmak için
        
        setupPickerView()
    }

    private func setupPickerView() {
        let screenWidth = UIScreen.main.bounds.width
        let alertView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: screenWidth, height: 300))
        alertView.backgroundColor = UIColor(red: 232/255, green: 226/255, blue: 213/255, alpha: 1)
        alertView.layer.cornerRadius = 20
        alertView.clipsToBounds = true
        self.view.addSubview(alertView)
        
        picker.delegate = self
        picker.dataSource = self
        picker.frame = CGRect(x: 0, y: 60, width: screenWidth, height: 120)
        picker.backgroundColor = UIColor(red: 245/255, green: 240/255, blue: 230/255, alpha: 1)
        alertView.addSubview(picker)

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        titleLabel.text = "Kahve Türü Seçimi"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = UIColor(red: 115/255, green: 104/255, blue: 94/255, alpha: 1)
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)

        let confirmButton = UIButton(type: .system)
        confirmButton.frame = CGRect(x: screenWidth / 2 - 150, y: 200, width: 130, height: 44)
        confirmButton.setTitle("✓ ONAYLA", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 22
        confirmButton.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
        
        let confirmGradient = CAGradientLayer()
        confirmGradient.colors = [
            UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1).cgColor,
            UIColor(red: 139/255, green: 105/255, blue: 85/255, alpha: 1).cgColor
        ]
        confirmGradient.frame = confirmButton.bounds
        confirmGradient.cornerRadius = 22
        confirmButton.layer.insertSublayer(confirmGradient, at: 0)
        alertView.addSubview(confirmButton)

        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: screenWidth / 2 + 20, y: 200, width: 130, height: 44)
        cancelButton.setTitle("✕ VAZGEÇ", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 22
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        let cancelGradient = CAGradientLayer()
        cancelGradient.colors = [
            UIColor(red: 177/255, green: 144/255, blue: 127/255, alpha: 1).cgColor,
            UIColor(red: 160/255, green: 110/255, blue: 90/255, alpha: 1).cgColor
        ]
        cancelGradient.frame = cancelButton.bounds
        cancelGradient.cornerRadius = 22
        cancelButton.layer.insertSublayer(cancelGradient, at: 0)
        alertView.addSubview(cancelButton)

        // Animasyonla picker'ı ekranın altından getiriyoruz
        alertView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.3) {
            alertView.transform = .identity
        }
    }

    @objc private func onConfirm() {
        dismiss(animated: true) {
            if let selectedOption = self.selectedOption {
                self.onSelection?(selectedOption)
            }
        }
    }

    @objc private func onCancel() {
        dismiss(animated: true, completion: nil)
    }

    // UIPickerViewDelegate & UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coffeeOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coffeeOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = coffeeOptions[row]
    }
}
