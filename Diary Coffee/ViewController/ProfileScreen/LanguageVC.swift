//
//  LanguageVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.12.2024.
//

import UIKit

class LanguageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let languages = [
        "English", "Spanish", "French", "German", "Portuguese",
        "Arabic", "Chinese", "Japanese", "Korean",
        "Hindi", "Indonesian", "Thai", "Vietnamese",
        "Italian", "Dutch", "Swedish", "Norwegian", "Finnish",
        "Danish", "Russian", "Polish", "Czech", "Afrikaans",
        "Brazilian", "Portuguese"
    ]
    
    var selectedLanguage: String = "English"
     var onLanguageSelected: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("done", comment: ""), for: .normal)

        button.backgroundColor = AppColors.color2
        button.setTitleColor(AppColors.color3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        view.backgroundColor = AppColors.color12


        let selectLanguageLabel = UILabel()
        selectLanguageLabel.text = NSLocalizedString("select_language", comment: "")
        selectLanguageLabel.textColor = AppColors.color5
        selectLanguageLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        selectLanguageLabel.textAlignment = .center
        selectLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectLanguageLabel)
        
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
        view.addSubview(tableView)
        
        view.addSubview(doneButton)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenSize = UIScreen.main.bounds.size

            if screenSize.width == 414 && screenSize.height == 736 { 
                doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            } else if screenSize.width == 375 && screenSize.height == 667 { 
                doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            } else {
                doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
            }
        }


        
        NSLayoutConstraint.activate([
           
            selectLanguageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
               selectLanguageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        
            tableView.topAnchor.constraint(equalTo: selectLanguageLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -30),
            
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        selectedLanguage = UserProfile.shared.language ?? "English"
    }

  
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
       
        UserProfile.shared.language = selectedLanguage
        
     
        SaveUserProfileRequest.shared.saveUserProfile(in: self.view) { [weak self] result in
            switch result {
            case .success:
              
                self?.onLanguageSelected?(self?.selectedLanguage ?? "English")
                self?.dismiss(animated: true, completion: nil)
                self?.dismiss(animated: true) {
                     self?.onDismiss?() 
                    }
            case .failure(_):
               
               print("")
            }
        }
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language
        cell.textLabel?.textColor = AppColors.color5
        cell.textLabel?.font = language == selectedLanguage ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = .clear
        
        if language == selectedLanguage {
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withTintColor(AppColors.color5, renderingMode: .alwaysOriginal))
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(checkmarkImageView)
            
            NSLayoutConstraint.activate([
                checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 2),
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 30),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        } else {
       
            cell.contentView.subviews.filter { $0 is UIImageView }.forEach { $0.removeFromSuperview() }
        }
        return cell
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          selectedLanguage = languages[indexPath.row]
          tableView.reloadData()
      }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
