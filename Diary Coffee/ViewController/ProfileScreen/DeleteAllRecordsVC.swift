//
//  DeleteAllRecordsVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.12.2024.
//

import UIKit

class DeleteAllRecordsVC: UIViewController {

    private let deleteButton = UIButton(type: .system)
    private let checkboxButton = UIButton(type: .system)
    private var indicatorView: IndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.color6

        navigationItem.title = NSLocalizedString("delete_all_records", comment: "")

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]

        setupUI()
    }

    private func setupUI() {
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("are_you_sure", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = AppColors.color5
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

       
        let descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("delete_all_records_description", comment: "")

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        descriptionLabel.textColor = AppColors.color5
        descriptionLabel.textAlignment = .justified
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let agreementLabel = UILabel()
        agreementLabel.text = NSLocalizedString("read_and_agree", comment: "")
        agreementLabel.font = UIFont.systemFont(ofSize: 14)
        agreementLabel.numberOfLines = 0
        agreementLabel.textColor = AppColors.color5
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false

        checkboxButton.setImage(UIImage(systemName: "square.fill"), for: .normal)
        checkboxButton.tintColor = .white
        checkboxButton.backgroundColor = .white
        checkboxButton.layer.cornerRadius = 5
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

      
        deleteButton.setTitle(NSLocalizedString("delete_all_records", comment: ""), for: .normal)
        deleteButton.setTitleColor(AppColors.color3, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        deleteButton.backgroundColor = AppColors.color2
        deleteButton.layer.cornerRadius = 10
        deleteButton.isEnabled = false
        deleteButton.alpha = 0.5
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
       deleteButton.addTarget(self, action: #selector(deleteAllEntry), for: .touchUpInside)
       
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(AppColors.color1, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cancelButton.backgroundColor = AppColors.color2
        cancelButton.layer.cornerRadius = 10
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(checkboxButton)
        view.addSubview(agreementLabel)
        view.addSubview(deleteButton)
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            checkboxButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            checkboxButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            agreementLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
            agreementLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 20),
            agreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),

            deleteButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupIndicatorView()
    }

    
    private func setupIndicatorView() {
            indicatorView = IndicatorView()
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.indicatorColor = AppColors.color5
            view.addSubview(indicatorView)
            
        
            NSLayoutConstraint.activate([
                indicatorView.topAnchor.constraint(equalTo: view.topAnchor),
                indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                indicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
    @objc private func toggleCheckbox() {
        if checkboxButton.image(for: .normal) == UIImage(systemName: "square.fill") {
            checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkboxButton.tintColor = AppColors.color6
            deleteButton.isEnabled = true
            deleteButton.alpha = 1.0
        } else {
            checkboxButton.setImage(UIImage(systemName: "square.fill"), for: .normal)
            checkboxButton.tintColor = .white
            deleteButton.isEnabled = false
            deleteButton.alpha = 0.5
        }
    }
   
   
    @objc private func deleteAllEntry() {
        self.indicatorView.show()

        let userId = UserProfile.shared.uuid
        DeleteJournalEntryRequest.shared.deleteJournalEntry(userId: userId, journalEntryId: "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.indicatorView.hide()

                    if response.resultCode == 200 {
                        let settingsVC = SettingsVC()
                        settingsVC.shouldShowSuccessMessage = true
                        self.navigationController?.pushViewController(settingsVC, animated: true)
                    } else {
                        self.indicatorView.hide()
                    }
                case .failure(let error):
                    self.indicatorView.hide()
                   
                }
            }
        }
    }

   
    @objc private func cancelAction() {
      
        checkboxButton.setImage(UIImage(systemName: "square.fill"), for: .normal)
        checkboxButton.tintColor = .white
        
        deleteButton.isEnabled = false
        deleteButton.alpha = 0.5
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
