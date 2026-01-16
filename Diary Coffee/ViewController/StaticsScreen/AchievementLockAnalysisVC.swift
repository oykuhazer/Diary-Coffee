//
//  AchievementLockAnalysisVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 14.11.2024.
//

import UIKit

class AchievementLockAnalysisVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let imageNames = ["first_1", "morning_2", "dessert_3", "favorite_4", "sweet_5", "repetation_6", "motivation_7", "workbreak_8", "nature_9", "inspiration_10", "different_11", "world_12", "gourmet_13", "cold_14", "night_15", "traveler_16", "classic_17", "white_18", "love_19", "romance_20", "friends_21", "special_22", "chat_23", "journey_24", "explore_25", "calm_26", "chattour_27", "everymoment_28"]
    
    private let captions = [
        NSLocalizedString("first_sip", comment: ""),
        NSLocalizedString("morning_brew", comment: ""),
        NSLocalizedString("sweet_moments", comment: ""),
        NSLocalizedString("favorite_coffee_quest", comment: ""),
        NSLocalizedString("sweet_coffee_stop", comment: ""),
        NSLocalizedString("taste_of_repetition", comment: ""),
        NSLocalizedString("motivation_filter", comment: ""),
        NSLocalizedString("work_break_revitalizer", comment: ""),
        NSLocalizedString("natures_brew", comment: ""),
        NSLocalizedString("inspiration_with_coffee", comment: ""),
        NSLocalizedString("different_sips", comment: ""),
        NSLocalizedString("world_coffees", comment: ""),
        NSLocalizedString("gourmet_coffee_expert", comment: ""),
        NSLocalizedString("cold_enthusiast", comment: ""),
        NSLocalizedString("night_owl", comment: ""),
        NSLocalizedString("travelers_cup", comment: ""),
        NSLocalizedString("coffee_classic", comment: ""),
        NSLocalizedString("white_coffee", comment: ""),
        NSLocalizedString("love_in_first_sip", comment: ""),
        NSLocalizedString("romance_in_cup", comment: ""),
        NSLocalizedString("friends_sip", comment: ""),
        NSLocalizedString("special_moments", comment: ""),
        NSLocalizedString("chat_in_cup", comment: ""),
        NSLocalizedString("coffee_journey", comment: ""),
        NSLocalizedString("explore_together", comment: ""),
        NSLocalizedString("calm_sips", comment: ""),
        NSLocalizedString("chat_tour", comment: ""),
        NSLocalizedString("every_moment", comment: "")
    ]

    
    private var collectionView: UICollectionView!
    private var isActiveList: [Bool] = []
    private var requiredActionView: RequiredActionView?
    var journalEntriesResponse: ListJournalEntriesResponse? {
        didSet {
           
            updateActiveList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let safeAreaBackgroundView = CustomSafeAreaBackgroundView(backgroundColor: AppColors.color6)
        view.addSubview(safeAreaBackgroundView)
        view.sendSubviewToBack(safeAreaBackgroundView)
        
        view.backgroundColor = AppColors.color6
        navigationItem.title = NSLocalizedString("journey_of_the_cup", comment: "")
        
      
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.color5]
        
        setupCollectionView()
        updateActiveList()

    }


    private func updateActiveList() {
        guard collectionView != nil else {
           
            return
        }
        
        isActiveList = Array(repeating: false, count: imageNames.count)
        
        if let journalEntries = journalEntriesResponse?.journalEntriesInfoList, !journalEntries.isEmpty {
          
            if let firstSipIndex = captions.firstIndex(of: NSLocalizedString("first_sip", comment: "")) {
                isActiveList[firstSipIndex] = true
            }
            
          
            if let morningBrewIndex = captions.firstIndex(of: NSLocalizedString("morning_brew", comment: "")) {
                let morningEntries = journalEntries.filter { $0.coffeeMomentType == "Morning" }
                let uniqueCoffeeTypes = Set(morningEntries.map { $0.coffeeType })
                if uniqueCoffeeTypes.count >= 10 {
                    isActiveList[morningBrewIndex] = true
                }
            }
            
           
            if let sweetMomentsIndex = captions.firstIndex(of: NSLocalizedString("sweet_moments", comment: "")) {
                let dessertEntries = journalEntries.filter { $0.coffeeMomentType == "Dessert" }
                let uniqueMomentTypes = Set(journalEntries.map { $0.coffeeMomentType })
                if dessertEntries.count > 0 && uniqueMomentTypes.count >= 5 {
                    isActiveList[sweetMomentsIndex] = true
                }
            }
            
         
            if let favoriteCoffeeQuestIndex = captions.firstIndex(of: NSLocalizedString("favorite_coffee_quest", comment: "")) {
                let uniqueCoffeeTypes = Set(journalEntries.map { $0.coffeeType })
                if uniqueCoffeeTypes.count >= 20 {
                    isActiveList[favoriteCoffeeQuestIndex] = true
                }
            }
            
           
            if let sweetCoffeeStopIndex = captions.firstIndex(of: NSLocalizedString("sweet_coffee_stop", comment: "")) {
                let sweetCoffeeTypes: Set<String> = ["Mocha", "Macchiato", "Affogato", "Irish Coffee", "Vienna Coffee", "Frappé"]
                let sweetCoffeeCount = journalEntries.filter { sweetCoffeeTypes.contains($0.coffeeType) }.count
                if sweetCoffeeCount >= 20 {
                    isActiveList[sweetCoffeeStopIndex] = true
                }
            }
            
           
            if let tasteOfRepetitionIndex = captions.firstIndex(of: NSLocalizedString("taste_of_repetition", comment: "")) {
                let combinations = journalEntries.reduce(into: [String: Int]()) { counts, entry in
                    let key = "\(entry.coffeeMomentType)-\(entry.coffeeType)"
                    counts[key, default: 0] += 1
                }
                
                if combinations.values.contains(where: { $0 >= 5 }) {
                    isActiveList[tasteOfRepetitionIndex] = true
                }
            }
            
         
            if let motivationFilterIndex = captions.firstIndex(of: NSLocalizedString("   motivation_filter", comment: "")) {
                let workBreakCount = journalEntries.filter { $0.coffeeMomentType == "Work Break" }.count
                if workBreakCount >= 20 {
                    isActiveList[motivationFilterIndex] = true
                }
            }
            
          
            if let workBreakRevitalizerIndex = captions.firstIndex(of:   NSLocalizedString("work_break_revitalizer", comment: "")) {
                let workBreakCount = journalEntries.filter { $0.coffeeMomentType == "Work Break" }.count
                if workBreakCount >= 5 {
                    isActiveList[workBreakRevitalizerIndex] = true
                }
            }
            
          
            if let naturesBrewIndex = captions.firstIndex(of:   NSLocalizedString("natures_brew", comment: "")) {
                let campEntriesByMonth = journalEntries
                    .filter { $0.coffeeMomentType == "Camp" }
                    .reduce(into: [String: Int]()) { counts, entry in
                       
                        let dateComponents = entry.journalEntryDate.split(separator: "-")
                        if dateComponents.count >= 2 {
                            let yearMonthKey = "\(dateComponents[0])-\(dateComponents[1])"
                            counts[yearMonthKey, default: 0] += 1
                        }
                    }
                
                if campEntriesByMonth.values.contains(where: { $0 >= 5 }) {
                    isActiveList[naturesBrewIndex] = true
                }
            }
            
        
            if let inspirationWithCoffeeIndex = captions.firstIndex(of:     NSLocalizedString("inspiration_with_coffee", comment: "")) {
                    let inspirationEntriesByMonth = journalEntries
                        .filter { $0.coffeeMomentType == "Reading" || $0.coffeeMomentType == "Inspiration" }
                        .reduce(into: [String: Int]()) { counts, entry in
                            let dateComponents = entry.journalEntryDate.split(separator: "-")
                            if dateComponents.count >= 2 {
                                let yearMonthKey = "\(dateComponents[0])-\(dateComponents[1])"
                                counts[yearMonthKey, default: 0] += 1
                            }
                        }
                    if inspirationEntriesByMonth.values.contains(where: { $0 >= 5 }) {
                        isActiveList[inspirationWithCoffeeIndex] = true
                    }
                }
            
        
            if let differentSipsIndex = captions.firstIndex(of:     NSLocalizedString("different_sips", comment: "")) {
                  
                     let sortedEntries = journalEntries.sorted { $0.journalEntryDate < $1.journalEntryDate }
                     
                     var consecutiveDays = 0
                     var seenCoffeeTypes = Set<String>()
                     var previousDate: Date? = nil
                     
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "yyyy-MM-dd"
                     
                     for entry in sortedEntries {
                         guard let entryDate = dateFormatter.date(from: entry.journalEntryDate) else { continue }
                         
                         if let previous = previousDate {
                             let difference = Calendar.current.dateComponents([.day], from: previous, to: entryDate).day ?? 0
                             if difference == 1 {
                                
                                 if seenCoffeeTypes.contains(entry.coffeeType) {
                                   
                                     consecutiveDays = 0
                                     seenCoffeeTypes.removeAll()
                                 } else {
                                    
                                     seenCoffeeTypes.insert(entry.coffeeType)
                                     consecutiveDays += 1
                                 }
                             } else if difference > 1 {
                                 
                                 consecutiveDays = 0
                                 seenCoffeeTypes.removeAll()
                             }
                         } else {
                            
                             seenCoffeeTypes.insert(entry.coffeeType)
                             consecutiveDays = 1
                         }
                         
                         previousDate = entryDate
                         
                        
                         if consecutiveDays == 7 {
                             isActiveList[differentSipsIndex] = true
                             break
                         }
                     }
                 }
            
            
            if let worldCoffeesIndex = captions.firstIndex(of: NSLocalizedString("world_coffees", comment: "")) {
                       let requiredCoffeeTypes: Set<String> = ["Turkish Coffee", "Vienna Coffee", "Café de Olla"]
                       let availableCoffeeTypes = Set(journalEntries.map { $0.coffeeType })
                       
                       if requiredCoffeeTypes.isSubset(of: availableCoffeeTypes) {
                           isActiveList[worldCoffeesIndex] = true
                       }
                   }
            
           
            if let gourmetCoffeeExpertIndex = captions.firstIndex(of:  NSLocalizedString("gourmet_coffee_expert", comment: "")) {
                       let gourmetCoffeeTypes: Set<String> = ["Macchiato", "Ristretto", "Breve", "Lungo", "Mazagran"]
                       let availableCoffeeTypes = Set(journalEntries.map { $0.coffeeType })
                       
                    
                       let matchingTypes = gourmetCoffeeTypes.intersection(availableCoffeeTypes)
                       if matchingTypes.count >= 2 {
                           isActiveList[gourmetCoffeeExpertIndex] = true
                       }
                   }
            
          
            if let coldEnthusiastIndex = captions.firstIndex(of:   NSLocalizedString("cold_enthusiast", comment: "")) {
                      let coldCoffeeTypes: Set<String> = ["Frappé", "Cold Brew", "Shakerato", "Mazagran", "Romano", "Affogato"]
                      let coldCoffeeCount = journalEntries.filter { coldCoffeeTypes.contains($0.coffeeType) }.count
                      
                      if coldCoffeeCount >= 20 {
                          isActiveList[coldEnthusiastIndex] = true
                      }
                  }
            
        
            
            if let nightOwlIndex = captions.firstIndex(of: NSLocalizedString("night_owl", comment: "")) {
                     let eveningCount = journalEntries.filter { $0.coffeeMomentType == "Evening" }.count
                     
                     if eveningCount >= 20 {
                         isActiveList[nightOwlIndex] = true
                     }
                 }
            
           
            if let travelersCupIndex = captions.firstIndex(of:  NSLocalizedString("travelers_cup", comment: "")) {
                      let tripEntries = journalEntries.filter { $0.coffeeMomentType == "Trip" }
                      let uniqueCoffeeTypes = Set(tripEntries.map { $0.coffeeType })
                      
                      if uniqueCoffeeTypes.count >= 10 {
                          isActiveList[travelersCupIndex] = true
                      }
                  }
            
           
            if let coffeeClassicIndex = captions.firstIndex(of:  NSLocalizedString("coffee_classic", comment: "")) {
                     let classicCoffeeTypes: Set<String> = ["Espresso", "Americano", "Cappuccino", "Turkish Coffee"]
                     let classicCoffeeCount = journalEntries.filter { classicCoffeeTypes.contains($0.coffeeType) }.count
                     
                     if classicCoffeeCount >= 20 {
                         isActiveList[coffeeClassicIndex] = true
                     }
                 }
            
          
            if let whiteCoffeeIndex = captions.firstIndex(of:   NSLocalizedString("white_coffee", comment: "")) {
                        let whiteCoffeeTypes: Set<String> = ["Cappuccino", "Latte", "Mocha", "Macchiato", "Breve Coffee", "Vienna Coffee"]
                        let whiteCoffeeCount = journalEntries.filter { whiteCoffeeTypes.contains($0.coffeeType) }.count
                        
                        if whiteCoffeeCount >= 20 {
                            isActiveList[whiteCoffeeIndex] = true
                        }
                    }
          
            
            if let loveInFirstSipIndex = captions.firstIndex(of: NSLocalizedString("love_in_first_sip", comment: "")) {
                       let romanticMomentExists = journalEntries.contains { $0.coffeeMomentType == "Romantic" }
                       
                       if romanticMomentExists {
                           isActiveList[loveInFirstSipIndex] = true
                       }
                   }
            
           
            if let friendsSipIndex = captions.firstIndex(of:  NSLocalizedString("friends_sip", comment: "")) {
                      let friendsMomentExists = journalEntries.contains { $0.coffeeMomentType == "Friends" }
                      
                      if friendsMomentExists {
                          isActiveList[friendsSipIndex] = true
                      }
                  }
            
          
            if let specialMomentsIndex = captions.firstIndex(of:   NSLocalizedString("special_moments", comment: "")) {
                    let specialMomentCount = journalEntries.filter {
                        $0.coffeeMomentType == "Friends" || $0.coffeeMomentType == "Romantic"
                    }.count
                    
                    if specialMomentCount >= 20 {
                        isActiveList[specialMomentsIndex] = true
                    }
                }
            
          
            if let romanceInTheCupIndex = captions.firstIndex(of:   NSLocalizedString("romance_in_cup", comment: "")) {
                     let romanticEntries = journalEntries.filter { $0.coffeeMomentType == "Romantic" }
                     let uniqueCoffeeTypes = Set(romanticEntries.map { $0.coffeeType })
                     
                     if uniqueCoffeeTypes.count >= 10 {
                         isActiveList[romanceInTheCupIndex] = true
                     }
                 }
            
          
            if let chatInTheCupIndex = captions.firstIndex(of: NSLocalizedString("chat_in_cup", comment: "")) {
                        let chatEntriesByMonth = journalEntries
                            .filter { $0.coffeeMomentType == "Chat" }
                            .reduce(into: [String: Int]()) { counts, entry in
                                let dateComponents = entry.journalEntryDate.split(separator: "-")
                                if dateComponents.count >= 2 {
                                    let yearMonthKey = "\(dateComponents[0])-\(dateComponents[1])"
                                    counts[yearMonthKey, default: 0] += 1
                                }
                            }
                        
                        if chatEntriesByMonth.values.contains(where: { $0 >= 5 }) {
                            isActiveList[chatInTheCupIndex] = true
                        }
                    }
           
            
            if let coffeeJourneyIndex = captions.firstIndex(of: NSLocalizedString("coffee_journey", comment: "")) {
                       let requiredCoffeeTypes: Set<String> = [
                           "Espresso", "Americano", "Cappuccino", "Latte", "Mocha",
                           "Macchiato", "Ristretto", "Affogato", "Turkish Coffee", "Irish Coffee",
                           "Vienna Coffee", "Cold Brew", "Frappé", "Café de Olla", "Lungo",
                           "Mazagran", "Shakerato", "Romano", "Breve Coffee"
                       ]
                       let availableCoffeeTypes = Set(journalEntries.map { $0.coffeeType })
                       
                       if requiredCoffeeTypes.isSubset(of: availableCoffeeTypes) {
                           isActiveList[coffeeJourneyIndex] = true
                       }
                   }
            
          
            if let exploreTogetherIndex = captions.firstIndex(of: NSLocalizedString("explore_together", comment: "")) {
                      let friendsEntries = journalEntries.filter { $0.coffeeMomentType == "Friends" }
                      let uniqueCoffeeTypes = Set(friendsEntries.map { $0.coffeeType })
                      
                      if uniqueCoffeeTypes.count >= 10 {
                          isActiveList[exploreTogetherIndex] = true
                      }
                  }
            
           
            if let calmSipsIndex = captions.firstIndex(of: NSLocalizedString("calm_sips", comment: "")) {
                        let calmMomentCount = journalEntries.filter {
                            $0.coffeeMomentType == "Reading" || $0.coffeeMomentType == "Camp"
                        }.count
                        
                        if calmMomentCount >= 10 {
                            isActiveList[calmSipsIndex] = true
                        }
                    }
            
           
            if let chatTourIndex = captions.firstIndex(of:  NSLocalizedString("chat_tour", comment: "")) {
                       let chatEntries = journalEntries.filter { $0.coffeeMomentType == "Chat" }
                       let uniqueCoffeeTypes = Set(chatEntries.map { $0.coffeeType })
                       
                       if uniqueCoffeeTypes.count >= 20 {
                           isActiveList[chatTourIndex] = true
                       }
                   }
            
          
            if let everyMomentIndex = captions.firstIndex(of: NSLocalizedString("every_moment", comment: "")) {
                        let requiredMoments: Set<String> = [
                            "Morning", "Camp", "Chat", "Dessert", "Evening",
                            "Afternoon", "Friends", "Inspiration", "Romantic",
                            "Reading", "Trip", "Work Break"
                        ]
                        let availableMoments = Set(journalEntries.map { $0.coffeeMomentType })
                        
                        if requiredMoments.isSubset(of: availableMoments) {
                            isActiveList[everyMomentIndex] = true
                        }
                    }
        } else {
           
        }
 
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCaptionCell.self, forCellWithReuseIdentifier: ImageCaptionCell.identifier)
        
        view.addSubview(collectionView)
        
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCaptionCell.identifier, for: indexPath) as? ImageCaptionCell else {
            return UICollectionViewCell()
        }
        
        let imageName = imageNames[indexPath.item]
        let caption = captions[indexPath.item]
        let isActive = isActiveList[indexPath.item]
        cell.configure(with: imageName, caption: caption, isActive: isActive)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? ImageCaptionCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let caption = captions[indexPath.item]
        
        switch caption {
            
        case NSLocalizedString("first_sip", comment: ""):
            showRecordActionView(message: NSLocalizedString("first_sip_achievement", comment: ""))
        case NSLocalizedString("morning_brew", comment: ""):
            showRecordActionView(message: NSLocalizedString("morning_brew_achievement", comment: ""))
        case NSLocalizedString("sweet_moments", comment: ""):
            showRecordActionView(message: NSLocalizedString("flavor_harmony_achievement", comment: ""))
        case NSLocalizedString("favorite_coffee_quest", comment: ""):
            showRecordActionView(message: NSLocalizedString("crown_favorite_coffee", comment: ""))
        case NSLocalizedString("sweet_coffee_stop", comment: ""):
            showRecordActionView(message: NSLocalizedString("delicious_achievement", comment: ""))
        case NSLocalizedString("taste_of_repetition", comment: ""):
            showRecordActionView(message: NSLocalizedString("relive_coffee_achievement", comment: ""))
        case NSLocalizedString("motivation_filter", comment: ""):
            showRecordActionView(message: NSLocalizedString("work_break_energy", comment: ""))
        case NSLocalizedString("work_break_revitalizer", comment: ""):
            showRecordActionView(message: NSLocalizedString("work_break_ritual", comment: ""))
        case NSLocalizedString("natures_brew", comment: ""):
            showRecordActionView(message: NSLocalizedString("camp_coffee_achievement", comment: ""))
        case NSLocalizedString("inspiration_with_coffee", comment: ""):
            showRecordActionView(message: NSLocalizedString("inspiring_coffee_achievement", comment: ""))
        case NSLocalizedString("different_sips", comment: ""):
            showRecordActionView(message: NSLocalizedString("flavor_map_achievement", comment: ""))
        case NSLocalizedString("world_coffees", comment: ""):
            showRecordActionView(message: NSLocalizedString("cultural_flavors", comment: ""))
        case NSLocalizedString("gourmet_coffee_expert", comment: ""):
            showRecordActionView(message: NSLocalizedString("exquisite_coffees", comment: ""))
        case NSLocalizedString("cold_enthusiast", comment: ""):
            showRecordActionView(message: NSLocalizedString("cool_success", comment: ""))
        case NSLocalizedString("night_owl", comment: ""):
            showRecordActionView(message: NSLocalizedString("spirit_of_night", comment: ""))
        case NSLocalizedString("travelers_cup", comment: ""):
            showRecordActionView(message: NSLocalizedString("taste_world", comment: ""))
        case NSLocalizedString("coffee_classic", comment: ""):
            showRecordActionView(message: NSLocalizedString("crown_culture", comment: ""))
        case NSLocalizedString("white_coffee", comment: ""):
            showRecordActionView(message: NSLocalizedString("explore_smoothness", comment: ""))
        case NSLocalizedString("love_in_first_sip", comment: ""):
            showRecordActionView(message: NSLocalizedString("romantic_moment", comment: ""))
        case NSLocalizedString("romance_in_cup", comment: ""):
            showRecordActionView(message: NSLocalizedString("crown_love_moments", comment: ""))
        case NSLocalizedString("friends_sip", comment: ""):
            showRecordActionView(message: NSLocalizedString("first_coffee_friend", comment: ""))
        case NSLocalizedString("special_moments", comment: ""):
            showRecordActionView(message: NSLocalizedString("friendship_love_moments", comment: ""))
        case NSLocalizedString("chat_in_cup", comment: ""):
            showRecordActionView(message: NSLocalizedString("deepen_conversations", comment: ""))
        case NSLocalizedString("coffee_journey", comment: ""):
            showRecordActionView(message: NSLocalizedString("discover_all_coffee_types", comment: ""))
        case NSLocalizedString("explore_together", comment: ""):
            showRecordActionView(message: NSLocalizedString("share_coffee_with_friends", comment: ""))
        case NSLocalizedString("calm_sips", comment: ""):
            showRecordActionView(message: NSLocalizedString("discover_worlds_with_coffee", comment: ""))
        case NSLocalizedString("chat_tour", comment: ""):
            showRecordActionView(message: NSLocalizedString("enhance_conversations_with_coffee", comment: ""))
        case NSLocalizedString("every_moment", comment: ""):
            showRecordActionView(message: NSLocalizedString("experience_all_coffee_moments", comment: ""))
        default:
            break
        }
    }
    
    private func showRecordActionView(message: String) {
        let requiredView = RequiredActionView(frame: view.bounds)
        requiredView.configure(icon: nil, message: message)
        
        if let requiredActionView = requiredActionView {
            requiredActionView.removeFromSuperview()
        }
        
        requiredActionView = requiredView
        view.addSubview(requiredView)
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            requiredView.removeFromSuperview()
        }
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 3
        return CGSize(width: width, height: 150)
    }
}



   class ImageCaptionCell: UICollectionViewCell {
       static let identifier = "ImageCaptionCell"
       
       private let containerView: UIView = {
           let view = UIView()
           view.backgroundColor = AppColors.color9
           view.layer.cornerRadius = 20
           view.layer.borderWidth = 0.5
           view.layer.borderColor = AppColors.color10.cgColor
           view.layer.shadowColor = UIColor.black.cgColor
           view.layer.shadowOpacity = 0.15
           view.layer.shadowOffset = CGSize(width: 0, height: 4)
           view.layer.shadowRadius = 6
           view.clipsToBounds = false
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
       
       private let imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
       
       private let captionLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
           label.textColor = AppColors.color11
           label.textAlignment = .center
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           
           contentView.addSubview(containerView)
           containerView.addSubview(imageView)
           contentView.addSubview(captionLabel)

          
           NSLayoutConstraint.activate([
               containerView.widthAnchor.constraint(equalToConstant: 90),
               containerView.heightAnchor.constraint(equalToConstant: 90),
               containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
               
               imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
               imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
               imageView.widthAnchor.constraint(equalToConstant: 48),
               imageView.heightAnchor.constraint(equalToConstant: 48),
               
               captionLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
               captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
               captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
               captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
           ])
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func configure(with imageName: String, caption: String, isActive: Bool) {
           imageView.image = UIImage(named: imageName)
           captionLabel.text = caption
           
        
           if isActive {
               contentView.alpha = 1.0
               imageView.alpha = 1.0
               captionLabel.textColor = AppColors.color11
           } else {
               contentView.alpha = 0.5 
               imageView.alpha = 0.5
               captionLabel.textColor = UIColor.lightGray
           }
       }
       
       func adjustImagePosition(offsetX: CGFloat) {
           imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: offsetX).isActive = true
       }
   }
