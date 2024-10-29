//
//  BirthdayButtonView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class BirthdayButtonView: UIView {
    
    let button = UIButton(type: .system)
    var datePickerView: BirthdayDatePickerView?
    private var overlayView: UIView?
    private var parentVC: UserDetailsInputVC?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        self.layer.cornerRadius = 10

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select your birthday 🎂", for: .normal)
        button.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(selectDateTapped), for: .touchUpInside)

        self.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    @objc private func selectDateTapped() {
        guard let parentView = self.superview else { return }

        overlayView = UIView(frame: parentView.bounds)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(overlayView!)

        NSLayoutConstraint.activate([
            overlayView!.topAnchor.constraint(equalTo: parentView.topAnchor),
            overlayView!.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            overlayView!.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            overlayView!.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = overlayView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView?.addSubview(blurEffectView)

        if let datePickerView = datePickerView {
            datePickerView.isHidden = false
            datePickerView.translatesAutoresizingMaskIntoConstraints = false
            overlayView?.addSubview(datePickerView)

            NSLayoutConstraint.activate([
                datePickerView.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
                datePickerView.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor),
                datePickerView.widthAnchor.constraint(equalToConstant: 380)
            ])
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
        overlayView?.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissOverlay() {
        datePickerView?.isHidden = true
        overlayView?.removeFromSuperview()
        overlayView = nil
    }

    func updateButtonTitle(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)

        button.setTitle("\(dateString) 🎂", for: .normal)

        button.layer.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0).cgColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        parentVC?.dateSelected()
        dismissOverlay()
    }

    func setParentVC(vc: UserDetailsInputVC) {
        self.parentVC = vc
    }
}
