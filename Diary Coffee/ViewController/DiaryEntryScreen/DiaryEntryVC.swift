//
//  DiaryEntryVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 29.10.2024.
//

import UIKit

protocol DiaryEntryDelegate: AnyObject {
    func didSaveEntrySuccessfully()
}

class DiaryEntryVC: UIViewController {
    
   
    
    weak var delegate: DiaryEntryDelegate?
    var selectedDate: String?
    var selectedMoodIndex: Int?
    private var moodSelectorView: MoodSelectorView!
    private var coffeeMemorySelectorView: CoffeeMemorySelectorView!
    private var coffeeTypeSelectorView: CoffeeTypeSelectorView!
    private var noteView: NoteView!
    private var photoView: PhotoView!
     private var stickerView: StickerView!
    private var dateSelectorButton: DateSelectorButton!
    var userProfileInformation: GetUserProfileInformationResponse?
    var journalEntriesResponse: ListJournalEntriesResponse?
    var selectedJournalEntryId: String?
     var isFromEditButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    
        let safeAreaBackgroundView = CustomSafeAreaBackgroundView(backgroundColor: AppColors.color3)
        view.addSubview(safeAreaBackgroundView)
        view.sendSubviewToBack(safeAreaBackgroundView)
        
        view.backgroundColor = AppColors.color3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        dateSelectorButton = DateSelectorButton(isDayMonthYearFormat: true, showYearMonthSelectorView: false)
        dateSelectorButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateSelectorButton)
        
        NSLayoutConstraint.activate([
            dateSelectorButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateSelectorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateSelectorButton.widthAnchor.constraint(equalToConstant: 300)
        ])

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = AppColors.color2
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: dateSelectorButton.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: dateSelectorButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60) 
        ])

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        moodSelectorView = MoodSelectorView()
        moodSelectorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moodSelectorView)
        
        
        DispatchQueue.main.async {
            if let selectedMoodIndex = self.selectedMoodIndex {
                
                self.moodSelectorView.setSelectedMood(at: selectedMoodIndex)
            } else {
               
            }
        }

        let screenWidth = UIScreen.main.bounds.width
          let horizontalPadding: CGFloat = screenWidth <= 375 ? 10 : 20
        
        NSLayoutConstraint.activate([
            moodSelectorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moodSelectorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            moodSelectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            moodSelectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            moodSelectorView.heightAnchor.constraint(equalToConstant: 120)
        ])

       coffeeMemorySelectorView = CoffeeMemorySelectorView()
        coffeeMemorySelectorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coffeeMemorySelectorView)
        
        NSLayoutConstraint.activate([
            coffeeMemorySelectorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coffeeMemorySelectorView.topAnchor.constraint(equalTo: moodSelectorView.bottomAnchor, constant: 20),
            coffeeMemorySelectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            coffeeMemorySelectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            coffeeMemorySelectorView.heightAnchor.constraint(equalToConstant: 420)
        ])

        coffeeTypeSelectorView = CoffeeTypeSelectorView()
        coffeeTypeSelectorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coffeeTypeSelectorView)
        
        NSLayoutConstraint.activate([
            coffeeTypeSelectorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coffeeTypeSelectorView.topAnchor.constraint(equalTo: coffeeMemorySelectorView.bottomAnchor, constant: 20),
            coffeeTypeSelectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            coffeeTypeSelectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            coffeeTypeSelectorView.heightAnchor.constraint(equalToConstant: 650)
        ])

           noteView = NoteView()
           noteView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(noteView)
        
        let noteViewHeightConstraint = noteView.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([
            noteView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noteView.topAnchor.constraint(equalTo: coffeeTypeSelectorView.bottomAnchor, constant: 20),
            noteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            noteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            noteViewHeightConstraint
        ])
        
        noteView.onHeightChange = { newHeight in
            noteViewHeightConstraint.constant = newHeight
            self.view.layoutIfNeeded()
        }

        photoView = PhotoView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoView.topAnchor.constraint(equalTo: noteView.bottomAnchor, constant: 20),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            photoView.heightAnchor.constraint(equalToConstant: 200)
        ])

        stickerView = StickerView()
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stickerView)
        
        NSLayoutConstraint.activate([
            stickerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stickerView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 20),
            stickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            stickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            stickerView.heightAnchor.constraint(equalToConstant: 200),
            stickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])
        
        let doneButtonView = DoneButtonView()
        doneButtonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButtonView)
        
        let bottomConstant: CGFloat
       

        if (UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 667) ||
           (UIScreen.main.bounds.width == 414 && UIScreen.main.bounds.height == 736) {
          
            bottomConstant = 40
        } else {
            bottomConstant = 60
        }


        NSLayoutConstraint.activate([
            doneButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doneButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomConstant),
            doneButtonView.heightAnchor.constraint(equalToConstant: 130)
        ])

  
        if let dateString = selectedDate {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd"
              
              if let date = dateFormatter.date(from: dateString) {
                  dateSelectorButton.updateDateTitle(with: date)
              } else {
                
              }
          }
        
        fetchUserProfileInformation()
        fetchJournalEntries()
        
        
        doneButtonView.onDoneTapped = { [weak self] in
            guard let self = self else { return }

            let journalEntryDate = self.dateSelectorButton.getFormattedDate()

            if let journalEntries = self.journalEntriesResponse?.journalEntriesInfoList,
               journalEntries.contains(where: { $0.journalEntryDate == journalEntryDate }),
               self.userProfileInformation?.userProfileInfo?.premium == false {
                
                let premiumVC = PremiumVC()
                premiumVC.modalPresentationStyle = .pageSheet
                self.present(premiumVC, animated: true, completion: nil)
                
                premiumVC.onPremiumAccess = {
                    self.fetchUserProfileInformation()
                    self.showPremiumAccessView()
                }
                return
            }

            if let journalEntries = self.journalEntriesResponse?.journalEntriesInfoList,
               self.userProfileInformation?.userProfileInfo?.premium == true {
                
                let matchingEntriesCount = journalEntries.filter { $0.journalEntryDate == journalEntryDate }.count
                
                if matchingEntriesCount >= 3 {
                  
                    let message = NSLocalizedString("daily_max_limit", comment: "")
                    self.showRecordActionView(message: message, icon: UIImage(named: "signal"))

                    return
                }
            }

            self.handleDoneButtonTapped()
        }

        
    }

    
    func showPremiumAccessView() {
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
    
    
    func fetchJournalEntries() {
       
        let userId = UserProfile.shared.uuid

        ListJournalEntriesRequest.shared.listJournalEntries(userId: userId, journalDate: "", journalId: "", in: self.view) { [weak self] result in
          
                switch result {
                case .success(let response):
                  
                self?.journalEntriesResponse = response
 
                case .failure(let error): break
                   
                }
        }
    }
    
    private func fetchUserProfileInformation() {
        let userId = UserProfile.shared.uuid
        
        GetUserProfileInformationRequest.shared.fetchUserProfile(uuid: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                 
                    self?.userProfileInformation = response
                    self?.checkAndHandleStyleSelection(response: response)
                    
                    if let photoView = self?.photoView {
                        photoView.configure(with: response)
                    }
                    
                case .failure(let error): break
                   
                }
            }
        }
    }

    func checkAndHandleStyleSelection(response: GetUserProfileInformationResponse) {
        guard let userProfileInfo = response.userProfileInfo else {
          
            return
        }

        guard let styleSelection = userProfileInfo.styleSelection else {
           
            return
        }

        let handleImages = { [weak self] (images: [String]) in
            DispatchQueue.main.async {
                guard let self = self else {
                   
                    return
                }
                guard let moodSelectorView = self.moodSelectorView else {
                    
                    return
                }
                moodSelectorView.configure(with: images) {
                    if let selectedMoodIndex = self.selectedMoodIndex {
                       
                        moodSelectorView.setSelectedMood(at: selectedMoodIndex)
                    } else {
                        
                    }
                }
            }
        }

        if styleSelection.hasPrefix("ClassicSet") {
            EmotionSetRequest.shared.uploadEmotionSet(emotionSet: styleSelection) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                  
                    if let emotionSet = response.emotionSet {
                        let targetOrder = ["smile", "kissing", "wow", "sleep", "sad", "angry"]
                        let sortedImages = self.sortImages(emotionSet.images, targetOrder: targetOrder)
                        handleImages(sortedImages)
                    }
                case .failure(let error): break
                    
                }
            }
        } else {
            PrimeEmotionSetRequest.shared.uploadPrimeEmotionSet(primeEmotionSet: styleSelection, in: view) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                  
                    if let primeEmotionSet = response.primeEmotionSet {
                        let targetOrder = ["smile", "kissing", "wow", "sleep", "sad", "angry"]
                        let sortedImages = self.sortImages(primeEmotionSet.images, targetOrder: targetOrder)
                        handleImages(sortedImages)
                    }
                case .failure(let error): break
                   
                }
            }
        }
    }


    private func sortImages(_ images: [String], targetOrder: [String]) -> [String] {
        return images.sorted { image1, image2 in
            let name1 = image1.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
            let name2 = image2.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
            let index1 = targetOrder.firstIndex(of: name1) ?? Int.max
            let index2 = targetOrder.firstIndex(of: name2) ?? Int.max
            return index1 < index2
        }
    }


    private func handleDoneButtonTapped() {
           let uuid = UserProfile.shared.uuid
           let journalEntryId = UUID().uuidString
           let journalEntryDate = dateSelectorButton.getFormattedDate()
           
        guard let coffeeMoodType = moodSelectorView.getSelectedMood() else {
            let message = NSLocalizedString("record_mood", comment: "")
            showRecordActionView(message: message, icon: UIImage(named: "signal"))
            return
        }

           
        guard let coffeeMomentType = coffeeMemorySelectorView.getSelectedMemory() else {
            let message = NSLocalizedString("record_coffee_moment", comment: "")
            showRecordActionView(message: message, icon: UIImage(named: "signal"))
            return
        }

           
        guard let coffeeType = coffeeTypeSelectorView.getSelectedCoffeeType() else {
            let message = NSLocalizedString("record_coffee_type", comment: "")
            showRecordActionView(message: message, icon: UIImage(named: "signal"))
            return
        }

           
           let coffeeJournalText = noteView.text
           
           let coffeeMomentPhotoList = photoView.getUploadedPhotos().map { photo in
               return [
                   "FileName": photo.fileName,
                   "DocumentGUID": photo.documentGUID,
                   "DocumentCategory": photo.documentCategory,
                   "base64Data": photo.base64String
               ]
           }
           
           let coffeeMomentStickerList = stickerView.getSelectedStickers()
           
           SaveJournalEntryRequest.shared.saveJournalEntry(
               userId: uuid,
               journalEntryId: journalEntryId,
               journalEntryDate: journalEntryDate,
               coffeeMoodType: coffeeMoodType,
               coffeeMomentType: coffeeMomentType,
               coffeeType: coffeeType,
               coffeeJournalText: coffeeJournalText,
               coffeeMomentPhotoList: coffeeMomentPhotoList,
               coffeeMomentStickerList: coffeeMomentStickerList
           ) { [weak self] result in
               switch result {
               case .success(let response):
                  
                   DispatchQueue.main.async {
                       let customTabBarController = CustomTabBarController()
                       customTabBarController.selectedIndex = 0
                       customTabBarController.modalPresentationStyle = .fullScreen
                       UIApplication.shared.keyWindow?.rootViewController = customTabBarController
                       
                       
                       if let navigationController = customTabBarController.viewControllers?[0] as? UINavigationController,
                          let calendarVC = navigationController.viewControllers.first as? CalendarVC {
                           self?.delegate = calendarVC
                           self?.delegate?.didSaveEntrySuccessfully()
                       }
                       
                       UIApplication.shared.keyWindow?.makeKeyAndVisible()
                   }
               case .failure(let error): break
                   
               }
           }
       }

   
    private func showRecordActionView(message: String, icon: UIImage?) {
      
        let requiredActionView = RequiredActionView(frame: view.bounds)
        requiredActionView.configure(icon: icon, message: message)
        
       
        var adjustedFrame = requiredActionView.frame
        adjustedFrame.origin.y += 20
        requiredActionView.frame = adjustedFrame
        
        view.addSubview(requiredActionView)
        
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            requiredActionView.removeFromSuperview()
        }
    }

    @objc private func backButtonTapped() {
        if coffeeMemorySelectorView.isMemorySelected ||
           coffeeTypeSelectorView.isTypeSelected ||
           noteView.hasText ||
           photoView.hasPhotos ||
           stickerView.hasStickers {

            let alertView = MainAlertView(frame: self.view.bounds)
            alertView.configure(
                title: NSLocalizedString("unsaved_changes", comment: ""),
                message: NSLocalizedString("confirm_exit", comment: ""),
                cancelAction: { alertView.removeFromSuperview() },
                actionButtonTitle: NSLocalizedString("exit", comment: ""),
                actionHandler: {
                    if self.navigationController != nil {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            )
            self.view.addSubview(alertView)
        } else {
            if navigationController != nil {
             
                navigationController?.popViewController(animated: true)
            } else {
               
                dismiss(animated: true)
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       
        navigationController?.setNavigationBarHidden(true, animated: true)

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

        navigationController?.setNavigationBarHidden(false, animated: true)


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

