//
//  CoffeeMoodScore.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 8.11.2024.
//


import UIKit

class CoffeeMoodScoreView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("coffee_mood_score", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = AppColors.color51
        return label
    }()
    
    private let exercisesContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.color20.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    private let exercisesLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("moods_logged", comment: "")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppColors.color20
        return label
    }()
    
    var exercisesValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = AppColors.color20
        return label
    }()
    
    private let averageLengthContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.color20.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    private let averageLengthLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("coffee_logged", comment: "")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppColors.color20
        return label
    }()
    
    var averageLengthValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = AppColors.color20
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         return formatter
     }()
    
    private let moodBarsContainer = UIView()
    private var moodBars: [UIView] = []
    private var moodImages: [UIImageView] = []
    private let imageNames = ["a", "b", "c", "d", "e", "f"]
    private let barColors: [String: UIColor] = [
        "kissing": AppColors.color83,
        "smile": AppColors.color82,
        "wow": AppColors.color85,
        "sleep": AppColors.color84,
        "angry": AppColors.color87,
        "sad":  AppColors.color86
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 16
        
        addSubview(titleLabel)
        addSubview(exercisesContainerView)
        addSubview(averageLengthContainerView)
        addSubview(moodBarsContainer)
        
        exercisesContainerView.addSubview(exercisesLabel)
        exercisesContainerView.addSubview(exercisesValueLabel)
        averageLengthContainerView.addSubview(averageLengthLabel)
        averageLengthContainerView.addSubview(averageLengthValueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        exercisesContainerView.translatesAutoresizingMaskIntoConstraints = false
        exercisesLabel.translatesAutoresizingMaskIntoConstraints = false
        exercisesValueLabel.translatesAutoresizingMaskIntoConstraints = false
        averageLengthContainerView.translatesAutoresizingMaskIntoConstraints = false
        averageLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        averageLengthValueLabel.translatesAutoresizingMaskIntoConstraints = false
        moodBarsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            exercisesContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            exercisesContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            exercisesContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -24),
            exercisesContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            exercisesLabel.topAnchor.constraint(equalTo: exercisesContainerView.topAnchor, constant: 12),
            exercisesLabel.leadingAnchor.constraint(equalTo: exercisesContainerView.leadingAnchor, constant: 8),
            
            exercisesValueLabel.bottomAnchor.constraint(equalTo: exercisesContainerView.bottomAnchor, constant: -12),
            exercisesValueLabel.leadingAnchor.constraint(equalTo: exercisesContainerView.leadingAnchor, constant: 8),
            
            averageLengthContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            averageLengthContainerView.leadingAnchor.constraint(equalTo: exercisesContainerView.trailingAnchor, constant: 16),
            averageLengthContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -24),
            averageLengthContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            averageLengthLabel.topAnchor.constraint(equalTo: averageLengthContainerView.topAnchor, constant: 12),
            averageLengthLabel.leadingAnchor.constraint(equalTo: averageLengthContainerView.leadingAnchor, constant: 8),
            
            averageLengthValueLabel.bottomAnchor.constraint(equalTo: averageLengthContainerView.bottomAnchor, constant: -12),
            averageLengthValueLabel.leadingAnchor.constraint(equalTo: averageLengthContainerView.leadingAnchor, constant: 8),
            
            moodBarsContainer.topAnchor.constraint(equalTo: exercisesContainerView.bottomAnchor, constant: 10),
            moodBarsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            moodBarsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moodBarsContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
       updateMoodCounts(entries: [])
    }
    
    
    func configureWith(dateYear: Int, dateMonth: Int?, entries: [JournalEntryInfo]) {
     
        update(forYear: dateYear, month: dateMonth, withEntries: entries)
    }

    func update(forYear year: Int, month: Int?, withEntries entries: [JournalEntryInfo]) {
        let filteredEntries = entries.filter {
            guard let entryDate = dateFormatter.date(from: $0.journalEntryDate) else { return false }
            let calendar = Calendar.current
            let isYearMatch = calendar.component(.year, from: entryDate) == year
            if let month = month {
                return isYearMatch && calendar.component(.month, from: entryDate) == month
            }
            return isYearMatch
        }

    
        if filteredEntries.isEmpty {
            showLockOverlay()
        } else {
            removeLockOverlay()
        }

        exercisesValueLabel.text = "\(filteredEntries.count)"
        let uniqueMoodTypes = Set(filteredEntries.map { $0.coffeeMoodType }).count
        averageLengthValueLabel.text = "\(uniqueMoodTypes)"

        updateMoodCounts(entries: filteredEntries)
    }



    func configure(entries: [JournalEntryInfo]) {
      
        if entries.isEmpty {
            showLockOverlay()
        } else {
            removeLockOverlay()
            updateMoodCounts(entries: entries)
        }
    }

    func updateMoodImages(with imageUrls: [String]) {
        let moodOrder = ["kissing", "smile", "wow", "sleep", "angry", "sad"]
        
        let dispatchGroup = DispatchGroup()
        var loadedImages: [UIImage?] = Array(repeating: nil, count: moodOrder.count)
        var isClassicSet: [Bool] = Array(repeating: false, count: moodOrder.count)
        
       
        let sortedUrls = moodOrder.compactMap { mood in
            imageUrls.first { $0.contains(mood) }
        }
        
      
        for (index, url) in sortedUrls.enumerated() {
            if url.contains("ClassicSet") {
                isClassicSet[index] = true
            }
        }

        for (index, urlString) in sortedUrls.enumerated() {
            guard let imageUrl = URL(string: urlString) else {
                continue
            }
            
            dispatchGroup.enter()
            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                defer { dispatchGroup.leave() }
                
                if let error = error {
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                loadedImages[index] = image
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            for (index, imageView) in self.moodImages.enumerated() {
                if index < loadedImages.count, let image = loadedImages[index] {
                    imageView.image = image
                    imageView.isHidden = false
                    
                 
                    if !isClassicSet[index] {
                        imageView.tag = 1
                    } else {
                        imageView.tag = 0
                    }

                   
                    self.updateImageViewSize(imageView: imageView, previousBar: index > 0 ? self.moodBars[index - 1] : nil)
                } else {
                    imageView.image = UIImage(named: "placeholder")
                    imageView.isHidden = false
                }
            }
        }
    }

    private func updateImageViewSize(imageView: UIImageView, previousBar: UIView?) {
        NSLayoutConstraint.deactivate(imageView.constraints)

        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: previousBar?.bottomAnchor ?? moodBarsContainer.topAnchor,
                                           constant: imageView.tag == 1 ? 7 : 18),
            
           
            imageView.leadingAnchor.constraint(equalTo: moodBarsContainer.leadingAnchor,
                                               constant: imageView.tag == 1 ? -10 : 0),

          
            imageView.widthAnchor.constraint(equalToConstant: imageView.tag == 1 ? 65 : 40),
            imageView.heightAnchor.constraint(equalToConstant: imageView.tag == 1 ? 65 : 40)
        ])
        
        self.layoutIfNeeded()
    }

    private func showLockOverlay() {
        if let existingOverlay = self.viewWithTag(999) {
            existingOverlay.frame = self.bounds
            return
        }
        
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
        messageLabel.text = NSLocalizedString("start_logging_coffee_moods", comment: "")
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

    
    private func removeLockOverlay() {
        DispatchQueue.main.async {
            if let overlay = self.viewWithTag(999) {
              
                overlay.removeFromSuperview()
            } else {
             
            }
        }
    }

    
    func updateMoodCounts(entries: [JournalEntryInfo]) {
      
        moodBars.forEach { $0.removeFromSuperview() }
        moodImages.forEach { $0.removeFromSuperview() }
        moodBars.removeAll()
        moodImages.removeAll()
        moodBarsContainer.subviews.forEach { $0.removeFromSuperview() }

      
        let moodCounts: [String: Int] = entries.reduce(into: [:]) { counts, entry in
            if let moodType = extractMoodType(from: entry.coffeeMoodType) {
                counts[moodType, default: 0] += 1
            }
        }

        
        let moodOrder = ["kissing", "smile", "wow", "sleep", "angry", "sad"]
        var previousBar: UIView? = nil

        for mood in moodOrder {
            let imageView = UIImageView(image: UIImage(named: mood))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            moodBarsContainer.addSubview(imageView)
            moodImages.append(imageView)
            
            let count = moodCounts[mood] ?? 0
            let barColor = barColors[mood] ?? UIColor.gray
            
            let bar = UIView()
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = 5
            bar.translatesAutoresizingMaskIntoConstraints = false
            moodBarsContainer.addSubview(bar)
            moodBars.append(bar)

            NSLayoutConstraint.activate([
                        
                         imageView.topAnchor.constraint(equalTo: previousBar?.bottomAnchor ?? moodBarsContainer.topAnchor,
                                                        constant: imageView.tag == 1 ? 7 : 18),
                         
                         imageView.leadingAnchor.constraint(equalTo: moodBarsContainer.leadingAnchor),

                       
                         imageView.widthAnchor.constraint(equalToConstant: imageView.tag == 1 ? 55 : 40),
                         imageView.heightAnchor.constraint(equalToConstant: imageView.tag == 1 ? 55 : 40),
                         
                         bar.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                         bar.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                         bar.heightAnchor.constraint(equalToConstant: 10),
                         bar.widthAnchor.constraint(equalToConstant: count > 0 ? CGFloat(count * 20) : 10)
                     ])
            
            if count > 0 {
                let countLabel = UILabel()
                countLabel.text = "x\(count)"
                countLabel.font = UIFont.boldSystemFont(ofSize: 14)
                countLabel.textColor = barColor
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                moodBarsContainer.addSubview(countLabel)
                
                NSLayoutConstraint.activate([
                    countLabel.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
                    countLabel.leadingAnchor.constraint(equalTo: bar.trailingAnchor, constant: 8)
                ])
            }
            
            previousBar = bar
        }
    }

    private func extractMoodType(from url: String) -> String? {
       
        guard let lastPathComponent = URL(string: url)?.lastPathComponent else { return nil }
        let moodType = lastPathComponent.replacingOccurrences(of: ".png", with: "")
        return moodType
    }

    
}
