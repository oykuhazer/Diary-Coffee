//
//  CoffeeStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 15.10.2024.
//

import UIKit

class CoffeeDailyStatusView: UIView {
    
    let titleLabel = UILabel()
    let stackView = UIStackView()
    let dateLabel = UILabel()
    let lineView = UIView()
    let awardImageView = UIImageView()
    let awardContainerView = UIView()
    var currentDate = Date()
    var journalEntriesInfoList: [JournalEntryInfo] = []
    let streakLabel = UILabel()
    let streakLabelStackView = UIStackView()
    
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
        self.backgroundColor =  AppColors.color2
        self.layer.cornerRadius = 16

       
        titleLabel.text = NSLocalizedString("daily_streak_title", comment: "")
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColors.color51
        self.addSubview(titleLabel)

        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        leftButton.tintColor = AppColors.color52
        leftButton.addTarget(self, action: #selector(previousDay), for: .touchUpInside)
        self.addSubview(leftButton)

        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        rightButton.tintColor = AppColors.color52
        rightButton.addTarget(self, action: #selector(nextDay), for: .touchUpInside)
        self.addSubview(rightButton)

       
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        dateLabel.textColor = AppColors.color30
        updateDateLabel(dateLabel)
        self.addSubview(dateLabel)

       
        let thickBarView = UIView()
        thickBarView.backgroundColor = AppColors.color7
        thickBarView.layer.cornerRadius = 20
        thickBarView.clipsToBounds = true
        self.addSubview(thickBarView)

        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        thickBarView.addSubview(stackView)

        let days = ["P", "S", "Ç", "P", "C", "C", "P"]

        for day in days {
            let verticalStack = UIStackView()
            verticalStack.axis = .vertical
            verticalStack.alignment = .center
            verticalStack.spacing = 5
            stackView.addArrangedSubview(verticalStack)

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            verticalStack.addArrangedSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50)
            ])
           
            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.font = UIFont(name: "Avenir Next", size: 14)
            dayLabel.textAlignment = .center
            dayLabel.textColor = AppColors.color53
            verticalStack.addArrangedSubview(dayLabel)
        }

        lineView.backgroundColor = AppColors.color54
        lineView.layer.cornerRadius = 1
        self.addSubview(lineView)

        awardContainerView.translatesAutoresizingMaskIntoConstraints = false
        awardContainerView.backgroundColor =  AppColors.color55
        awardContainerView.layer.cornerRadius = 25
        awardContainerView.clipsToBounds = true
        self.addSubview(awardContainerView)

        awardImageView.image = UIImage(named: "award")
        awardImageView.contentMode = .scaleAspectFit
        awardImageView.translatesAutoresizingMaskIntoConstraints = false
        awardContainerView.addSubview(awardImageView)
      
        streakLabel.text =  NSLocalizedString("daily_streak_label_zero", comment: "")
        streakLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        streakLabel.textColor = AppColors.color53
        streakLabel.textAlignment = .left
        streakLabelStackView.addArrangedSubview(streakLabel)
        self.addSubview(streakLabelStackView)

        setupConstraints(thickBarView: thickBarView, leftButton: leftButton, rightButton: rightButton)
    }

    private func setupConstraints(thickBarView: UIView, leftButton: UIButton, rightButton: UIButton) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        thickBarView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        streakLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        awardContainerView.translatesAutoresizingMaskIntoConstraints = false
        awardImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

            leftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            leftButton.widthAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalToConstant: 40),

            rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            rightButton.widthAnchor.constraint(equalToConstant: 40),
            rightButton.heightAnchor.constraint(equalToConstant: 40),

            dateLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -10),

            thickBarView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 20),
            thickBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            thickBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            thickBarView.heightAnchor.constraint(equalToConstant: 80),

            stackView.centerXAnchor.constraint(equalTo: thickBarView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: thickBarView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: thickBarView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: thickBarView.trailingAnchor, constant: -20),

            lineView.topAnchor.constraint(equalTo: thickBarView.bottomAnchor, constant: 20),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            lineView.heightAnchor.constraint(equalToConstant: 2),

            awardContainerView.widthAnchor.constraint(equalToConstant: 50),
            awardContainerView.heightAnchor.constraint(equalToConstant: 50),
            awardContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            awardContainerView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20),
            
            awardImageView.centerXAnchor.constraint(equalTo: awardContainerView.centerXAnchor),
            awardImageView.centerYAnchor.constraint(equalTo: awardContainerView.centerYAnchor),
            awardImageView.widthAnchor.constraint(equalToConstant: 30),
            awardImageView.heightAnchor.constraint(equalToConstant: 30),
            
            streakLabelStackView.centerYAnchor.constraint(equalTo: awardContainerView.centerYAnchor),
            streakLabelStackView.leadingAnchor.constraint(equalTo: awardContainerView.trailingAnchor, constant: 20)
        ])
    }

    func configureWithEntries(entries: [JournalEntryInfo]) {
        self.journalEntriesInfoList = entries
        updateStatusImages()
        
        
        let longestStreak = calculateLongestStreak(entries: entries)
        updateStreakLabel(with: longestStreak)
        
       
        if entries.isEmpty {
            self.backgroundColor = AppColors.color81
            self.isUserInteractionEnabled = false
            showDailySeriesLockOverlay()
        } else {
            self.backgroundColor = AppColors.color2
            self.isUserInteractionEnabled = true
            removeDailySeriesLockOverlay()
        }
    }

    private func showDailySeriesLockOverlay() {
        if self.viewWithTag(999) == nil {
            let overlay = UIView(frame: self.bounds)
            overlay.backgroundColor = AppColors.color56
            overlay.isUserInteractionEnabled = false
            overlay.layer.cornerRadius = self.layer.cornerRadius
            overlay.clipsToBounds = true
            overlay.tag = 999
            self.addSubview(overlay)
            overlay.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                overlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                overlay.topAnchor.constraint(equalTo: self.topAnchor),
                overlay.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            
            let lockImageView = UIImageView()
            lockImageView.image = UIImage(systemName: "lock.fill")
            lockImageView.tintColor = AppColors.color2
            lockImageView.contentMode = .scaleAspectFit
            lockImageView.translatesAutoresizingMaskIntoConstraints = false
            overlay.addSubview(lockImageView)
            NSLayoutConstraint.activate([
                lockImageView.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                lockImageView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: -10),
                lockImageView.widthAnchor.constraint(equalToConstant: 50),
                lockImageView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
        
            let messageLabel = UILabel()
            messageLabel.text =  NSLocalizedString("daily_streak_message", comment: "")
            messageLabel.textColor = AppColors.color2
            messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            overlay.addSubview(messageLabel)

            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: lockImageView.bottomAnchor, constant: 15),
                messageLabel.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20),
                messageLabel.centerXAnchor.constraint(equalTo: overlay.centerXAnchor)
            ])

        }
    }


    private func removeDailySeriesLockOverlay() {
        if let overlay = self.viewWithTag(999) {
            overlay.removeFromSuperview()
        }
    }


    private func calculateLongestStreak(entries: [JournalEntryInfo]) -> Int {
        let dates = entries.compactMap { entry in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: entry.journalEntryDate)
        }.sorted()
        
        
        guard dates.count > 1 else {
            return dates.isEmpty ? 0 : 1
        }
        
        var longestStreak = 0
        var currentStreak = 1
        
        for i in 1..<dates.count {
            if let previousDate = Calendar.current.date(byAdding: .day, value: 1, to: dates[i - 1]), previousDate == dates[i] {
                currentStreak += 1
            } else {
                longestStreak = max(longestStreak, currentStreak)
                currentStreak = 1
            }
        }
        
        longestStreak = max(longestStreak, currentStreak)
        return longestStreak
    }

    private func updateStreakLabel(with streak: Int) {
        let streakText = String(
            format: NSLocalizedString("daily_streak_label", comment: ""),
            streak
        )
        streakLabel.text = streakText
    }


    private func updateStatusImages() {
        for index in 0..<7 {
            guard let dayDate = Calendar.current.date(byAdding: .day, value: index, to: currentDate) else { continue }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dayString = dateFormatter.string(from: dayDate)
            
            let hasEntry = journalEntriesInfoList.contains { $0.journalEntryDate == dayString }
            let imageName = hasEntry ? "coffeedailystatusactive" : "coffeedailystatuspassive"
            if let verticalStack = stackView.arrangedSubviews[index] as? UIStackView,
               let imageView = verticalStack.arrangedSubviews.first as? UIImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    private func updateDateLabel(_ label: UILabel) {
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: currentDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let startDateString = dateFormatter.string(from: currentDate)
        let endDateString = dateFormatter.string(from: endDate!)
        label.text = "\(startDateString) - \(endDateString)"
    }

    @objc private func previousDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? Date()
        updateDateLabel(dateLabel)
        updateStatusImages()
    }

    @objc private func nextDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate) ?? Date()
        updateDateLabel(dateLabel)
        updateStatusImages()
    }
    
    func updateDateLabelWithYearAndMonth(year: Int, month: Int?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"

        if let month = month {
            let startDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
            let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate) ?? startDate

            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)

            dateLabel.text = "\(startDateString) - \(endDateString)"

            currentDate = startDate
            
        } else {
            let startDate = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
            let endDate = Calendar.current.date(from: DateComponents(year: year, month: 12, day: 31))!

            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)

            dateLabel.text = "\(startDateString) - \(endDateString)"

            currentDate = startDate
        }

      
        updateStatusImages()
    }



}
