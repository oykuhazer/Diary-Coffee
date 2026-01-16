//
//  CoffeeAchievementLockView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 14.11.2024.
//

import UIKit

protocol CoffeeAchievementLockViewDelegate: AnyObject {
    func didTapMoreButton()
}

class CoffeeAchievementLockView: UIView {
    let titleLabel = UILabel()
    let countLabel = UILabel()
    let moreButton = UIButton(type: .system)
    
    weak var delegate: CoffeeAchievementLockViewDelegate?

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
    
    private var isActiveList: [Bool] = []
    private var imageViews: [UIImageView] = []
    private var captionLabels: [UILabel] = []
    private var stackViews: [UIStackView] = []
    private var mainStackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 16

        titleLabel.text = NSLocalizedString("journey_of_the_cup", comment: "")
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColors.color51
        self.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])

        let moreImage = UIImage(systemName: "ellipsis")
        moreButton.setImage(moreImage, for: .normal)
        moreButton.tintColor = AppColors.color51
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        self.addSubview(moreButton)

        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        let lineView = UIView()
        lineView.backgroundColor = titleLabel.textColor
        self.addSubview(lineView)

        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])

        for (name, caption) in zip(imageNames, captions) {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.widthAnchor.constraint(equalToConstant: 90).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            containerView.layer.cornerRadius = 20
            containerView.layer.borderWidth = 0.5
            containerView.layer.borderColor = AppColors.color10.cgColor
            containerView.backgroundColor = .white
            containerView.clipsToBounds = false
            
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            imageViews.append(imageView)

            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 40),
                imageView.heightAnchor.constraint(equalToConstant: 40)
            ])

            let captionLabel = UILabel()
            captionLabel.text = caption
            captionLabel.font = UIFont.systemFont(ofSize: 12)
            captionLabel.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 0.5)
            captionLabel.textAlignment = .center
            captionLabels.append(captionLabel)

            let stackView = UIStackView(arrangedSubviews: [containerView, captionLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 20
            stackViews.append(stackView)
        }

        mainStackView = UIStackView(arrangedSubviews: stackViews)
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 30
        self.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        countLabel.text = "0 / 28"
        countLabel.font = UIFont.boldSystemFont(ofSize: 18)
        countLabel.textColor = titleLabel.textColor
        self.addSubview(countLabel)

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10),
            countLabel.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 10)
        ])
    }

    @objc private func moreButtonTapped() {
        delegate?.didTapMoreButton()
    }

    func updateActiveList(journalEntries: [JournalEntryInfo]) {
        isActiveList = Array(repeating: false, count: imageNames.count)

        if journalEntries.isEmpty {
             
               if let firstSipIndex = captions.firstIndex(of: NSLocalizedString("first_sip", comment: "")) {
                   isActiveList[firstSipIndex] = false
               }
               if let morningBrewIndex = captions.firstIndex(of: NSLocalizedString("morning_brew", comment: "")) {
                   isActiveList[morningBrewIndex] = false
               }
               if let sweetMomentsIndex = captions.firstIndex(of: NSLocalizedString("sweet_moments", comment: "")) {
                   isActiveList[sweetMomentsIndex] = false
               }

               DispatchQueue.main.async {
                   self.reorderAchievements()
                   self.updateCountLabel()
               }
               return
           }

        if !journalEntries.isEmpty {
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
        }

        DispatchQueue.main.async {
            self.reorderAchievements()
            self.updateCountLabel()
        }
    }

    private func updateCountLabel() {
        let activeCount = isActiveList.filter { $0 }.count
        countLabel.text = "\(activeCount) / \(isActiveList.count)"
    }
    
    private func reorderAchievements() {
        let activeStackViews = zip(stackViews, isActiveList)
            .filter { $0.1 }
            .map { $0.0 }

        var passiveStackViews = zip(stackViews, isActiveList)
            .filter { !$0.1 }
            .map { $0.0 }

        var selectedStackViews: [UIStackView] = []

      
        selectedStackViews.append(contentsOf: activeStackViews.prefix(3))

       
        while selectedStackViews.count < 3, !passiveStackViews.isEmpty {
            selectedStackViews.append(passiveStackViews.removeFirst())
        }

      
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        selectedStackViews.forEach { mainStackView.addArrangedSubview($0) }

        refreshUI()
        updateCountLabel()
    }

    private func refreshUI() {
        for (index, imageView) in imageViews.enumerated() {
            let isActive = isActiveList[index]
            imageView.alpha = isActive ? 1.0 : 0.1
            captionLabels[index].alpha = isActive ? 1.0 : 0.5
        }
    }
    
    func setPremiumStatus(isPremium: Bool) {
           moreButton.isEnabled = isPremium
          
       }
}
