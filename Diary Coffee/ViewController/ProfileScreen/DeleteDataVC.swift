//
//  DeleteDataVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.12.2024.
//

import UIKit

class DeleteDataVC: UIViewController {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("delete_my_data", comment: "")
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]
        
        setupUI()

    }

    private func setupUI() {
        
        let myRecordsLabel = UILabel()
        myRecordsLabel.text = NSLocalizedString("my_records", comment: "")

        myRecordsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        myRecordsLabel.textColor = AppColors.color5
        view.addSubview(myRecordsLabel)
        
        
        let myRecordsContainer = createContainerView()
        view.addSubview(myRecordsContainer)
        
        let myRecordsDescription = createDescriptionLabel(
            text: NSLocalizedString("delete_my_data_description", comment: "")
        )

        myRecordsDescription.textAlignment = .justified
        myRecordsContainer.addSubview(myRecordsDescription)
        
        let deleteAllRecordsButton = createStyledButton(
            title: NSLocalizedString("delete_all_records", comment: ""))

        deleteAllRecordsButton.addTarget(self, action: #selector(navigateToDeleteAllRecordsVC), for: .touchUpInside) 
        view.addSubview(deleteAllRecordsButton)
        
       
        let accountLabel = UILabel()
        accountLabel.text = NSLocalizedString("account", comment: "")
        accountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        accountLabel.textColor = AppColors.color5
        view.addSubview(accountLabel)
        
       
        let accountContainer = createContainerView()
        view.addSubview(accountContainer)
        
        let accountDescription = createDescriptionLabel(
            text: NSLocalizedString("delete_my_account_description", comment: "")
        )

        accountDescription.textAlignment = .justified
        accountContainer.addSubview(accountDescription)
        
        let deleteAccountButton = createStyledButton(title: NSLocalizedString("delete_my_account", comment: ""))

        deleteAccountButton.addTarget(self, action: #selector(navigateToDeleteMyAccountVC), for: .touchUpInside)
        view.addSubview(deleteAccountButton)
        
       
        myRecordsLabel.translatesAutoresizingMaskIntoConstraints = false
        myRecordsContainer.translatesAutoresizingMaskIntoConstraints = false
        myRecordsDescription.translatesAutoresizingMaskIntoConstraints = false
        deleteAllRecordsButton.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountContainer.translatesAutoresizingMaskIntoConstraints = false
        accountDescription.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
            myRecordsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            myRecordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            
            myRecordsContainer.topAnchor.constraint(equalTo: myRecordsLabel.bottomAnchor, constant: 15),
            myRecordsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myRecordsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            myRecordsDescription.topAnchor.constraint(equalTo: myRecordsContainer.topAnchor, constant: 16),
            myRecordsDescription.leadingAnchor.constraint(equalTo: myRecordsContainer.leadingAnchor, constant: 16),
            myRecordsDescription.trailingAnchor.constraint(equalTo: myRecordsContainer.trailingAnchor, constant: -16),
            myRecordsDescription.bottomAnchor.constraint(equalTo: myRecordsContainer.bottomAnchor, constant: -16),
            
          
            deleteAllRecordsButton.topAnchor.constraint(equalTo: myRecordsContainer.bottomAnchor, constant: 16),
            deleteAllRecordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteAllRecordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteAllRecordsButton.heightAnchor.constraint(equalToConstant: 50),
            
            accountLabel.topAnchor.constraint(equalTo: deleteAllRecordsButton.bottomAnchor, constant: 35),
            accountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            
            accountContainer.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 15),
            accountContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            accountDescription.topAnchor.constraint(equalTo: accountContainer.topAnchor, constant: 16),
            accountDescription.leadingAnchor.constraint(equalTo: accountContainer.leadingAnchor, constant: 16),
            accountDescription.trailingAnchor.constraint(equalTo: accountContainer.trailingAnchor, constant: -16),
            accountDescription.bottomAnchor.constraint(equalTo: accountContainer.bottomAnchor, constant: -16),
            
            deleteAccountButton.topAnchor.constraint(equalTo: accountContainer.bottomAnchor, constant: 16),
            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createContainerView() -> UIView {
        let container = UIView()
        container.backgroundColor = AppColors.color1
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        return container
    }
    
    private func createDescriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppColors.color5
        label.numberOfLines = 0
        return label
    }
    
    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = AppColors.color2
        button.layer.cornerRadius = 10
        
       
        button.contentHorizontalAlignment = .center
        
       
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = AppColors.color3
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
        ])
        
        return button
    }

    @objc private func navigateToDeleteMyAccountVC() {
        let deleteMyAccountVC = DeleteMyAccountVC()
        navigationController?.pushViewController(deleteMyAccountVC, animated: true)
    }
    
    @objc private func navigateToDeleteAllRecordsVC() {
        let deleteAllRecordsVC = DeleteAllRecordsVC()
        navigationController?.pushViewController(deleteAllRecordsVC, animated: true)
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

