//
//  ProfileNotificationVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.12.2024.
//

import UIKit

class ProfileNotificationVC: UIViewController {
    private var recordStack: UIStackView!
    private var fortuneStack: UIStackView!
    private var recordSwitch: UISwitch!
    private var fortuneSwitch: UISwitch!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("notifications", comment: "")
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]
        
        setupUI()
        
    }

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
     
        let recordLabel = createSectionLabel(text: NSLocalizedString("record_notification", comment: ""))

        
        recordSwitch = createSwitch(isOn: true)
        recordSwitch.addTarget(self, action: #selector(handleRecordSwitchChanged), for: .valueChanged)
        
        recordStack = UIStackView(arrangedSubviews: [
            createRow(
                iconName: "alarm.fill",
                text: NSLocalizedString("get_daily_reminders", comment: ""),
                control: recordSwitch
            ),
            createRow(
                iconName: "alarm.fill",
                text: NSLocalizedString("remind_me_at", comment: ""),
                control: createTimePickerButton(width: 70)
            ),
            createRow(
                iconName: "alarm.fill",
                text: NSLocalizedString("smart_scheduling_reminder", comment: ""),
                control: createSwitch(isOn: true)
            )
        ])

        recordStack.axis = .vertical
        recordStack.spacing = 16
        recordStack.translatesAutoresizingMaskIntoConstraints = false
        
        let fortuneLabel = createSectionLabel(text: "Fortune coffee beans notification")
        
        fortuneSwitch = createSwitch(isOn: true)
        fortuneSwitch.addTarget(self, action: #selector(handleFortuneSwitchChanged), for: .valueChanged)
        
        fortuneStack = UIStackView(arrangedSubviews: [
            createRow(
                iconName: "alarm.fill",
                text: NSLocalizedString("get_daily_reminders", comment: ""),
                control: fortuneSwitch
            ),
            createRow(
                iconName: "alarm.fill",
                text: NSLocalizedString("remind_me_at", comment: ""),
                control: createTimePickerButton(width: 70)
            )
        ])

        fortuneStack.axis = .vertical
        fortuneStack.spacing = 16
        fortuneStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [recordLabel, recordStack, fortuneLabel, fortuneStack])
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
        
        handleRecordSwitchChanged()
        handleFortuneSwitchChanged()
    }
    
    private func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = AppColors.color5
        return label
    }
    
    private func createSwitch(isOn: Bool) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = isOn
        uiSwitch.onTintColor = AppColors.color7
        return uiSwitch
    }
    
    private func createTimePickerButton(width: CGFloat = 70) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(UserProfile.shared.notificationTimeString, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(AppColors.color3, for: .normal)
        button.backgroundColor = AppColors.color4
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.addTarget(self, action: #selector(timePickerTapped(sender:)), for: .touchUpInside)
        return button
    }
    
    private func createRow(iconName: String, text: String, control: UIView) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = AppColors.color5
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = AppColors.color5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        control.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(icon)
        row.addSubview(label)
        row.addSubview(control)
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            
            control.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            control.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            
            row.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return row
    }
    
    @objc private func timePickerTapped(sender: UIButton) {
       
        let timePickerView = ReminderTimePickerView()
        
    
        if let currentTitle = sender.title(for: .normal) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let currentTime = dateFormatter.date(from: currentTitle) {
                timePickerView.timePicker.date = currentTime
            }
        }
        
        timePickerView.onTimeSelected = { [weak self] selectedDate in
            guard let self = self else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let selectedTime = dateFormatter.string(from: selectedDate)
            sender.setTitle(selectedTime, for: .normal)
            
            UserProfile.shared.notificationTime = selectedDate
            
        
            SaveUserProfileRequest.shared.saveUserProfile(in: self.view) { result in
                switch result {
                case .success:
                    
                    let recordActionView = RequiredActionView(frame: self.view.bounds)
                    recordActionView.configure(
                        icon: UIImage(named: "success"),
                        message: NSLocalizedString("info_updated", comment: "")
                    )
                    self.view.addSubview(recordActionView)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        recordActionView.removeFromSuperview()
                    }
                    
                case .failure(let error):
                    print("")
                    
                }
            }
        }
       
       
        timePickerView.profileNotificationCallback = { [weak self] in
            guard let self = self else { return }
            
           
           
            
        }
        
        timePickerView.showOverlayWithBlurEffect(on: self.view)
    }

    
    @objc private func handleRecordSwitchChanged() {
        let isOn = recordSwitch.isOn
        for (index, subview) in recordStack.arrangedSubviews.enumerated() {
            if index > 0 {
                subview.isHidden = !isOn
            }
        }
    }
    
    @objc private func handleFortuneSwitchChanged() {
        let isOn = fortuneSwitch.isOn
        for (index, subview) in fortuneStack.arrangedSubviews.enumerated() {
            if index > 0 {
                subview.isHidden = !isOn
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
          
            tabBarController.tabBar.isHidden = true
            tabBarController.tabBar.isUserInteractionEnabled = false
            tabBarController.tabBar.items?.forEach { $0.isEnabled = false }

            tabBarController.circularView.isHidden = true
            tabBarController.circularView.isUserInteractionEnabled = false
            
            if let gestures = tabBarController.circularView.gestureRecognizers {
                gestures.forEach { tabBarController.circularView.removeGestureRecognizer($0) }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
           
            tabBarController.tabBar.isHidden = false
            tabBarController.tabBar.isUserInteractionEnabled = true
            tabBarController.tabBar.items?.forEach { $0.isEnabled = true }

           
            tabBarController.circularView.isHidden = false
            tabBarController.circularView.isUserInteractionEnabled = true
            
           
            let tapGesture = UITapGestureRecognizer(target: tabBarController, action: #selector(tabBarController.circularViewTapped))
            tabBarController.circularView.addGestureRecognizer(tapGesture)
        }
    }
}

