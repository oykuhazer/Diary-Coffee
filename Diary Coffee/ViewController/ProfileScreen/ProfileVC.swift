//
//  ProfileVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 20.10.2024.
//

import UIKit

class ProfileVC: UIViewController, RecordsViewDelegate, FeaturesViewDelegate  {
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let premiumView = PremiumView()
    private let accountView = AccountView()
    private let recordsView = RecordsView()
    private let featuresView = FeaturesView()
    var journalEntriesResponse: ListJournalEntriesResponse?
    var userProfileInformation: GetUserProfileInformationResponse?

    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let safeAreaBackgroundView = CustomSafeAreaBackgroundView(backgroundColor: AppColors.color3)
        view.addSubview(safeAreaBackgroundView)
        view.sendSubviewToBack(safeAreaBackgroundView)

        view.backgroundColor = AppColors.color3
     
        setupNavigationBar()

      
        setupScrollView()
        setupContentView()

     
        setupPremiumView()
        setupAccountView()
        setupRecordsView()
        setupFeaturesView()
        fetchJournalEntries() 
        recordsView.delegate = self
        featuresView.delegate = self
        
        fetchUserProfileInformation()
 
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserProfileInformation()
        fetchJournalEntries()
    }

    
    private func fetchUserProfileInformation() {
        let userId = UserProfile.shared.uuid
        
        GetUserProfileInformationRequest.shared.fetchUserProfile(uuid: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.userProfileInformation = response
                   
                    self?.accountView.configure(with: response.userProfileInfo?.profilePicture)
                    
                case .failure(let error): break
                    
                }
            }
        }
    }

    func fetchJournalEntries() {
        let userId = UserProfile.shared.uuid
        
        ListJournalEntriesRequest.shared.listJournalEntries(userId: userId, journalDate: "", journalId: "", in: self.view) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                 
                    self?.journalEntriesResponse = response
                    
                   
                    if let journalEntries = response.journalEntriesInfoList {
                        let uniqueEntryCount = Set(journalEntries.map { $0.journalEntryId }).count
                       
                        self?.recordsView.updateRecordedDays(value: "\(uniqueEntryCount)")
                        
                      
                        let totalFileCount = journalEntries.flatMap { $0.coffeeMomentPhotoList }.count
                     
                        self?.recordsView.updatePhotos(value: "\(totalFileCount)")
                    }
                    
                case .failure(let error): break
                    
                }
            }
        }
    }


    private func setupNavigationBar() {
     
        navigationController?.navigationBar.barTintColor = AppColors.color3
        
       
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppColors.color5
        ]
       
        self.title = NSLocalizedString("my_info", comment: "")

        
        navigationItem.hidesBackButton = true
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.tintColor = AppColors.color1
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

        settingsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)

    
        let buttonStackView = UIStackView(arrangedSubviews: [settingsButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = -5
        buttonStackView.distribution = .fillProportionally

        
        let barButtonItem = UIBarButtonItem(customView: buttonStackView)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsVC()
        settingsVC.userProfileInformation = userProfileInformation
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
  
    private func setupScrollView() {
       
        view.addSubview(scrollView)
        
       
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentView() {
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupPremiumView() {
       
        contentView.addSubview(premiumView)
        premiumView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(premiumViewTapped))
        premiumView.addGestureRecognizer(tapGesture)
        premiumView.isUserInteractionEnabled = true

      
        NSLayoutConstraint.activate([
            premiumView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            premiumView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            premiumView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            premiumView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    @objc private func premiumViewTapped() {
        let premiumVC = PremiumVC()
        premiumVC.modalPresentationStyle = .pageSheet
        
        premiumVC.onPremiumAccess = { [weak self] in
            guard let self = self else { return }
            self.showPremiumAccessView()
        }
        
        present(premiumVC, animated: true, completion: nil)
    }

    private func showPremiumAccessView() {
        let premiumAccessView = PremiumAccessView(frame: view.bounds)
        view.addSubview(premiumAccessView)
        
        premiumAccessView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            premiumAccessView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            premiumAccessView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            premiumAccessView.topAnchor.constraint(equalTo: view.topAnchor),
            premiumAccessView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }



    private func setupAccountView() {
      
        contentView.addSubview(accountView)

        accountView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(accountViewTapped))
        accountView.addGestureRecognizer(tapGesture)
        accountView.isUserInteractionEnabled = true

        NSLayoutConstraint.activate([
            accountView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            accountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            accountView.topAnchor.constraint(equalTo: premiumView.bottomAnchor, constant: 80),
            accountView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }



    private func setupRecordsView() {
        contentView.addSubview(recordsView)

        recordsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recordsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recordsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recordsView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 40),
            recordsView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupFeaturesView() {
        contentView.addSubview(featuresView)

        featuresView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            featuresView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featuresView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            featuresView.topAnchor.constraint(equalTo: recordsView.bottomAnchor, constant: 65),
            featuresView.heightAnchor.constraint(equalToConstant: 60),
            featuresView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -180)
        ])
    }
    
    func showPhotoGallery() {
        let photoGalleryVC = PhotoGalleryVC()
        photoGalleryVC.journalEntriesResponse = journalEntriesResponse
        
        if journalEntriesResponse?.journalEntriesInfoList?.isEmpty ?? true {
          
            navigationController?.pushViewController(photoGalleryVC, animated: true)
        } else {
           
            navigationController?.pushViewController(photoGalleryVC, animated: true)
        }
    }

    
    @objc private func accountViewTapped() {
        let profileDetailVC = ProfileDetailVC()
        profileDetailVC.userProfileInformation = userProfileInformation
        navigationController?.pushViewController(profileDetailVC, animated: true)
    }

    
    func didTapFeaturesView() {
        let widgetsVC = WidgetsVC()
        
        widgetsVC.userProfile = userProfileInformation
        
        navigationController?.pushViewController(widgetsVC, animated: true)
    }

}

