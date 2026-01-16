//
//  SettingsVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 2.12.2024.
//



import UIKit

class SettingsVC: UIViewController {

  
    private var selectedLanguage: String = "English"
    private let stackView = UIStackView()
    var shouldShowSuccessMessage: Bool = false
    var shouldShowSuccessMessage2: Bool = false
    private var changePinRow: UIView!
    private var spacerView: UIView!
  
    private var switchToWarningLabelMap: [UISwitch: UILabel] = [:]
    var userProfileInformation: GetUserProfileInformationResponse?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("settings", comment: "")

        let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(goToProfileVC)
            )
            navigationItem.leftBarButtonItem = backButton
            navigationController?.navigationBar.tintColor = AppColors.color5
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: AppColors.color5
            ]
       
        setupUI()
        updateLanguageRow()
        
        if shouldShowSuccessMessage {
            showSuccessMessage()
          }
      
        if shouldShowSuccessMessage2 {
            showSuccessMessage2()
          }
        
    }

    private func showSuccessMessage() {
            let recordActionView = RequiredActionView(frame: view.bounds)
            recordActionView.configure(
                icon: UIImage(named: "success"),
                message: NSLocalizedString("records_deleted", comment: "")
            )
            view.addSubview(recordActionView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                recordActionView.removeFromSuperview()
            }
        }
   
    private func showSuccessMessage2() {
            let recordActionView = RequiredActionView(frame: view.bounds)
            recordActionView.configure(
                icon: UIImage(named: "success"),
                message: NSLocalizedString("pin_all_set", comment: "")
            )
            view.addSubview(recordActionView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                recordActionView.removeFromSuperview()
            }
        }

    @objc private func goToProfileVC() {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller is ProfileVC {
                    navigationController.popToViewController(controller, animated: true)
                    return
                }
            }
        }
    }
    
    

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = AppColors.color6
        view.addSubview(scrollView)

        stackView.axis = .vertical
        stackView.spacing = (UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 667) ? 0 : 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

      
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

       
        let customizationSection = createSection(
            title: NSLocalizedString("customization", comment: ""),
            items: [ (NSLocalizedString("themes", comment: ""), UIImage(systemName: "face.smiling"), nil), (NSLocalizedString("pin_lock", comment:""),
           UIImage(systemName: "lock.fill"), true )])

        stackView.addArrangedSubview(customizationSection)

        for subview in customizationSection.subviews {
               if let label = subview.subviews.compactMap({ $0 as? UILabel }).first,
                  label.text == NSLocalizedString("themes", comment: "") {
                   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(themesTapped))
                   subview.addGestureRecognizer(tapGesture)
                   subview.isUserInteractionEnabled = true
                   break
               }
           }
       
        changePinRow = createRow(
            title: NSLocalizedString("change_pin", comment: ""),
            icon: UIImage(systemName: "arrow.clockwise"),
            switchAvailable: false )

        changePinRow?.isHidden = !UserProfile.shared.isPasscodeEnabled
        stackView.addArrangedSubview(changePinRow!)

        if let changePinRow = changePinRow {
            changePinRow.translatesAutoresizingMaskIntoConstraints = false
        
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePinTapped))
            changePinRow.addGestureRecognizer(tapGesture)
            changePinRow.isUserInteractionEnabled = true
            
            NSLayoutConstraint.activate([
                changePinRow.topAnchor.constraint(equalTo: customizationSection.bottomAnchor, constant: 15),
                changePinRow.leadingAnchor.constraint(equalTo: customizationSection.leadingAnchor),
                changePinRow.trailingAnchor.constraint(equalTo: customizationSection.trailingAnchor),
                changePinRow.heightAnchor.constraint(equalToConstant: 30),
                changePinRow.widthAnchor.constraint(equalToConstant: 30),
            ])
            
        }
        
        spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.backgroundColor = .clear
        stackView.addArrangedSubview(spacerView)

        stackView.addArrangedSubview(createSection(
            title: NSLocalizedString("system", comment: ""),
            items: [ (
                    NSLocalizedString("notifications", comment: ""),
                    UIImage(systemName: "bell.fill"),
                    nil),
                (
                    NSLocalizedString("language", comment: ""),
                    UIImage(systemName: "globe"),
                    nil
                )
            ]
        ))


        stackView.addArrangedSubview(createSection(
            title: NSLocalizedString("service_center", comment: "Title for the service center section"),
            items: [
               /* (
                    NSLocalizedString("send_feedback", comment: "Item for sending feedback"),
                    UIImage(systemName: "bubble.left.and.text.bubble.right.fill"),
                    nil
                ), */
                (
                    NSLocalizedString("write_review", comment: "Item for writing a review"),
                    UIImage(systemName: "star.fill"),
                    nil
                ),
                (
                    NSLocalizedString("app_version", comment: "Item for displaying app version"),
                    UIImage(systemName: "info.circle.fill"),
                    nil
                )
            ]
        ))


        for subview in stackView.arrangedSubviews {
            if let section = subview as? UIView {
                for row in section.subviews {
                    if let label = row.subviews.compactMap({ $0 as? UILabel }).first,
                       label.text == NSLocalizedString("send_feedback", comment: "") {
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sendFeedbackTapped))
                        row.addGestureRecognizer(tapGesture)
                        row.isUserInteractionEnabled = true
                        break
                    }
                }
            }
        }

        
        stackView.addArrangedSubview(createSection(
            title: NSLocalizedString("data", comment: ""),
            items: [
                (
                    NSLocalizedString("delete_data", comment: ""),
                    UIImage(systemName: "xmark.circle.fill"),
                    nil
                )
            ]
        ))


        DispatchQueue.main.async {
            if let pinLockSwitch = self.findSwitch(for: NSLocalizedString("pin_lock", comment: "")) {
                pinLockSwitch.isOn = UserProfile.shared.isPasscodeEnabled
                if UserProfile.shared.isPasscodeEnabled, let warningLabel = self.switchToWarningLabelMap[pinLockSwitch] {
                    warningLabel.isHidden = false
                }
            }
            self.updateSpacerVisibility()
        }
    }

    private func updateSpacerVisibility() {
       
        spacerView.isHidden = changePinRow.isHidden
    }

    @objc private func themesTapped() {
        let widgetsVC = WidgetsVC()
        widgetsVC.userProfile = userProfileInformation
        navigationController?.pushViewController(widgetsVC, animated: true)
    }
    
    @objc private func sendFeedbackTapped() {
     
        let sendFeedBackView = ProfileFeedbackView(frame: self.view.bounds)
        self.view.addSubview(sendFeedBackView)
    }

    
    private func createRow(title: String, icon: UIImage?, switchAvailable: Bool) -> UIView {
        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false

        
        let iconView = UIImageView(image: icon)
        iconView.tintColor = AppColors.color7
        iconView.translatesAutoresizingMaskIntoConstraints = false
        rowView.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = AppColors.color7
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        rowView.addSubview(titleLabel)

        if switchAvailable {
            let toggleSwitch = UISwitch()
            toggleSwitch.isOn = false
            toggleSwitch.onTintColor = AppColors.color7
            toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(toggleSwitch)

            NSLayoutConstraint.activate([
                toggleSwitch.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -10),
                toggleSwitch.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
            ])
        } else {
            let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronView.tintColor = AppColors.color7
            chevronView.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(chevronView)

            NSLayoutConstraint.activate([
                chevronView.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -10),
                chevronView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                chevronView.widthAnchor.constraint(equalToConstant: 15),
                chevronView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 10),
            iconView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rowView.trailingAnchor, constant: -50)
        ])

        return rowView
    }

    private func createSection(title: String, items: [(String, UIImage?, Bool?)]) -> UIView {
        let sectionView = UIView()
        sectionView.backgroundColor = AppColors.color6
        sectionView.translatesAutoresizingMaskIntoConstraints = false

        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = AppColors.color5
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(titleLabel)

        var previousView: UIView = titleLabel

        for item in items {
            
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            sectionView.addSubview(rowView)

            
            let iconView = UIImageView(image: item.1)
            iconView.tintColor = AppColors.color7
            iconView.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(iconView)

            
            let itemLabel = UILabel()
            itemLabel.text = item.0
            itemLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            itemLabel.textColor = AppColors.color7
            itemLabel.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(itemLabel)

           
            if let hasSwitch = item.2, hasSwitch {
                let toggleSwitch = UISwitch()
                toggleSwitch.isOn = false
                toggleSwitch.onTintColor = AppColors.color7
                toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
                rowView.addSubview(toggleSwitch)

               
                if item.0 == NSLocalizedString("pin_lock", comment: "") {
                    let warningLabel = UILabel()
                    warningLabel.text = NSLocalizedString("password_warning", comment: "")
                    warningLabel.font = UIFont.boldSystemFont(ofSize: 12)
                    warningLabel.textColor = AppColors.color1
                    warningLabel.numberOfLines = 0
                    warningLabel.translatesAutoresizingMaskIntoConstraints = false
                    warningLabel.isHidden = true
                    sectionView.addSubview(warningLabel)

                   
                    switchToWarningLabelMap[toggleSwitch] = warningLabel

                    NSLayoutConstraint.activate([
                        warningLabel.topAnchor.constraint(equalTo: rowView.bottomAnchor, constant: -4),
                        warningLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 50),
                        warningLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor)
                    ])

                    toggleSwitch.addTarget(self, action: #selector(pinLockSwitchChanged(_:)), for: .valueChanged)
                }

                NSLayoutConstraint.activate([
                    toggleSwitch.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -5),
                    toggleSwitch.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
                ])
            } else {
                let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))
                chevronView.tintColor = AppColors.color7
                chevronView.translatesAutoresizingMaskIntoConstraints = false
                rowView.addSubview(chevronView)

                NSLayoutConstraint.activate([
                    chevronView.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -10),
                    chevronView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                    chevronView.widthAnchor.constraint(equalToConstant: 15),
                    chevronView.heightAnchor.constraint(equalToConstant: 20)
                ])
            }

        
            if item.0 == NSLocalizedString("language", comment: "") {
                rowView.tag = 100
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(languageTapped))
                rowView.addGestureRecognizer(tapGesture)
                rowView.isUserInteractionEnabled = true
            }

            if item.0 == NSLocalizedString("notifications", comment: "") {
                rowView.tag = 101
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationsTapped))
                rowView.addGestureRecognizer(tapGesture)
                rowView.isUserInteractionEnabled = true
            }

            if item.0 == NSLocalizedString("delete_data", comment: "") {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteDataTapped))
                rowView.addGestureRecognizer(tapGesture)
                rowView.isUserInteractionEnabled = true
            }

            if item.0 == NSLocalizedString("app_version", comment: "") {
                let versionLabel = UILabel()
                versionLabel.text = SessionManager.shared.versionWithBuild
                versionLabel.textColor = AppColors.color7
                versionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                versionLabel.translatesAutoresizingMaskIntoConstraints = false
                rowView.addSubview(versionLabel)

                NSLayoutConstraint.activate([
                    versionLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -30),
                    versionLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
                ])
            }

           
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 10),
                iconView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                iconView.widthAnchor.constraint(equalToConstant: 30),
                iconView.heightAnchor.constraint(equalToConstant: 30),

                itemLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
                itemLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),

                rowView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 15),
                rowView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
                rowView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
                rowView.heightAnchor.constraint(equalToConstant: 40)
            ])

            previousView = rowView
        }

       
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 10),
            previousView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -10)
        ])

        return sectionView
    }


    private func findSwitch(for itemName: String) -> UISwitch? {
        for case let section as UIView in stackView.arrangedSubviews {
            for row in section.subviews {
                if let label = row.subviews.compactMap({ $0 as? UILabel }).first,
                   label.text == itemName,
                   let toggleSwitch = row.subviews.compactMap({ $0 as? UISwitch }).first {
                    return toggleSwitch
                }
            }
        }
        return nil
    }
    
    
    
    @objc private func languageTapped() {
        let languageVC = LanguageVC()
        languageVC.selectedLanguage = selectedLanguage
        languageVC.onLanguageSelected = { [weak self] selectedLanguage in
            self?.selectedLanguage = selectedLanguage
            self?.updateLanguageRow()
        }
        languageVC.onDismiss = { [weak self] in
            self?.showLanguageUpdateSuccess()
        }
        let navController = UINavigationController(rootViewController: languageVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }

    private func showLanguageUpdateSuccess() {
        let recordActionView = RequiredActionView(frame: self.view.bounds)
        recordActionView.configure(
            icon: UIImage(named: "success"),
            message: NSLocalizedString("info_updated_settings", comment: "")
        )
        view.addSubview(recordActionView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            recordActionView.removeFromSuperview()
        }
    }

    
    @objc private func notificationsTapped() {
        let profileNotificationVC = ProfileNotificationVC()
        navigationController?.pushViewController(profileNotificationVC, animated: true)
    }


    private func updateLanguageRow() {
        guard let languageRow = findLanguageRow() else { return }

       
        languageRow.subviews.filter {
            $0 is UILabel && ($0 as! UILabel).text != NSLocalizedString("language", comment: "")
        }.forEach {
            $0.removeFromSuperview()
        }


        
        let languageValueLabel = UILabel()
        languageValueLabel.text = UserProfile.shared.language
        languageValueLabel.textColor = AppColors.color7
        languageValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        languageValueLabel.translatesAutoresizingMaskIntoConstraints = false
        languageRow.addSubview(languageValueLabel)

        NSLayoutConstraint.activate([
            languageValueLabel.centerYAnchor.constraint(equalTo: languageRow.centerYAnchor),
            languageValueLabel.trailingAnchor.constraint(equalTo: languageRow.trailingAnchor, constant: -30)
        ])
    }

    private func findLanguageRow() -> UIView? {
        return stackView.arrangedSubviews.compactMap { section in
            section.subviews.first { $0.tag == 100 }
        }.first
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        
    }
    
    @objc private func deleteDataTapped() {
        let deleteDataVC = DeleteDataVC()
        navigationController?.pushViewController(deleteDataVC, animated: true)
    }

 
    @objc private func pinLockSwitchChanged(_ sender: UISwitch) {
        if let warningLabel = switchToWarningLabelMap[sender] {
            warningLabel.isHidden = !sender.isOn
        }

        changePinRow?.isHidden = !sender.isOn

        updateSpacerVisibility()

        if !sender.isOn {
            UserProfile.shared.isPasscodeEnabled = false
            UserProfile.shared.passcodeCode = "N/A"

            SaveUserProfileRequest.shared.saveUserProfile(in: self.view) { [weak self] result in
                switch result {
                case .success: break
                    
                case .failure(let error):
                    print("")
                }
            }
            
        } else if sender.isOn && !UserProfile.shared.isPasscodeEnabled {
          
            let loginVC = PinCodeLoginVC()
            loginVC.isFromSettings = true
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }

    @objc private func changePinTapped() {
        let loginVC = PinCodeLoginVC()
        loginVC.isFromSettings = true
        navigationController?.pushViewController(loginVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(goToProfileVC)
            )
            navigationItem.leftBarButtonItem = backButton
            navigationController?.navigationBar.tintColor = AppColors.color5
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: AppColors.color5
            ]
        
        changePinRow?.isHidden = !UserProfile.shared.isPasscodeEnabled
        
        if let pinLockSwitch = findSwitch(for: NSLocalizedString("pin_lock", comment: "")) {
            pinLockSwitch.isOn = UserProfile.shared.isPasscodeEnabled
        }

        
        updateSpacerVisibility()
        
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
        
        if let pinLockSwitch = findSwitch(for: NSLocalizedString("pin_lock", comment: "")) {
               pinLockSwitch.isOn = UserProfile.shared.isPasscodeEnabled
               
             
               if let warningLabel = switchToWarningLabelMap[pinLockSwitch] {
                   warningLabel.isHidden = !UserProfile.shared.isPasscodeEnabled
               }
           }

    
        for case let section as UIView in stackView.arrangedSubviews {
              for case let changePinRow as UIView in section.subviews
                  where changePinRow.subviews.compactMap({ $0 as? UILabel }).first?.text == NSLocalizedString("change_pin", comment: "") {
                  changePinRow.isHidden = !UserProfile.shared.isPasscodeEnabled
                  break
              }
          }

           updateSpacerVisibility()
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


