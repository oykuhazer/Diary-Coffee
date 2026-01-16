//
//  CalendarVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//

import UIKit

protocol CoffeeDiaryCalendarCellDelegate: AnyObject {
    func deleteEntry(with journalEntryId: String)
    func editEntry(with journalEntryId: String, isFromEditButton: Bool)
}

class CalendarVC: UIViewController, DateSelectorDelegate,  CalendarViewDelegate, CoffeeDiaryCalendarCellDelegate, DiaryEntryDelegate   {
    
    var response: GetUserProfileInformationResponse?
    var isFromSceneDelegate: Bool = false
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let dateSelectorButton = DateSelectorButton(isDayMonthYearFormat: false, showYearMonthSelectorView: true)
    let calendarView = CalendarView()
    let yearMonthSelectorView = YearMonthSelectorView(selectedYear: 2024, selectedMonth: 1)
    let coffeeDiaryCalendar = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var isCalendarViewHidden = false
    var isAscendingOrder = true
    var originalConstraints = [NSLayoutConstraint]()
    var adjustedConstraints = [NSLayoutConstraint]()
    let arrowButton = UIButton(type: .system)
    let gridButton = UIButton(type: .system)
    var journalEntriesResponse: ListJournalEntriesResponse?

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let safeAreaBackgroundView = CustomSafeAreaBackgroundView(backgroundColor: AppColors.color3)
        view.addSubview(safeAreaBackgroundView)
        view.sendSubviewToBack(safeAreaBackgroundView)
        
        view.backgroundColor = AppColors.color3
        self.navigationItem.hidesBackButton = true
        
        setupNavigationBarButtons()
        setupScrollView()
        setupDateSelectorButton()
        setupCalendarView()
        setupCoffeeDiaryCalendar()
        setupArrowButton()
  
        yearMonthSelectorView.onDateSelected = { [weak self] month, year in
                self?.calendarView.updateCalendar(for: month, year: year)
            }
        
        if let layout = coffeeDiaryCalendar.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        dateSelectorButton.delegate = self
        
        yearMonthSelectorView.onDateSelected = { [weak self] month, year in
                self?.calendarView.updateCalendar(for: month, year: year)
        }

         
        let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            let currentDay = Calendar.current.component(.day, from: Date())
            
            calendarView.updateCalendar(for: currentMonth, year: currentYear)
            calendarView.delegate = self
            
        fetchJournalEntries(for: currentYear, month: currentMonth, day: nil)
        
        if let journalDates = journalEntriesResponse?.journalEntriesInfoList?.compactMap({ $0.journalEntryDate }) {
              calendarView.updateJournalEntries(journalDates)
          }
        
            fetchJournalEntries(for: currentYear, month: currentMonth, day: currentDay)
        
        if isFromSceneDelegate, let isPremium = response?.userProfileInfo?.premium, !isPremium {
            let premiumVC = PremiumVC()
            premiumVC.modalPresentationStyle = .pageSheet
            
            premiumVC.onPremiumAccess = { [weak self] in
                guard let self = self else { return }
                self.showPremiumAccessView()
            }
            
            present(premiumVC, animated: true, completion: nil)
            return
        }
       
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

    func didSelectDate(year: Int, month: Int, day: Int) {
          let diaryEntryVC = DiaryEntryVC()
          diaryEntryVC.selectedDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
          navigationController?.pushViewController(diaryEntryVC, animated: true)
      }

   
    
