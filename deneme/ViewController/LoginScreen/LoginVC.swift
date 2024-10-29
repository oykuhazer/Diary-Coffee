//
//  ViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 25.09.2024.
//
//UIColor(red: 139/255, green: 105/255, blue: 85/255, alpha: 1) // #8B6955
import UIKit

class LoginVC: UIViewController {

    private let fingerprintImageView = UIImageView()
    private let pinImageView = UIImageView()
    private let patternImageView = UIImageView()
    private let titleLabel = UILabel()
    private let titleBackgroundView = UIView() // Label arkası için şekilli bir arka plan
    private let devamEtButton = UIButton() // DEVAM ET button
    private var devamEtButtonAlreadyCreated = false // To check if button was created already

    private var selectedButton: UIView? // To track the selected button
    private var isSelectionMade = false {
        didSet {
            if isSelectionMade && !devamEtButtonAlreadyCreated {
                showDevamEtButtonWithAnimation() // Show button with animation when selection is made
                devamEtButtonAlreadyCreated = true // Prevent re-creation of button
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Create a gradient background
        setupGradientBackground()

        // Title label with enhanced styling
        setupTitleLabel()

        // DEVAM ET button setup (initially hidden)
        setupOriginalButton()

        // Image views with white backgrounds and options
        setupImageView(fingerprintImageView, imageName: "password1", title: "Fingerprint", action: #selector(optionSelected(_:)))
        setupImageView(pinImageView, imageName: "password2", title: "PIN Code", action: #selector(optionSelected(_:)))
        setupImageView(patternImageView, imageName: "password3", title: "Pattern Lock", action: #selector(optionSelected(_:)))

        // Adding constraints
        setupConstraints()

        // Animate the title label
        animateTitleLabel()
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0).cgColor, // #FAF5F0
            UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0).cgColor  // #E6D9CC
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupTitleLabel() {
        // Title background view with deep brown and soft shadows
        titleBackgroundView.backgroundColor = UIColor(red: 101/255, green: 67/255, blue: 33/255, alpha: 0.8) // Koyu kahve tonları
        titleBackgroundView.layer.cornerRadius = 20
        titleBackgroundView.layer.shadowColor = UIColor.black.cgColor
        titleBackgroundView.layer.shadowOpacity = 0.4
        titleBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 8) // Daha derin gölgeler
        titleBackgroundView.layer.shadowRadius = 10
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleBackgroundView)

        // Gradient border to give a modern and sleek effect
        let gradientBorderLayer = CAGradientLayer()
        gradientBorderLayer.colors = [
            UIColor(red: 120/255, green: 75/255, blue: 45/255, alpha: 1).cgColor, // Açık kahve tonları
            UIColor(red: 60/255, green: 35/255, blue: 20/255, alpha: 1).cgColor   // Daha koyu kahve tonları
        ]
        gradientBorderLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientBorderLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientBorderLayer.frame = titleBackgroundView.bounds
        gradientBorderLayer.cornerRadius = 20
        titleBackgroundView.layer.insertSublayer(gradientBorderLayer, at: 0)

        // Label text with modern, sleek style and soft shadow
        titleLabel.text = "Capture Every Sip\nLog In and Start Brewing Memories"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18) // Modern ve zarif font
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Light shadow to lift the text slightly
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        titleLabel.layer.shadowRadius = 8
        view.addSubview(titleLabel)

        // Constraints for titleLabel and titleBackgroundView
        NSLayoutConstraint.activate([
            titleBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: 130),

            titleLabel.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -20)
        ])

        // Smooth fade-in animation for a modern, dynamic feel
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Başlangıçta küçültülmüş

        UIView.animate(withDuration: 1.2, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = CGAffineTransform.identity // Yavaşça büyüyüp normal hale gelir
        }, completion: nil)
    }








    private func animateTitleLabel() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.animateButtons()
        })
    }

    private func setupImageView(_ imageView: UIImageView, imageName: String, title: String, action: Selector) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 4
        
        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        imageView.addGestureRecognizer(tapGesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 139/255, green: 105/255, blue: 85/255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        view.addSubview(containerView)

        containerView.alpha = 0
        containerView.transform = CGAffineTransform(translationX: 0, y: 20)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }

    private func animateButtons() {
        let buttons = [fingerprintImageView.superview!, pinImageView.superview!, patternImageView.superview!]
        
        for (index, button) in buttons.enumerated() {
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.3, options: .curveEaseInOut, animations: {
                button.alpha = 1
                button.transform = CGAffineTransform.identity
            })
        }
    }

    private func setupOriginalButton() {
        devamEtButton.setTitle("DEVAM ET", for: .normal)
        devamEtButton.backgroundColor = UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1)
        devamEtButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        devamEtButton.setTitleColor(.white, for: .normal)
        devamEtButton.layer.cornerRadius = 25
        devamEtButton.layer.shadowColor = UIColor.black.cgColor
        devamEtButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        devamEtButton.layer.shadowOpacity = 0.2
        devamEtButton.layer.shadowRadius = 4
        devamEtButton.translatesAutoresizingMaskIntoConstraints = false
        devamEtButton.isHidden = true
        view.addSubview(devamEtButton)
    }

    private func showDevamEtButtonWithAnimation() {
        devamEtButton.alpha = 0
        devamEtButton.isHidden = false
        devamEtButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.devamEtButton.alpha = 1
            self.devamEtButton.transform = CGAffineTransform.identity
        }) { _ in
            self.startPulseAnimation()
        }
    }

    private func startPulseAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.devamEtButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
    }

    @objc private func optionSelected(_ sender: UITapGestureRecognizer) {
        if let previousButton = selectedButton {
            previousButton.layer.borderWidth = 0
            previousButton.layer.shadowOpacity = 0.15
        }

        if let selectedView = sender.view?.superview {
            selectedView.layer.borderWidth = 2
            selectedView.layer.borderColor = UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1).cgColor
            selectedView.layer.shadowOpacity = 0.3
            selectedButton = selectedView
        }

        isSelectionMade = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor),

            fingerprintImageView.superview!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fingerprintImageView.superview!.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor, constant: 40),
            fingerprintImageView.superview!.widthAnchor.constraint(equalToConstant: 150),
            fingerprintImageView.superview!.heightAnchor.constraint(equalToConstant: 150),

            pinImageView.superview!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinImageView.superview!.topAnchor.constraint(equalTo: fingerprintImageView.superview!.bottomAnchor, constant: 20),
            pinImageView.superview!.widthAnchor.constraint(equalToConstant: 150),
            pinImageView.superview!.heightAnchor.constraint(equalToConstant: 150),

            patternImageView.superview!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            patternImageView.superview!.topAnchor.constraint(equalTo: pinImageView.superview!.bottomAnchor, constant: 20),
            patternImageView.superview!.widthAnchor.constraint(equalToConstant: 150),
            patternImageView.superview!.heightAnchor.constraint(equalToConstant: 150),

            devamEtButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            devamEtButton.topAnchor.constraint(equalTo: patternImageView.superview!.bottomAnchor, constant: 50),
            devamEtButton.widthAnchor.constraint(equalToConstant: 200),
            devamEtButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
