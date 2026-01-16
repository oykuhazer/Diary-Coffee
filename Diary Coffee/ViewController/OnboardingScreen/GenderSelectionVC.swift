//
//  GenderSelectionVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 24.10.2024.
//

import UIKit

class GenderSelectionVC: UIViewController {

    let onboardingProgressBarView = OnboardingProgressBarView()
    let nextButton = UIButton(type: .system)
    let maleView = UIView()
    let femaleView = UIView()
    let otherView = UIView()
    let userProfile = UserProfile.shared
    var selectedGender: String?
    
    var genderSelected = false {
        didSet {
            updateNextButtonState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = AppColors.color1

    
        onboardingProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        onboardingProgressBarView.setProgress(0.33334)
        onboardingProgressBarView.setBackButtonAction(target: self, action: #selector(backButtonTapped))
        onboardingProgressBarView.setSkipButtonAction(target: self, action: #selector(skipButtonTapped))
        self.view.addSubview(onboardingProgressBarView)

        let titleLabel = UILabel()
        titleLabel.text = "Let’s Get to Know You Better!"
        titleLabel.textColor = AppColors.color2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Let us personalize your journey—choose your gender for a tailored experience!"
        subtitleLabel.textColor =  AppColors.color2
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subtitleLabel)

        setupGenderView(view: maleView, imageName: "male", labelText: "Male", tapAction: #selector(selectMale))
        setupGenderView(view: femaleView, imageName: "female", labelText: "Female", tapAction: #selector(selectFemale))
        setupGenderView(view: otherView, imageName: "other", labelText: "Other", tapAction: #selector(selectOther))

        let stackView = UIStackView(arrangedSubviews: [maleView, femaleView, otherView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        self.view.addSubview(stackView)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor =  AppColors.color4
        nextButton.setTitleColor(AppColors.color2, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.view.addSubview(nextButton)

        
        let topConstant: CGFloat = (UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.height == 736) ? 60 : 100
        
        NSLayoutConstraint.activate([
        
            onboardingProgressBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
               onboardingProgressBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
               onboardingProgressBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topConstant),
               onboardingProgressBarView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: onboardingProgressBarView.bottomAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),

            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 110),

            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupGenderView(view: UIView, imageName: String, labelText: String, tapAction: Selector) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color4
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = labelText
        label.textColor = AppColors.color2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 130),
            view.heightAnchor.constraint(equalToConstant: 110)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: tapAction)
        view.addGestureRecognizer(tapGesture)
    }

    @objc func selectMale() {
           resetGenderSelection()
        maleView.backgroundColor = AppColors.color3
           selectedGender = "Male"
           genderSelected = true
       }

       @objc func selectFemale() {
           resetGenderSelection()
           femaleView.backgroundColor = AppColors.color3
           selectedGender = "Female"
           genderSelected = true
       }

       @objc func selectOther() {
           resetGenderSelection()
           otherView.backgroundColor = AppColors.color3
           selectedGender = "Other"
           genderSelected = true
       }

    func resetGenderSelection() {
        maleView.backgroundColor = AppColors.color4
        femaleView.backgroundColor = AppColors.color4
        otherView.backgroundColor = AppColors.color4
        genderSelected = false
    }

    
    func updateNextButtonState() {
        if genderSelected {
            nextButton.backgroundColor = AppColors.color3
        } else {
            nextButton.backgroundColor = AppColors.color4
        }
    }

 
    @objc func nextButtonTapped() {
        if !genderSelected {

            return
        }

        if let gender = selectedGender {
            UserProfile.shared.gender = gender
        }
        

        
        let userDetailsVC = UserDetailsInputVC()
        self.navigationController?.pushViewController(userDetailsVC, animated: true)
    }


    @objc func backButtonTapped() {
       
        let onboardingVC = OnboardingIntroVC()
        self.navigationController?.pushViewController(onboardingVC, animated: true)
    }

    @objc func skipButtonTapped() {
        
        if genderSelected {
            let userDetailsVC = UserDetailsInputVC()
            self.navigationController?.pushViewController(userDetailsVC, animated: true)
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
