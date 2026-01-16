//
//  ProfileDetailVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.11.2024.
//

import UIKit

class ProfileDetailVC: UIViewController {

    var userProfileInformation: GetUserProfileInformationResponse?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("account", comment: "")
              
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let birthDateString = UserProfile.shared.birthDate.flatMap {
            dateFormatter.string(from: $0)
        } ?? NSLocalizedString("not_set", comment: "")

        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
       
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let profilePictureView = ProfilePictureView()
           profilePictureView.translatesAutoresizingMaskIntoConstraints = false
           contentStackView.addSubview(profilePictureView)

           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePictureTapped))
           profilePictureView.addGestureRecognizer(tapGesture)
           profilePictureView.isUserInteractionEnabled = true
        
        
        if let profilePictureURL = userProfileInformation?.userProfileInfo?.profilePicture {
                   profilePictureView.updateProfileImage(url: profilePictureURL)
               } else {
                 
               }
        
        let profileInformationView = ProfileInformationView()
        profileInformationView.translatesAutoresizingMaskIntoConstraints = false
        profileInformationView.addProfileItem(
            iconName: "person.text.rectangle.fill",
            title: NSLocalizedString("change_name", comment: ""),
            value: UserProfile.shared.name ?? "",
            actionIconName: "chevron.right"
        ) { [weak self] in
            guard let self = self else { return }
            

            let profileNameChangeView = ProfileNameChangeView(frame: self.view.bounds)
            profileNameChangeView.alpha = 0
          
            profileNameChangeView.onDismiss = { [weak self] in
                guard let self = self else { return }

              
                let recordActionView = RequiredActionView(frame: self.view.bounds)
                recordActionView.configure(
                    icon: UIImage(named: "success"),
                    message: NSLocalizedString("info_updated", comment: "")
                )
                self.view.addSubview(recordActionView)

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    recordActionView.removeFromSuperview()
                }
            }

            self.view.addSubview(profileNameChangeView)
            UIView.animate(withDuration: 0.3) {
                profileNameChangeView.alpha = 1
            }
        }
        
        profileInformationView.addProfileItem(
            iconName: "birthday.cake.fill",
            title: NSLocalizedString("change_birthday", comment: ""),
            value: birthDateString,
            actionIconName: "chevron.right"
        ) { [weak self] in
            guard let self = self else { return }
            
          
            let birthdayChangeView = ProfileBirthdayChangeView(frame: self.view.bounds)
            birthdayChangeView.alpha = 0 
         
            if let birthDate = UserProfile.shared.birthDate {
                birthdayChangeView.configure(with: birthDate)
            }

            birthdayChangeView.onDismiss = { [weak self] in
                guard let self = self else { return }

                let recordActionView = RequiredActionView(frame: self.view.bounds)
                recordActionView.configure(
                    icon: UIImage(named: "success"),
                    message: NSLocalizedString("info_updated", comment: "")
                )
                self.view.addSubview(recordActionView)

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    recordActionView.removeFromSuperview()
                }
            }

        
            self.view.addSubview(birthdayChangeView)
            UIView.animate(withDuration: 0.3) {
                birthdayChangeView.alpha = 1
            }
        }

        profileInformationView.addProfileItem(
            iconName: "figure.dress.line.vertical.figure",
            title: NSLocalizedString("change_gender", comment: ""),
            value: UserProfile.shared.gender ?? "",
            actionIconName: "chevron.right"
        ) { [weak self] in
            guard let self = self else { return }

            let genderChangeView = ProfileGenderChangeView(frame: self.view.bounds)
            genderChangeView.alpha = 0

            
            genderChangeView.configure(selectedGender: UserProfile.shared.gender)

           
            genderChangeView.onDismiss = { [weak self] in
                guard let self = self else { return }

              
                let recordActionView = RequiredActionView(frame: self.view.bounds)
                recordActionView.configure(
                    icon: UIImage(named: "success"),
                    message: NSLocalizedString("info_updated", comment: "")
                )
                self.view.addSubview(recordActionView)

            
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    recordActionView.removeFromSuperview()
                }
            }

            self.view.addSubview(genderChangeView)
            
            UIView.animate(withDuration: 0.3) {
                genderChangeView.alpha = 1
            }
        }
        
        contentStackView.addSubview(profileInformationView)
        
        NSLayoutConstraint.activate([
            profilePictureView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 30),
            profilePictureView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor),
            profilePictureView.heightAnchor.constraint(equalToConstant: 180),
            profilePictureView.widthAnchor.constraint(equalToConstant: 180),
            
            profileInformationView.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 20),
            profileInformationView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16),
            profileInformationView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -16),
            profileInformationView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -20)
        ])
        
        handleStyleSelection()
        
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(profilePictureUpdated(_:)),
               name: .profilePictureChanged,
               object: nil
           )   
        
    }

    @objc private func profilePictureUpdated(_ notification: Notification) {
       
            let recordActionView = RequiredActionView(frame: self.view.bounds)
            recordActionView.configure(
                icon: UIImage(named: "success"),
                message: NSLocalizedString("profile_photo_updated", comment: "")
            )
            self.view.addSubview(recordActionView)

        
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3) {
                    recordActionView.alpha = 0
                } completion: { _ in
                    recordActionView.removeFromSuperview()
                }
            }
        }
  
    
    @objc private func profilePictureTapped() {
        let profilePhotoChangeView = ChangeProfilePhotoView()
        profilePhotoChangeView.show(in: self.view)
        handleStyleSelection()
    }

    private func handleStyleSelection() {
        guard let styleSelection = userProfileInformation?.userProfileInfo?.styleSelection else {
           
            return
        }

        if styleSelection.contains("ClassicSet") {
            EmotionSetRequest.shared.uploadEmotionSet(emotionSet: styleSelection) { result in
                switch result {
                case .success(let response):
                    guard let images = response.emotionSet?.images else {
                       
                        return
                    }
                    DispatchQueue.main.async {
                        if let changePhotoView = self.view.subviews.compactMap({ $0 as? ChangeProfilePhotoView }).first {
                            changePhotoView.updateImages(with: images)
                        }
                    }
                case .failure(let error): break
                    
                }
            }
        } else {
            PrimeEmotionSetRequest.shared.uploadPrimeEmotionSet(primeEmotionSet: styleSelection, in: view) { result in
                switch result {
                case .success(let response):
                    guard let images = response.primeEmotionSet?.images else {
                       
                        return
                    }
                    DispatchQueue.main.async {
                        if let changePhotoView = self.view.subviews.compactMap({ $0 as? ChangeProfilePhotoView }).first {
                            changePhotoView.updateImages(with: images)
                        }
                    }
                case .failure(let error): break
                    
                }
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

