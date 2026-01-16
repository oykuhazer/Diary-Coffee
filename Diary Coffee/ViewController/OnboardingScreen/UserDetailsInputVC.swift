//
//  UserDetailsInputVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class UserDetailsInputVC: UIViewController, UITextFieldDelegate {

    let nextButton = UIButton(type: .system)
    let onboardingProgressBarView = OnboardingProgressBarView()

    let nameTextFieldView = NameTextFieldView()
    let birthdayButtonView = BirthdayButtonView()
    let birthdayDatePickerView = BirthdayDatePickerView()
    let birthdayImageView = UIImageView()
    
   let keyboardManager = KeyboardManager()
 
    
    var isDateSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationItem.hidesBackButton = true

        self.view.backgroundColor = AppColors.color1


        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.375)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)

        birthdayImageView.image = UIImage(named: "birthday")
        birthdayImageView.contentMode = .scaleAspectFit
        birthdayImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(birthdayImageView)


        let isIphone8 = UIScreen.main.bounds.height == 667

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "🎉 Let's Make It Special! 🎉"
        titleLabel.font = UIFont.boldSystemFont(ofSize: isIphone8 ? 22 : 24)
        titleLabel.textColor = AppColors.color2
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "What's your name? 🌟 And when's your birthday? 🎂"
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: isIphone8 ? 15 : 18)
        subtitleLabel.textColor = AppColors.color2
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        self.view.addSubview(subtitleLabel)


        nameTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameTextFieldView)

     
        keyboardManager.configureUppercaseKeyboard(for: nameTextFieldView.textField)
        keyboardManager.addTapToDismissKeyboard(to: view)
      
        birthdayButtonView.translatesAutoresizingMaskIntoConstraints = false
        birthdayButtonView.datePickerView = birthdayDatePickerView
        self.view.addSubview(birthdayButtonView)

     
        birthdayDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        birthdayDatePickerView.isHidden = true
        self.view.addSubview(birthdayDatePickerView)

     
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor =  AppColors.color4
        nextButton.setTitleColor(AppColors.color2, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)

       
        nameTextFieldView.textField.delegate = self
        nameTextFieldView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
       
        birthdayButtonView.setParentVC(vc: self)
        
    
        updateNextButtonState()


        let topConstant: CGFloat = (UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.height == 736) ? 60 : 100
        
        let birthdayImageViewTopConstant: CGFloat = (UIScreen.main.bounds.height == 667) ? 40 : 60
        
        let nameTextFieldViewTopConstant: CGFloat = (UIScreen.main.bounds.height == 667) ? 30 : 50
        
        NSLayoutConstraint.activate([
        
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
               onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
               onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topConstant),
               onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),

            birthdayImageView.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: birthdayImageViewTopConstant),
            birthdayImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            birthdayImageView.widthAnchor.constraint(equalToConstant: 150),
            birthdayImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: birthdayImageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),


            nameTextFieldView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: nameTextFieldViewTopConstant),
            nameTextFieldView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTextFieldView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nameTextFieldView.heightAnchor.constraint(equalToConstant: 50),

            birthdayButtonView.topAnchor.constraint(equalTo: nameTextFieldView.bottomAnchor, constant: 30),
            birthdayButtonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            birthdayButtonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            birthdayButtonView.heightAnchor.constraint(equalToConstant: 50),

            birthdayDatePickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            birthdayDatePickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            birthdayDatePickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            birthdayDatePickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            birthdayDatePickerView.heightAnchor.constraint(equalToConstant: 250),

            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.uppercased())
        textField.text = newText
        textField.sendActions(for: .editingChanged) 
        return false
    }


    func dateSelected() {
        isDateSelected = true
        updateNextButtonState()
    }

    func updateNextButtonState() {
        let isTextValid = nameTextFieldView.textField.text?.count ?? 0 >= 3

        if isTextValid && isDateSelected {
            nextButton.backgroundColor = AppColors.color3
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = AppColors.color4
            nextButton.isEnabled = false
        }
    }

    @objc func nextButtonTapped() {
         
          if let name = nameTextFieldView.textField.text, !name.isEmpty {
              UserProfile.shared.name = name
          }
          
          if isDateSelected {
              UserProfile.shared.birthDate = birthdayDatePickerView.selectedDate
          }

          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd-MM-yyyy"

          let formattedBirthDate = UserProfile.shared.birthDate != nil ? dateFormatter.string(from: UserProfile.shared.birthDate!) : "N/A"
          let formattedNotificationTime = UserProfile.shared.notificationTime != nil ? dateFormatter.string(from: UserProfile.shared.notificationTime!) : "N/A"

    
        let manageNotificationVC = ManageNotificationsVC()
        self.navigationController?.pushViewController(manageNotificationVC, animated: true)
      }




    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func skipButtonTapped() {
        
        let isTextValid = nameTextFieldView.textField.text?.count ?? 0 >= 3

        if isTextValid && isDateSelected {
         
            let manageNotificationVC = ManageNotificationsVC()
            self.navigationController?.pushViewController(manageNotificationVC, animated: true)
        } else {
           
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
