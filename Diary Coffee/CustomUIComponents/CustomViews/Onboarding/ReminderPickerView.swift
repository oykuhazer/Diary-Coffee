//
//  ReminderPickerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class ReminderTimePickerView: UIView {
    
    private var overlayView: UIView?
    private var blurEffectView: UIVisualEffectView?
    let timePicker = UIDatePicker()
    let selectButton = UIButton(type: .system)
    
    var onTimeSelected: ((Date) -> Void)?
    var profileNotificationCallback: (() -> Void)?
    
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
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 4
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.backgroundColor = .clear
        timePicker.tintColor = AppColors.color3
        timePicker.setValue(AppColors.color3, forKey: "textColor")
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.setTitle(NSLocalizedString("select_time", comment: ""), for: .normal)
        selectButton.backgroundColor = AppColors.color3
        selectButton.setTitleColor(AppColors.color2, for: .normal)
        selectButton.layer.cornerRadius = 10
        selectButton.layer.borderWidth = 2.0
        selectButton.layer.borderColor = UIColor.white.cgColor
        selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        selectButton.addTarget(self, action: #selector(selectTimeTapped), for: .touchUpInside)

        self.addSubview(timePicker)
        self.addSubview(selectButton)

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            selectButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 20),
            selectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            selectButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            selectButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func showOverlayWithBlurEffect(on parentView: UIView) {
        if overlayView == nil {
            overlayView = UIView(frame: parentView.bounds)
            overlayView?.translatesAutoresizingMaskIntoConstraints = false
            overlayView?.backgroundColor = .clear
            parentView.addSubview(overlayView!)

            NSLayoutConstraint.activate([
                overlayView!.topAnchor.constraint(equalTo: parentView.topAnchor),
                overlayView!.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                overlayView!.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                overlayView!.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
            ])
            
            let blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView?.frame = overlayView!.bounds
            blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView?.addSubview(blurEffectView!)
            
            overlayView?.addSubview(self)
            
            let screenWidth = UIScreen.main.bounds.width

         
            let widthConstant: CGFloat = (screenWidth == 375) ? 330 : 360

            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
                self.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor),
                self.widthAnchor.constraint(equalToConstant: widthConstant),
                self.heightAnchor.constraint(equalToConstant: 250)
            ])


            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
            overlayView?.addGestureRecognizer(tapGesture)
        } else {
            overlayView?.isHidden = false
            blurEffectView?.isHidden = false
            self.isHidden = false
        }
    }

    @objc private func dismissOverlay() {
        overlayView?.isHidden = true
        blurEffectView?.isHidden = true
        self.isHidden = true
    }
    
    @objc private func selectTimeTapped() {
        onTimeSelected?(timePicker.date)
        dismissOverlay()
        profileNotificationCallback?()
    }
}