    private func promptDiaryEntry(for year: Int, month: Int, day: Int?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let parentViewController = self.view.window?.rootViewController as? CustomTabBarController {
                let diaryEntryVC = DiaryEntryVC()
                let selectedDay = day ?? 1
                diaryEntryVC.selectedDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", selectedDay))"
                diaryEntryVC.modalPresentationStyle = .fullScreen
                parentViewController.present(diaryEntryVC, animated: true, completion: nil)
            } else {
               
            }
        }
    }
    
    
    func fetchJournalEntries(for year: Int, month: Int, day: Int?) {
        guard let window = UIApplication.shared.windows.first else { return }
        let loadingView = LoadingView(frame: window.bounds)
        window.addSubview(loadingView)

        
        
        self.journalEntriesResponse = nil
        self.coffeeDiaryCalendar.reloadData()
        self.coffeeDiaryCalendar.isHidden = true

      
        let journalDate: String
        if let day = day {
            journalDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
        } else {
            journalDate = "\(year)-\(String(format: "%02d", month))"
        }

        let userId = UserProfile.shared.uuid

        ListJournalEntriesRequest.shared.listJournalEntries(userId: userId, journalDate: journalDate, journalId: "", in: self.view) { [weak self] result in
            DispatchQueue.main.async {
                loadingView.removeFromSuperview()

                switch result {
                case .success(let response):
                    self?.journalEntriesResponse = response

                    if let entries = response.journalEntriesInfoList {
                              let dates = entries.compactMap { $0.journalEntryDate }
                        self?.calendarView.updateJournalEntries(dates)
                          }
                    
                    if let entries = response.journalEntriesInfoList {
                        if self?.isAscendingOrder == true {
                            self?.journalEntriesResponse?.journalEntriesInfoList = entries.sorted { $0.journalEntryDate < $1.journalEntryDate }
                        } else {
                            self?.journalEntriesResponse?.journalEntriesInfoList = entries.sorted { $0.journalEntryDate > $1.journalEntryDate }
                        }
                    }

                    if let entries = self?.journalEntriesResponse?.journalEntriesInfoList, !entries.isEmpty {
                        self?.coffeeDiaryCalendar.isHidden = false
                        self?.coffeeDiaryCalendar.reloadData()
                    } else {
                        self?.coffeeDiaryCalendar.isHidden = true
                        self?.promptDiaryEntry(for: year, month: month, day: day)
                    }

                    if day == nil {
                                      //self?.coffeeDiaryCalendar.isHidden = true
                                  } else {
                                      self?.coffeeDiaryCalendar.isHidden = false
                                  }
                    
                case .failure:
                    self?.promptDiaryEntry(for: year, month: month, day: day)
                    self?.coffeeDiaryCalendar.isHidden = true
                }
            }
        }
    }

    @objc private func gridButtonTapped() {
        isCalendarViewHidden.toggle()

        print("📌 gridButtonTapped çağrıldı. isCalendarViewHidden: \(isCalendarViewHidden)")

        if isCalendarViewHidden {
            calendarView.isHidden = true
            coffeeDiaryCalendar.isHidden = false  // 🎯 **Burada kesin olarak görünmesini sağlıyoruz**
            arrowButton.isHidden = false
            gridButton.setImage(UIImage(systemName: "calendar"), for: .normal)

            NSLayoutConstraint.deactivate(originalConstraints)
            NSLayoutConstraint.activate(adjustedConstraints)

            isAscendingOrder = false
            fetchSortedJournalEntries()
        } else {
            calendarView.isHidden = false
            coffeeDiaryCalendar.isHidden = true
            arrowButton.isHidden = true
            gridButton.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)

            NSLayoutConstraint.deactivate(adjustedConstraints)
            NSLayoutConstraint.activate(originalConstraints)

            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            let currentDay = Calendar.current.component(.day, from: Date())

            fetchJournalEntries(for: currentYear, month: currentMonth, day: currentDay)
        }

        DispatchQueue.main.async {
            print("📌 `coffeeDiaryCalendar.isHidden` şimdi: \(self.coffeeDiaryCalendar.isHidden)") // ✅ **Gerçekten değişti mi? Test edelim!**
            self.view.layoutIfNeeded()
        }
    }


    
    func didSelectYearMonth(year: Int, month: Int) {
     
        fetchJournalEntries(for: year, month: month, day: nil)
    
        let journalDates = journalEntriesResponse?.journalEntriesInfoList?.compactMap { $0.journalEntryDate } ?? []
        
        calendarView.updateJournalEntries(journalDates)
    }
    
    func didSelectDate(year: Int) {
         
      }
    func deleteEntry(with journalEntryId: String) {
        showAlertView(
            title: NSLocalizedString("delete_entry", comment: ""),
            message: NSLocalizedString("confirm_delete_entry", comment: "")
        ) { [weak self] in
            guard let self = self else { return }

            guard let window = UIApplication.shared.windows.first else { return }
            let loadingView = LoadingView(frame: window.bounds)
            window.addSubview(loadingView)

            let userId = UserProfile.shared.uuid

            let deletedEntryDate = self.journalEntriesResponse?.journalEntriesInfoList?
                .first(where: { $0.journalEntryId == journalEntryId })?.journalEntryDate

            DeleteJournalEntryRequest.shared.deleteJournalEntry(userId: userId, journalEntryId: journalEntryId) { result in
                DispatchQueue.main.async {
                    loadingView.removeFromSuperview()

                    switch result {
                    case .success(let response):
                        if response.resultCode == 200 {
                          
                            self.journalEntriesResponse?.journalEntriesInfoList?.removeAll { $0.journalEntryId == journalEntryId }
                            
                      
                            let updatedDates = self.journalEntriesResponse?.journalEntriesInfoList?.compactMap { $0.journalEntryDate } ?? []
                            
                        
                            self.calendarView.updateJournalEntries(updatedDates)

                         
                            if let deletedDate = deletedEntryDate, !updatedDates.contains(deletedDate) {
                                self.calendarView.removeJournalEntry(for: deletedDate)
                            }

                        
                            self.coffeeDiaryCalendar.reloadData()
                        }
                    case .failure:
                        break
                    }
                }
            }
        }
    }

    func editEntry(with journalEntryId: String, isFromEditButton: Bool) {
            let diaryEntryVC = DiaryEntryVC()
            diaryEntryVC.selectedJournalEntryId = journalEntryId
            diaryEntryVC.isFromEditButton = isFromEditButton
            navigationController?.pushViewController(diaryEntryVC, animated: true)
        }
    
    func showAlertView(title: String, message: String, onConfirm: @escaping () -> Void) {
        let alertView = MainAlertView()
        alertView.configure(
            title: title,
            message: message,
            cancelAction: {
                alertView.removeFromSuperview()
            },
            actionHandler: {
                onConfirm()
                alertView.removeFromSuperview()
            }
        )

        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func didSaveEntrySuccessfully() {
       
        let recordActionView = RequiredActionView(frame: view.bounds)
        recordActionView.configure(
            icon: UIImage(named: "success"),
            message: NSLocalizedString("day_recorded", comment: "")
        )
        view.addSubview(recordActionView)
           
          
           DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
               recordActionView.removeFromSuperview()
           }
       }
    
    func didSelectDate(year: Int, month: Int) {
        calendarView.updateCalendar(for: month, year: year)
        journalEntriesResponse?.journalEntriesInfoList?.removeAll() 
             coffeeDiaryCalendar.reloadData()
             coffeeDiaryCalendar.isHidden = true
       
        if isCalendarViewHidden {
            fetchJournalEntries(for: year, month: month, day: nil)
        }
    }
    
    private func setupNavigationBarButtons() {
        let buttonColor = AppColors.color1
    
        
        let paintButton = UIButton(type: .system)
        paintButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        paintButton.tintColor = buttonColor
        paintButton.addTarget(self, action: #selector(paintButtonTapped), for: .touchUpInside)
   
        gridButton.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
        gridButton.tintColor = buttonColor
        gridButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [paintButton, gridButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.alignment = .center
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonStack)
    }
 

    @objc private func paintButtonTapped() {
        let widgetsVC = WidgetsVC()
        
        widgetsVC.userProfile = response
        
        navigationController?.pushViewController(widgetsVC, animated: true)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupDateSelectorButton() {
        dateSelectorButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateSelectorButton)

        NSLayoutConstraint.activate([
            dateSelectorButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateSelectorButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateSelectorButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupArrowButton() {
           arrowButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
           arrowButton.tintColor = AppColors.color1
           arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
           arrowButton.isHidden = true
           arrowButton.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(arrowButton)
           
           NSLayoutConstraint.activate([
               arrowButton.centerYAnchor.constraint(equalTo: dateSelectorButton.centerYAnchor),
               arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
           ])
       }
    
    @objc private func arrowButtonTapped() {
       
        isAscendingOrder.toggle()
        fetchSortedJournalEntries()
    }

    
    private func fetchSortedJournalEntries() {
        
        let year = calendarView.currentYear
        let month = calendarView.currentMonth
       
        if isAscendingOrder {
            fetchJournalEntries(for: year, month: month, day: nil)
        } else {
            fetchJournalEntries(for: year, month: month, day: nil)
        }
    }

    private func setupCalendarView() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: dateSelectorButton.bottomAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calendarView.heightAnchor.constraint(equalToConstant: 420)
        ])
        
       
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        calendarView.updateCalendar(for: currentMonth, year: currentYear)
    }


    private func setupCoffeeDiaryCalendar() {
        coffeeDiaryCalendar.translatesAutoresizingMaskIntoConstraints = false
        coffeeDiaryCalendar.backgroundColor = .clear
        coffeeDiaryCalendar.delegate = self
        coffeeDiaryCalendar.dataSource = self
        coffeeDiaryCalendar.register(CoffeeDiaryCalendarCell.self, forCellWithReuseIdentifier: "CoffeeDiaryCalendarCell")
        coffeeDiaryCalendar.showsVerticalScrollIndicator = false
        coffeeDiaryCalendar.showsHorizontalScrollIndicator = false

        contentView.addSubview(coffeeDiaryCalendar)
        
        originalConstraints = [
            coffeeDiaryCalendar.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 40),
            coffeeDiaryCalendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coffeeDiaryCalendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coffeeDiaryCalendar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            coffeeDiaryCalendar.heightAnchor.constraint(equalToConstant: 500)
        ]
        
        adjustedConstraints = [
            coffeeDiaryCalendar.topAnchor.constraint(equalTo: dateSelectorButton.bottomAnchor, constant: 60),
            coffeeDiaryCalendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coffeeDiaryCalendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coffeeDiaryCalendar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            coffeeDiaryCalendar.heightAnchor.constraint(equalToConstant: 500)
        ]
        
        NSLayoutConstraint.activate(originalConstraints)
    }
}
