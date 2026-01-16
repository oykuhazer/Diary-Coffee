//
//  CoffeeAnalysisViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 13.10.2024.
//


import UIKit

class AnalysisVC: UIViewController, MomentStatusViewDelegate, CoffeeStatusViewDelegate, MoodSelectionViewDelegate, CoffeeStatusByMoodDelegate, YearMonthPickerViewDelegate, CoffeeAchievementLockViewDelegate, PremiumSubscribeViewDelegate, UIScrollViewDelegate   {

   let scrollView = UIScrollView()
    var journalEntriesResponse: ListJournalEntriesResponse?
    var userProfileInformation: GetUserProfileInformationResponse?
    let coffeeDailyStatusView = CoffeeDailyStatusView()
    let coffeeMoodFlowView = CoffeeMoodFlowView()
    let coffeeMoodScoreView = CoffeeMoodScoreView()
    let moodStatusView = MoodStatusView()
    let momentStatusView = MomentStatusView()
     let coffeeAchievementLockView = CoffeeAchievementLockView()
    let coffeeStatusView = CoffeeStatusView()
    let coffeeStatusByMoodView = CoffeeStatusByMood()
    var moodSelectionView: MoodSelectionView?
    var yearMonthPickerView: YearMonthPickerView?
    let coffeeTrackerView = CoffeeTrackerView()
    let coffeeTrackerYearView = CoffeeTrackerYearView()
    let yearMonthSegmentControl = YearMonthSegmentControl()
    var dates: [String] = []
   var selectedYearDates: [String] = []
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
   var selectedMonth: Int = Calendar.current.component(.month, from: Date())
   let premiumAnalysisView = PremiumAnalysisView()
   let premiumSubscribeView = PremiumSubscribeView()
   var isPremiumUser: Bool = false

   var moodStatusTopConstraint: NSLayoutConstraint?
   private var isDataLoaded = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigationItem.title = NSLocalizedString("report", comment: "")
        
