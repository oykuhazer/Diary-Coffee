//
//  SecurityViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 5.10.2024.
//

import UIKit

class SecurityViewController: UIViewController {

    private let titleLabel = UILabel()
    private let pinStackView = UIStackView()
    private let pinTextField1 = UITextField()
    private let pinTextField2 = UITextField()
    private let pinTextField3 = UITextField()
    private let pinTextField4 = UITextField()
    private let setPinButton = UIButton()
    private let numberPadStackView = UIStackView()
    private let containerView = UIView() // PIN alanı için arka plan
    private let keyboardContainerView = UIView() // Klavye arka planı
    
    private var currentPinIndex = 0
    private var pinFields: [UITextField] {
        return [pinTextField1, pinTextField2, pinTextField3, pinTextField4]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 240/255, green: 224/255, blue: 208/255, alpha: 1.0).cgColor,  // Üst: Açık kahve
            UIColor(red: 176/255, green: 132/255, blue: 100/255, alpha: 1.0).cgColor  // Alt: Koyu kahve
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        setupContainerView()
        setupKeyboardContainerView()

        // Title label setup
        setupTitleLabel()

        // PIN input fields setup (Arka planlı, kenarlık yok)
        setupPinInputFields()

        // Set PIN button setup
        setupSetPinButton()

        // Number pad buttons (0-9 and delete)
        setupNumberPad()

        // Layout constraints
        setupConstraints()
    }

    private func setupContainerView() {
        containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.85)
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    }

    private func setupKeyboardContainerView() {
        keyboardContainerView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        keyboardContainerView.layer.cornerRadius = 20
        keyboardContainerView.layer.shadowColor = UIColor.black.cgColor
        keyboardContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        keyboardContainerView.layer.shadowOpacity = 0.3
        keyboardContainerView.layer.shadowRadius = 4
        keyboardContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardContainerView)
    }

    private func setupTitleLabel() {
        titleLabel.text = "PIN Kodu"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        titleLabel.textColor = UIColor(red: 101/255, green: 67/255, blue: 33/255, alpha: 1.0) // Koyu kahve
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
    }

    private func setupPinInputFields() {
        pinStackView.axis = .horizontal
        pinStackView.distribution = .fillEqually
        pinStackView.spacing = 20
        pinStackView.translatesAutoresizingMaskIntoConstraints = false

        [pinTextField1, pinTextField2, pinTextField3, pinTextField4].forEach { textField in
            textField.backgroundColor = UIColor(red: 224/255, green: 202/255, blue: 180/255, alpha: 1.0) // Açık kahve
            textField.layer.cornerRadius = 10
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            textField.isSecureTextEntry = true
            textField.textColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            textField.widthAnchor.constraint(equalToConstant: 60).isActive = true // Kare şekli için sabit genişlik
            pinStackView.addArrangedSubview(textField)
        }

        containerView.addSubview(pinStackView)
    }

    private func setupSetPinButton() {
        setPinButton.setTitle("PIN'i Ayarla", for: .normal)
        setPinButton.backgroundColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0)
        setPinButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        setPinButton.setTitleColor(.white, for: .normal)
        setPinButton.layer.cornerRadius = 30
        setPinButton.layer.shadowColor = UIColor.black.cgColor
        setPinButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        setPinButton.layer.shadowOpacity = 0.4
        setPinButton.layer.shadowRadius = 5
        setPinButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(setPinButton)

        setPinButton.addTarget(self, action: #selector(setPinButtonTapped), for: .touchUpInside)
    }

    private func setupNumberPad() {
        let buttons = (1...9).map { createNumberButton(with: "\($0)") }
        let deleteButton = createDeleteButton()
        let zeroButton = createNumberButton(with: "0")

        numberPadStackView.axis = .vertical
        numberPadStackView.distribution = .equalSpacing
        numberPadStackView.spacing = 15
        numberPadStackView.translatesAutoresizingMaskIntoConstraints = false

        let rows: [[UIButton]] = [
            Array(buttons[0...2]),  // 1, 2, 3
            Array(buttons[3...5]),  // 4, 5, 6
            Array(buttons[6...8])   // 7, 8, 9
        ]

        for row in rows {
            let rowStackView = UIStackView(arrangedSubviews: row)
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            numberPadStackView.addArrangedSubview(rowStackView)
        }

        let lastRowStackView = UIStackView(arrangedSubviews: [UIView(), zeroButton, deleteButton])
        lastRowStackView.axis = .horizontal
        lastRowStackView.distribution = .fillEqually
        lastRowStackView.spacing = 10
        numberPadStackView.addArrangedSubview(lastRowStackView)

        keyboardContainerView.addSubview(numberPadStackView)
    }

    private func createNumberButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    private func createDeleteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(deleteLastPinDigit), for: .touchUpInside)
        return button
    }

    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.title(for: .normal) else { return }
        addPinDigit(number)
    }

    private func addPinDigit(_ digit: String) {
        if currentPinIndex < pinFields.count {
            let currentField = pinFields[currentPinIndex]
            currentField.text = digit
            animatePinField(currentField)
            currentPinIndex += 1
        }
    }

    private func animatePinField(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            textField.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            textField.backgroundColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0)
            textField.textColor = .white
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                textField.transform = CGAffineTransform.identity
            }
        }
    }

    @objc private func deleteLastPinDigit() {
        if currentPinIndex > 0 {
            currentPinIndex -= 1
            let currentField = pinFields[currentPinIndex]
            currentField.text = ""
            UIView.animate(withDuration: 0.3) {
                currentField.backgroundColor = UIColor(red: 224/255, green: 202/255, blue: 180/255, alpha: 1.0)
                currentField.textColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0)
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            pinStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            pinStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            setPinButton.topAnchor.constraint(equalTo: pinStackView.bottomAnchor, constant: 30),
            setPinButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            setPinButton.widthAnchor.constraint(equalToConstant: 200),
            setPinButton.heightAnchor.constraint(equalToConstant: 60),
            setPinButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),

            keyboardContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 50),
            keyboardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            keyboardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            numberPadStackView.topAnchor.constraint(equalTo: keyboardContainerView.topAnchor, constant: 20),
            numberPadStackView.leadingAnchor.constraint(equalTo: keyboardContainerView.leadingAnchor, constant: 20),
            numberPadStackView.trailingAnchor.constraint(equalTo: keyboardContainerView.trailingAnchor, constant: -20),
            numberPadStackView.bottomAnchor.constraint(equalTo: keyboardContainerView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func setPinButtonTapped() {
        guard let pin1 = pinTextField1.text, let pin2 = pinTextField2.text,
              let pin3 = pinTextField3.text, let pin4 = pinTextField4.text,
              !pin1.isEmpty, !pin2.isEmpty, !pin3.isEmpty, !pin4.isEmpty else {
            print("Lütfen tüm PIN alanlarını doldurun")
            return
        }

        let pin = "\(pin1)\(pin2)\(pin3)\(pin4)"
        print("PIN oluşturuldu: \(pin)")
    }
}