       navigationController?.navigationBar.barTintColor = AppColors.color3
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.color5]

           navigationItem.hidesBackButton = true
       
       coffeeDailyStatusView.configureWithEntries(entries: [])
       coffeeMoodScoreView.configure(entries: [])
        moodStatusView.configureWithEntries([])
       momentStatusView.configureWithEntries([])
       coffeeStatusView.configureWithEntries([])
        fetchJournalEntries()
        
        setupUIComponents()
        
        momentStatusView.delegate = self
        coffeeStatusView.delegate = self
        coffeeStatusByMoodView.delegate = self
        moodSelectionView?.delegate = self
       coffeeAchievementLockView.delegate = self
      
       
       coffeeTrackerView.goButtonAction = { [weak self] in
           guard let self = self else { return }

           let correctYear = self.yearMonthSegmentControl.selectedYear

           let filteredDates = self.selectedYearDates.filter { $0.contains("\(correctYear)") }

           let coffeeTrackerAnalysisVC = CoffeeTrackerAnalysisVC()
           coffeeTrackerAnalysisVC.selectedYear = correctYear
           coffeeTrackerAnalysisVC.dates = filteredDates

           self.navigationController?.pushViewController(coffeeTrackerAnalysisVC, animated: true)
       }

           view.addSubview(premiumSubscribeView)
           premiumSubscribeView.translatesAutoresizingMaskIntoConstraints = false
           premiumSubscribeView.isHidden = true
             premiumSubscribeView.delegate = self
           NSLayoutConstraint.activate([
               premiumSubscribeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               premiumSubscribeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               premiumSubscribeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50),
               premiumSubscribeView.heightAnchor.constraint(equalToConstant: 280)
           ])
       
       scrollView.delegate = self
       
       fetchUserProfileInformation()
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       fetchUserProfileInformation()
       fetchJournalEntries()
   }

   override func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)

    
       journalEntriesResponse = nil
       userProfileInformation = nil
       dates.removeAll()
       selectedYearDates.removeAll()

      
       coffeeDailyStatusView.configureWithEntries(entries: [])
       coffeeMoodScoreView.configure(entries: [])
       coffeeMoodScoreView.averageLengthValueLabel.text = "0"
       coffeeMoodScoreView.exercisesValueLabel.text = "0"
       coffeeMoodScoreView.updateMoodCounts(entries: [])
       moodStatusView.configureWithEntries([])
       momentStatusView.configureWithEntries([])
       coffeeStatusView.configureWithEntries([])
       coffeeMoodFlowView.configureWithEntries(entries: [])
   }



   func setupUIComponents() {
       
       let safeAreaBackgroundView = CustomSafeAreaBackgroundView(backgroundColor: AppColors.color3)
       view.addSubview(safeAreaBackgroundView)
       view.sendSubviewToBack(safeAreaBackgroundView)
       
      
       let contentView = UIView()
       
       scrollView.translatesAutoresizingMaskIntoConstraints = false
       scrollView.showsVerticalScrollIndicator = false
       scrollView.showsHorizontalScrollIndicator = false
       contentView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(scrollView)
       scrollView.addSubview(contentView)
       scrollView.backgroundColor = AppColors.color3
       contentView.backgroundColor = AppColors.color3
       
       
       yearMonthSegmentControl.onYearButtonTap = { [weak self] in
           self?.showYearPicker()
       }
       
       
       contentView.addSubview(yearMonthSegmentControl)
       yearMonthSegmentControl.translatesAutoresizingMaskIntoConstraints = false
       
       coffeeDailyStatusView.translatesAutoresizingMaskIntoConstraints = false
       coffeeMoodFlowView.translatesAutoresizingMaskIntoConstraints = false
       coffeeMoodScoreView.translatesAutoresizingMaskIntoConstraints = false
      coffeeAchievementLockView.translatesAutoresizingMaskIntoConstraints = false
       moodStatusView.translatesAutoresizingMaskIntoConstraints = false
       momentStatusView.translatesAutoresizingMaskIntoConstraints = false
       coffeeStatusView.translatesAutoresizingMaskIntoConstraints = false
       coffeeStatusByMoodView.translatesAutoresizingMaskIntoConstraints = false
       coffeeTrackerView.translatesAutoresizingMaskIntoConstraints = false
      premiumAnalysisView.translatesAutoresizingMaskIntoConstraints = false

       contentView.addSubview(coffeeDailyStatusView)
       contentView.addSubview(coffeeMoodFlowView)
       contentView.addSubview(coffeeMoodScoreView)
       contentView.addSubview(moodStatusView)
      contentView.addSubview(coffeeAchievementLockView)
       contentView.addSubview(coffeeTrackerView)
       contentView.addSubview(momentStatusView)
       contentView.addSubview(coffeeStatusView)
       contentView.addSubview(coffeeStatusByMoodView)
       
      contentView.addSubview(premiumAnalysisView)

       coffeeTrackerView.goButtonAction = { [weak self] in
           guard let self = self else { return }

         
           let coffeeTrackerAnalysisVC = CoffeeTrackerAnalysisVC()
           coffeeTrackerAnalysisVC.selectedYear = self.yearMonthPickerView?.selectedYear
           coffeeTrackerAnalysisVC.dates = self.dates

           self.navigationController?.pushViewController(coffeeTrackerAnalysisVC, animated: true)
       }

      let coffeeTrackerHeight: CGFloat

      if UIScreen.main.nativeBounds.height == 2436 {
          coffeeTrackerHeight = 390
      } else if UIScreen.main.nativeBounds.height == 1334 || UIScreen.main.nativeBounds.height == 1920 {
          coffeeTrackerHeight = 390
      } else {
          coffeeTrackerHeight = 410 
      }
      
       NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           
           contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -70),
           contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
       ])
       
       NSLayoutConstraint.activate([
           
           yearMonthSegmentControl.topAnchor.constraint(equalTo: contentView.topAnchor,constant: -50),
                   yearMonthSegmentControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                   yearMonthSegmentControl.widthAnchor.constraint(equalToConstant: 250),
                   yearMonthSegmentControl.heightAnchor.constraint(equalToConstant: 110),
           
           coffeeDailyStatusView.topAnchor.constraint(equalTo: yearMonthSegmentControl.bottomAnchor, constant: 30),
           coffeeDailyStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           coffeeDailyStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           coffeeDailyStatusView.heightAnchor.constraint(equalToConstant: 250),
           
           coffeeMoodFlowView.topAnchor.constraint(equalTo: coffeeDailyStatusView.bottomAnchor, constant: 20),
                  coffeeMoodFlowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                  coffeeMoodFlowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                  coffeeMoodFlowView.heightAnchor.constraint(equalToConstant: 330),
           
           coffeeMoodScoreView.topAnchor.constraint(equalTo: coffeeMoodFlowView.bottomAnchor, constant: 20),
           coffeeMoodScoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
           coffeeMoodScoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
           coffeeMoodScoreView.heightAnchor.constraint(equalToConstant: 450),
              
           premiumAnalysisView.topAnchor.constraint(equalTo: coffeeMoodScoreView.bottomAnchor, constant: 20),
           premiumAnalysisView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           premiumAnalysisView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           premiumAnalysisView.heightAnchor.constraint(equalToConstant: 140),
           
              moodStatusView.topAnchor.constraint(equalTo: premiumAnalysisView.bottomAnchor, constant: 20),
              moodStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
              moodStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
              moodStatusView.heightAnchor.constraint(equalToConstant: 350),
           
           moodStatusView.topAnchor.constraint(equalTo: moodStatusView.bottomAnchor, constant: 30),
           moodStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           moodStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           moodStatusView.heightAnchor.constraint(equalToConstant: 350),
           

           coffeeTrackerView.topAnchor.constraint(equalTo: moodStatusView.bottomAnchor, constant: 30),
           coffeeTrackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           coffeeTrackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           coffeeTrackerView.heightAnchor.constraint(equalToConstant: coffeeTrackerHeight),
           
           coffeeAchievementLockView.topAnchor.constraint(equalTo: coffeeTrackerView.bottomAnchor, constant: 20),
           coffeeAchievementLockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           coffeeAchievementLockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           coffeeAchievementLockView.heightAnchor.constraint(equalToConstant: 270),
           
           momentStatusView.topAnchor.constraint(equalTo: coffeeAchievementLockView.bottomAnchor, constant: 20),
           momentStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           momentStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           momentStatusView.heightAnchor.constraint(equalToConstant: 330),
           
           coffeeStatusView.topAnchor.constraint(equalTo: momentStatusView.bottomAnchor, constant: 20),
           coffeeStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           coffeeStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           coffeeStatusView.heightAnchor.constraint(equalToConstant: 330),
           
           coffeeStatusByMoodView.topAnchor.constraint(equalTo: coffeeStatusView.bottomAnchor, constant: 20),
           coffeeStatusByMoodView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           coffeeStatusByMoodView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           coffeeStatusByMoodView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
           coffeeStatusByMoodView.heightAnchor.constraint(equalToConstant: 350)
       ])
       
       setupYearPicker()
      
      if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
          let moodView = MoodSelectionView()
          moodView.translatesAutoresizingMaskIntoConstraints = false
         moodView.backgroundColor = AppColors.color46
          moodView.alpha = 0
          moodView.delegate = self
          keyWindow.addSubview(moodView)

          NSLayoutConstraint.activate([
              moodView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
              moodView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
              moodView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
              moodView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor)
          ])

          moodSelectionView = moodView
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

   
   private func fetchUserProfileInformation() {
       let userId = UserProfile.shared.uuid
      
      GetUserProfileInformationRequest.shared.fetchUserProfile(uuid: userId) { [weak self] result in
           DispatchQueue.main.async {
               switch result {
               case .success(let response):
                   self?.userProfileInformation = response
                   
                   let isPremiumUser = response.userProfileInfo?.premium ?? false
                   self?.premiumAnalysisView.isHidden = isPremiumUser
                  self?.isPremiumUser = isPremiumUser
                  
                   if isPremiumUser {
                      
                       self?.premiumSubscribeView.removeFromSuperview()

                      
                       self?.moodStatusTopConstraint?.isActive = false
                       self?.moodStatusTopConstraint = self?.moodStatusView.topAnchor.constraint(equalTo: self?.coffeeMoodScoreView.bottomAnchor ?? NSLayoutYAxisAnchor(), constant: 20)
                       self?.moodStatusTopConstraint?.isActive = true
                      
                      if let entries = self?.journalEntriesResponse?.journalEntriesInfoList {
                                             self?.moodStatusView.configureWithEntries(entries)
                         self?.momentStatusView.configureWithEntries(entries)
                         self?.coffeeStatusView.configureWithEntries(entries)
                         self?.coffeeAchievementLockView.updateActiveList(journalEntries: entries)
                        } else {
                            self?.coffeeAchievementLockView.updateActiveList(journalEntries: [])
                           self?.updateCoffeeStatusByMood(entries: [], moodType: "smile")
                      }
                  
                   } else {
                     
                       self?.moodStatusTopConstraint?.isActive = false
                       self?.moodStatusTopConstraint = self?.moodStatusView.topAnchor.constraint(equalTo: self?.premiumAnalysisView.bottomAnchor ?? NSLayoutYAxisAnchor(), constant: 20)
                       self?.moodStatusTopConstraint?.isActive = true
                      self?.moodStatusView.configureWithEntries([])
                      self?.momentStatusView.configureWithEntries([])
                      self?.coffeeStatusView.configureWithEntries([])
                      self?.coffeeAchievementLockView.updateActiveList(journalEntries: [])
                   }

                  self?.momentStatusView.setPremiumStatus(isPremium: isPremiumUser)
                  self?.moodStatusView.setPremiumStatus(isPremium: isPremiumUser)
                  self?.coffeeStatusView.setPremiumStatus(isPremium: isPremiumUser)
                  self?.coffeeTrackerView.setPremiumStatus(isPremium: isPremiumUser)
                  self?.coffeeStatusByMoodView.setPremiumStatus(isPremium: isPremiumUser)
                  self?.coffeeAchievementLockView.setPremiumStatus(isPremium: isPremiumUser)
                  self?.handleStyleSelection(userProfileInfo: response.userProfileInfo)
                  self?.view.layoutIfNeeded()
               case .failure(let error):
                   break
               }
           }
       }
   }

   func fetchJournalEntries() {
       let userId = UserProfile.shared.uuid
       let journalDate = ""

       ListJournalEntriesRequest.shared.listJournalEntries(userId: userId, journalDate: journalDate, journalId: "", in: self.view) { [weak self] result in
           DispatchQueue.main.async {
               switch result {
               case .success(let response):
                   self?.journalEntriesResponse = response
                   let entries = response.journalEntriesInfoList ?? []

                 
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "yyyy-MM-dd"

                   guard let selectedYear = self?.selectedYear else { return }

               
                   let selectedYearDates = entries.compactMap { entry -> String? in
                       guard let entryDate = dateFormatter.date(from: entry.journalEntryDate) else { return nil }
                       let entryYear = Calendar.current.component(.year, from: entryDate)
                       return entryYear == selectedYear ? entry.journalEntryDate : nil
                   }

                  
                   let filteredEntries = entries.filter {
                       guard let entryDate = dateFormatter.date(from: $0.journalEntryDate) else { return false }
                       let entryYear = Calendar.current.component(.year, from: entryDate)
                       let entryMonth = Calendar.current.component(.month, from: entryDate)
                       return entryYear == selectedYear && entryMonth == (self?.selectedMonth ?? entryMonth)
                   }

                 
                   let sortedEntries = filteredEntries.sorted {
                       guard let date1 = dateFormatter.date(from: $0.journalEntryDate),
                             let date2 = dateFormatter.date(from: $1.journalEntryDate) else { return false }
                       return date1 < date2
                   }

                   
                   self?.dates = sortedEntries.map { $0.journalEntryDate }
                   self?.selectedYearDates = selectedYearDates

                   
                   self?.coffeeTrackerYearView.setupEntireYearView(with: self?.dates ?? [])
                   self?.coffeeDailyStatusView.configureWithEntries(entries: sortedEntries)
                   self?.moodStatusView.configureWithEntries(entries)
                   self?.momentStatusView.configureWithEntries(entries)
                   self?.coffeeStatusView.configureWithEntries(entries)
                   self?.coffeeMoodFlowView.configureWithEntries(entries: sortedEntries.map { ($0.journalEntryDate, $0.coffeeMoodType) })
                   self?.coffeeMoodFlowView.drawMoodChart(entries: sortedEntries.map { ($0.journalEntryDate, $0.coffeeMoodType) })

                   self?.updateLabels(entries: sortedEntries)
                 

               case .failure(let error): break
                 
               }
           }
       }
   }
   
   private func handleStyleSelection(userProfileInfo: UserProfileInfo?) {
       guard let styleSelection = userProfileInfo?.styleSelection else {
          
           return
       }

      if styleSelection.contains("ClassicSet") {
           callEmotionSetAPI(emotionSet: styleSelection)
       } else {
           callPrimeEmotionSetAPI(primeEmotionSet: styleSelection)
       }
   }

   private func callEmotionSetAPI(emotionSet: String) {
      EmotionSetRequest.shared.uploadEmotionSet(emotionSet: emotionSet) { [weak self] result in
           DispatchQueue.main.async {
               switch result {
               case .success(let response):
                  
                   if let imageUrls = response.emotionSet?.images {
                       self?.coffeeMoodFlowView.updateMoodImages(with: imageUrls)
                      self?.coffeeMoodScoreView.updateMoodImages(with: imageUrls)
                      self?.moodStatusView.updateMoodImages(with: imageUrls)
                      self?.coffeeStatusByMoodView.updateMoodImages(with: imageUrls)
                      self?.coffeeTrackerView.updateMoodImages(with: imageUrls)
                   } else {
                      
                   }
                  
               case .failure(let error): break
                   
               }
           }
       }
   }

   private func callPrimeEmotionSetAPI(primeEmotionSet: String) {
      PrimeEmotionSetRequest.shared.uploadPrimeEmotionSet(primeEmotionSet: primeEmotionSet, in: view) { [weak self] result in
           DispatchQueue.main.async {
               switch result {
               case .success(let response):
                   
                   if let imageUrls = response.primeEmotionSet?.images {
                       self?.coffeeMoodFlowView.updateMoodImages(with: imageUrls)
                      self?.coffeeMoodScoreView.updateMoodImages(with: imageUrls)
                      self?.moodStatusView.updateMoodImages(with: imageUrls)
                      self?.coffeeStatusByMoodView.updateMoodImages(with: imageUrls)
                      self?.coffeeTrackerView.updateMoodImages(with: imageUrls)
                   } else {
                      
                   }
               case .failure(let error): break
                   
               }
           }
       }
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       guard let moodStatusSuperview = moodStatusView.superview else { return }

       
       let moodStatusFrame = moodStatusSuperview.convert(moodStatusView.frame, to: view)

     
       if moodStatusFrame.origin.y <= view.frame.height {
        
           premiumSubscribeView.isHidden = false
       } else {
         
           premiumSubscribeView.isHidden = true
       }
   } 

   func didTapSubscribeButton() {
       let premiumVC = PremiumVC()
       premiumVC.modalPresentationStyle = .pageSheet

       premiumVC.onPremiumAccess = { [weak self] in
           guard let self = self else { return }
           
           if self.premiumSubscribeView.superview != nil {
               self.premiumSubscribeView.removeFromSuperview()
           }

           if self.premiumAnalysisView.superview != nil {
               self.premiumAnalysisView.removeFromSuperview()
           }

          let isPremiumUser = true
                  self.moodStatusView.setPremiumStatus(isPremium: isPremiumUser)
                  coffeeTrackerView.setPremiumStatus(isPremium: isPremiumUser)
                  momentStatusView.setPremiumStatus(isPremium: isPremiumUser)
                  coffeeStatusView.setPremiumStatus(isPremium: isPremiumUser)
                  coffeeStatusByMoodView.setPremiumStatus(isPremium: isPremiumUser)
                  coffeeAchievementLockView.setPremiumStatus(isPremium: isPremiumUser)
                   self.isPremiumUser = isPremiumUser
                  
                  if let entries = self.journalEntriesResponse?.journalEntriesInfoList {
                      self.moodStatusView.configureWithEntries(entries)
                     self.momentStatusView.configureWithEntries(entries)
                     self.coffeeStatusView.configureWithEntries(entries)
                     self.updateCoffeeStatusByMood(entries: entries, moodType: "smile") 
                     self.coffeeAchievementLockView.updateActiveList(journalEntries: entries)
                    } else {
                        self.coffeeAchievementLockView.updateActiveList(journalEntries: [])
                       self.updateCoffeeStatusByMood(entries: [], moodType: "smile")
                  }
         
          
          if let userProfileInfo = userProfileInformation?.userProfileInfo {
                     handleStyleSelection(userProfileInfo: userProfileInfo)
                 }
          
           self.moodStatusTopConstraint?.isActive = false
           self.moodStatusTopConstraint = self.moodStatusView.topAnchor.constraint(equalTo: self.coffeeMoodScoreView.bottomAnchor, constant: 20)
           self.moodStatusTopConstraint?.isActive = true
           
          
           self.view.layoutIfNeeded()

           self.showPremiumAccessView()
       }

       present(premiumVC, animated: true, completion: nil)
   }

 
    func didTapMomentMoreButton() {
        let detailVC = AnalysisDetailVC()
        detailVC.isMomentTypeFlag = true
        detailVC.isCoffeeTypeFlag = false
        detailVC.journalEntries = journalEntriesResponse?.journalEntriesInfoList ?? []
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func didTapCoffeeMoreButton() {
        let detailVC = AnalysisDetailVC()
        detailVC.isMomentTypeFlag = false
        detailVC.isCoffeeTypeFlag = true
        detailVC.journalEntries = journalEntriesResponse?.journalEntriesInfoList ?? []
        navigationController?.pushViewController(detailVC, animated: true)
    }
   
   func didTapMoreButton() {
      let achievementLockVC = AchievementLockAnalysisVC()
      achievementLockVC.journalEntriesResponse = self.journalEntriesResponse
      navigationController?.pushViewController(achievementLockVC, animated: true)
      
       }

   func updateLabels(entries: [JournalEntryInfo]) {
       
       let currentYear = Calendar.current.component(.year, from: Date())
      

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       
      let filteredEntries = entries.filter {
          guard let entryDate = dateFormatter.date(from: $0.journalEntryDate) else { return false }
          let entryYear = Calendar.current.component(.year, from: entryDate)
          
          return entryYear == selectedYear
      }

       let entryCount = filteredEntries.count
       let uniqueMoodTypes = Set(filteredEntries.map { $0.coffeeMoodType }).count
      
       coffeeMoodScoreView.averageLengthValueLabel.text = "\(entryCount)"
       coffeeMoodScoreView.exercisesValueLabel.text = "\(uniqueMoodTypes)"
       coffeeMoodScoreView.configure(entries: filteredEntries)
   }

   func updateCoffeeStatusByMood(entries: [JournalEntryInfo], moodType: String) {
       guard isPremiumUser else {
           coffeeStatusByMoodView.updateWithMoodType("smile", coffeeTypeCounts: [])
           return
       }

       let filteredEntries = entries.filter { $0.coffeeMoodType == moodType }
       let coffeeTypeCount = filteredEntries.reduce(into: [:]) { counts, entry in
           counts[entry.coffeeType, default: 0] += 1
       }
       
       let sortedCoffeeTypes = coffeeTypeCount
           .sorted(by: { $0.value > $1.value })
           .prefix(4)
           .map { ($0.key, $0.value) }

       coffeeStatusByMoodView.updateWithMoodType(moodType, coffeeTypeCounts: sortedCoffeeTypes)
       coffeeStatusByMoodView.actionButton.setImage(UIImage(named: moodType), for: .normal)
   }

 
   func moodSelectionView(_ view: MoodSelectionView, didSelectMoodType moodType: String) {
       guard let url = URL(string: moodType) else { return }

       URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
           guard error == nil, let self = self, let data = data, let image = UIImage(data: data) else { return }

           DispatchQueue.main.async {
               
               let isClassicSet = moodType.contains("ClassicSet")

            
               if let journalEntries = self.journalEntriesResponse?.journalEntriesInfoList {
                   self.updateCoffeeStatusByMood(entries: journalEntries, moodType: moodType)
               }

             
               self.coffeeStatusByMoodView.actionButton.setImage(image, for: .normal)

               self.coffeeStatusByMoodView.actionButton.constraints.forEach { constraint in
                   if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                       self.coffeeStatusByMoodView.actionButton.removeConstraint(constraint)
                   }
               }

             
               NSLayoutConstraint.activate([
                   self.coffeeStatusByMoodView.actionButton.widthAnchor.constraint(equalToConstant: isClassicSet ? 35 : 60),
                   self.coffeeStatusByMoodView.actionButton.heightAnchor.constraint(equalToConstant: isClassicSet ? 35 : 60)
               ])

             
               self.coffeeStatusByMoodView.moodIconBackgroundView.subviews.forEach { $0.removeFromSuperview() }

               let moodImageView = UIImageView(image: image)
               moodImageView.contentMode = .scaleAspectFill
               moodImageView.clipsToBounds = true
               moodImageView.translatesAutoresizingMaskIntoConstraints = false
               self.coffeeStatusByMoodView.moodIconBackgroundView.addSubview(moodImageView)

               NSLayoutConstraint.activate([
                   moodImageView.centerXAnchor.constraint(equalTo: self.coffeeStatusByMoodView.moodIconBackgroundView.centerXAnchor),
                   moodImageView.centerYAnchor.constraint(equalTo: self.coffeeStatusByMoodView.moodIconBackgroundView.centerYAnchor),
                   moodImageView.widthAnchor.constraint(equalToConstant: isClassicSet ? 40 : self.coffeeStatusByMoodView.moodIconBackgroundView.bounds.width),
                   moodImageView.heightAnchor.constraint(equalToConstant: isClassicSet ? 40 : self.coffeeStatusByMoodView.moodIconBackgroundView.bounds.height)
               ])
           }
       }.resume()

     
       UIView.animate(withDuration: 0.3) {
           self.moodSelectionView?.alpha = 0
       }
   }

   func coffeeStatusByMoodDidTapActionButton() {
          UIView.animate(withDuration: 0.3) {
              self.moodSelectionView?.alpha = 1
          }
      }

   func coffeeStatusByMoodDidUpdateImages(_ imageUrls: [String]) {
       self.moodSelectionView?.updateMoodButtons(with: imageUrls)

      var modifiedImageUrls: [String] = []
         let group = DispatchGroup()

         for url in imageUrls {
             group.enter()
             
             if url.contains("ClassicSet") {
                
                 processClassicSetImage(from: url) { modifiedUrl in
                     if let modifiedUrl = modifiedUrl {
                         modifiedImageUrls.append(modifiedUrl)
                     } else {
                         modifiedImageUrls.append(url)
                     }
                     group.leave()
                 }
             } else {
                 modifiedImageUrls.append(url)
                 group.leave()
             }
         }

         group.notify(queue: .main) {
            
             self.moodSelectionView?.updateMoodButtons(with: modifiedImageUrls)

            
             if let smileUrl = modifiedImageUrls.first(where: { $0.contains("smile") }) {
                 self.moodSelectionView?.delegate?.moodSelectionView(self.moodSelectionView!, didSelectMoodType: smileUrl)
             }
         }
     }
   
   func processClassicSetImage(from url: String, completion: @escaping (String?) -> Void) {
       guard let imageUrl = URL(string: url) else {
           completion(nil)
           return
       }

       URLSession.shared.dataTask(with: imageUrl) { data, _, error in
           guard error == nil, let data = data, let image = UIImage(data: data) else {
               completion(nil)
               return
           }

           DispatchQueue.main.async {
             
               if let resizedImage = image.resized(toWidth: 50),
                  let resizedData = resizedImage.jpegData(compressionQuality: 0.8) {
                   
                  
                   let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                   
                   do {
                       try resizedData.write(to: tempUrl)
                       completion(tempUrl.absoluteString)
                   } catch {
                       completion(nil)
                   }
               } else {
                   completion(nil)
               }
           }
       }.resume()
   }

   func setupYearPicker() {
       yearMonthPickerView = YearMonthPickerView(frame: view.bounds)
       yearMonthPickerView?.delegate = self
       yearMonthPickerView?.alpha = 0
       if let yearPickerView = yearMonthPickerView {
           view.addSubview(yearPickerView)
       }
   }

   private func showYearPicker() {
       UIView.animate(withDuration: 0.3) {
           self.yearMonthPickerView?.alpha = 1
           self.disableTabBarInteraction()
       }
   }
  
   func yearPickerViewDidCancel(_ pickerView: YearMonthPickerView) {
       UIView.animate(withDuration: 0.3) {
           pickerView.alpha = 0
           self.enableTabBarInteraction()
       }
   }

   func yearPickerView(_ pickerView: YearMonthPickerView, didSelectYear year: Int, month: Int) {
       UIView.animate(withDuration: 0.3) {
           pickerView.alpha = 0
           self.enableTabBarInteraction()
       }

       selectedYear = year
       selectedMonth = month
    
      coffeeTrackerView.updateDescriptionLabel(year: year)
      
       if let entries = journalEntriesResponse?.journalEntriesInfoList {
           if let allEntries = journalEntriesResponse?.journalEntriesInfoList {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd"

               selectedYearDates = allEntries.compactMap { entry in
                   guard let entryDate = dateFormatter.date(from: entry.journalEntryDate) else { return nil }
                   let entryYear = Calendar.current.component(.year, from: entryDate)
                   return entryYear == selectedYear ? entry.journalEntryDate : nil
               }
           }

           let filteredEntries = filterEntriesForDailyStatus(entries: entries, forYear: year, month: month)

           coffeeDailyStatusView.configureWithEntries(entries: filteredEntries)
           coffeeDailyStatusView.updateDateLabelWithYearAndMonth(year: year, month: month)

           coffeeMoodFlowView.configureWithEntries(entries: filteredEntries.map { ($0.journalEntryDate, $0.coffeeMoodType) })
           coffeeMoodFlowView.updateChart(withYear: year, month: month)
           coffeeMoodFlowView.setupChart()

           coffeeMoodScoreView.update(forYear: year, month: month, withEntries: filteredEntries)
           updateLabels(entries: filteredEntries)

           if isPremiumUser {
              
               moodStatusView.update(forYear: year, month: month, withEntries: filteredEntries)
               moodStatusView.setPremiumStatus(isPremium: true)
               momentStatusView.setPremiumStatus(isPremium: true)
              coffeeStatusView.setPremiumStatus(isPremium: true)
              coffeeTrackerView.setPremiumStatus(isPremium: true)
              coffeeStatusByMoodView.setPremiumStatus(isPremium: true)
              coffeeAchievementLockView.setPremiumStatus(isPremium: true)
              if let entries = journalEntriesResponse?.journalEntriesInfoList {
                 momentStatusView.configureWithEntries(entries)
                 coffeeStatusView.configureWithEntries(entries)
                 coffeeAchievementLockView.updateActiveList(journalEntries: entries)
                } else {
                    coffeeAchievementLockView.updateActiveList(journalEntries: [])
                   updateCoffeeStatusByMood(entries: [], moodType: "smile")
              }
           } else {
             
               moodStatusView.update(forYear: year, month: month, withEntries: [])
               moodStatusView.setPremiumStatus(isPremium: false)
              momentStatusView.setPremiumStatus(isPremium: false)
              coffeeStatusView.setPremiumStatus(isPremium: false)
              coffeeTrackerView.setPremiumStatus(isPremium: false)
              coffeeStatusByMoodView.setPremiumStatus(isPremium: false)
              coffeeAchievementLockView.setPremiumStatus(isPremium: false)
             momentStatusView.configureWithEntries([])
              coffeeStatusView.configureWithEntries([])
             coffeeAchievementLockView.updateActiveList(journalEntries: [])
           }

           moodStatusView.setNeedsLayout()
           moodStatusView.layoutIfNeeded()
           moodStatusView.setNeedsDisplay()
       }

       yearMonthPickerView?.selectedYear = year
       yearMonthSegmentControl.setYearButtonTitle(with: year, month: month)

       if let userProfileInfo = userProfileInformation?.userProfileInfo {
           handleStyleSelection(userProfileInfo: userProfileInfo)
       }
   }

   func filterEntriesForDailyStatus(entries: [JournalEntryInfo], forYear year: Int, month: Int? = nil) -> [JournalEntryInfo] {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"

       return entries.filter { entry in
           guard let date = dateFormatter.date(from: entry.journalEntryDate) else { return false }
           let entryYear = Calendar.current.component(.year, from: date)
           
           if let month = month {
              
               let entryMonth = Calendar.current.component(.month, from: date)
               return entryYear == year && entryMonth == month
           } else {
              
               return entryYear == year
           }
       }
   }
   
   func filterEntries(entries: [JournalEntryInfo], forYear year: Int, month: Int? = nil) -> [(date: String, mood: String)] {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"

       return entries.compactMap { entry in
           guard let date = dateFormatter.date(from: entry.journalEntryDate) else { return nil }
           let entryYear = Calendar.current.component(.year, from: date)
           
           if let month = month {
             
               let entryMonth = Calendar.current.component(.month, from: date)
               return entryYear == year && entryMonth == month ? (date: entry.journalEntryDate, mood: entry.coffeeMoodType) : nil
           } else {
              
               return entryYear == year ? (date: entry.journalEntryDate, mood: entry.coffeeMoodType) : nil
           }
       }
   }

   private func disableTabBarInteraction() {
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

   private func enableTabBarInteraction() {
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




