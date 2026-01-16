//
//  MoodStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//

import UIKit

class MoodStatusView: UIView {
    
    let titleLabel = UILabel()
    private var moodImageViews: [UIImageView] = []
    private let imageOrder = ["kissing", "smile", "wow", "sleep", "angry", "sad"]

    let imageCache = NSCache<NSString, UIImage>()
    
    private let sampleLabel: SampleLabel = {
           let label = SampleLabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    private let dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         return formatter
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setPremiumStatus(isPremium: Bool) {
        sampleLabel.isHidden = isPremium

        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }
    private func getDeviceWidth() -> CGFloat {
           return UIScreen.main.bounds.width
       }

       
       private func getDeviceScale() -> CGFloat {
           return UIScreen.main.scale
       }

    
       private func isTargetDevice() -> Bool {
           let screenWidth = getDeviceWidth()
           
          
           let targetWidths: [CGFloat] = [390, 393]
           return targetWidths.contains(screenWidth)
       }

    
    private func isTargetDevice414() -> Bool {
        return getDeviceWidth() == 414
    }
    
    private func isTargetDevice375() -> Bool {
        return getDeviceWidth() == 375
    }
    
    private func setupUI() {
       
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 16
        titleLabel.text = NSLocalizedString("mood_statistics", comment: "")
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColors.color51
        
        self.addSubview(titleLabel)
        self.addSubview(sampleLabel)
      
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            sampleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            sampleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            sampleLabel.widthAnchor.constraint(equalToConstant: 80),
            sampleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

    }
    
    
    func updateView(with entries: [JournalEntryInfo]) {
        if entries.isEmpty {
            
         
        } else {
           
            
            configureWithEntries(entries)
        }
    }

    func configureWithEntries(_ entries: [JournalEntryInfo]) {
        moodImageViews.removeAll()

        self.subviews.forEach { subview in
            if subview !== titleLabel && subview !== sampleLabel {
                subview.removeFromSuperview()
            }
        }

        self.addSubview(titleLabel)
        self.addSubview(sampleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            sampleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            sampleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            sampleLabel.widthAnchor.constraint(equalToConstant: 80),
            sampleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

        let moodData: [(mood: String, color: UIColor, percentage: Double)]
        
        if entries.isEmpty {
            let defaultColors: [UIColor] = [
                AppColors.color83,
                AppColors.color82,
                AppColors.color85,
                AppColors.color84,
                AppColors.color87,
                AppColors.color86
            ]
            moodData = (0..<6).map { index in
                (mood: "default", color: defaultColors[index], percentage: 100.0 / 6.0)
            }
        } else {
            moodData = calculateMoodPercentages(for: entries)
        }

        let pieChartView = create3DPieChartWithColors(moodData: moodData)
        self.addSubview(pieChartView)

        let moodStackView = UIStackView()
        moodStackView.axis = .vertical
        moodStackView.alignment = .leading
        moodStackView.distribution = .equalSpacing
        moodStackView.spacing = 0
        moodStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(moodStackView)

        for data in moodData {
            let moodView = UIView()
            moodView.translatesAutoresizingMaskIntoConstraints = false

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            moodView.addSubview(imageView)
            moodImageViews.append(imageView)

            let percentageLabel = UILabel()
            percentageLabel.text = "\(String(format: "%.1f", data.percentage))%"
            percentageLabel.font = UIFont.boldSystemFont(ofSize: 15)
            percentageLabel.textColor = data.color
            percentageLabel.translatesAutoresizingMaskIntoConstraints = false
            moodView.addSubview(percentageLabel)

            moodStackView.addArrangedSubview(moodView)

            let isClassicSet = imageView.image?.accessibilityIdentifier?.contains("ClassicSet") ?? false

            let imageSize: CGFloat
            let leadingConstant: CGFloat

            if isTargetDevice() {
                imageSize = isClassicSet ? 40 : 55
                leadingConstant = isClassicSet ? 25 : 5
                
            } else if isTargetDevice375() {
                imageSize = isClassicSet ? 40 : 50
                leadingConstant = isClassicSet ? 35 : -5
                
            } else if isTargetDevice414() {
                imageSize = isClassicSet ? 40 : 55
                leadingConstant = isClassicSet ? 30 : 5
                
            } else {
                imageSize = isClassicSet ? 40 : 60
                leadingConstant = isClassicSet ? 40 : 30
            }


            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: imageSize),
                imageView.heightAnchor.constraint(equalToConstant: imageSize),
                imageView.leadingAnchor.constraint(equalTo: moodView.leadingAnchor, constant: leadingConstant),
                imageView.centerYAnchor.constraint(equalTo: moodView.centerYAnchor),

                percentageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
                percentageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                percentageLabel.trailingAnchor.constraint(equalTo: moodView.trailingAnchor),

                moodView.heightAnchor.constraint(equalToConstant: 45)
            ])
        }

        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            pieChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            pieChartView.widthAnchor.constraint(equalToConstant: 160),
            pieChartView.heightAnchor.constraint(equalToConstant: 160),

            moodStackView.leadingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 30),
            moodStackView.centerYAnchor.constraint(equalTo: pieChartView.centerYAnchor),
            moodStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    
    func update(forYear year: Int, month: Int?, withEntries entries: [JournalEntryInfo]) {
        if let selectedMonth = month {
           
            let filteredEntries = entries.filter {
                guard let entryDate = dateFormatter.date(from: $0.journalEntryDate) else { return false }
                let calendar = Calendar.current
                return calendar.component(.year, from: entryDate) == year &&
                       calendar.component(.month, from: entryDate) == selectedMonth
            }
            configureWithEntries(filteredEntries)
        } else {
          
            let filteredEntries = entries.filter {
                guard let entryDate = dateFormatter.date(from: $0.journalEntryDate) else { return false }
                let calendar = Calendar.current
                return calendar.component(.year, from: entryDate) == year
            }
            configureWithEntries(filteredEntries)
        }
    }


    func updateMoodImages(with imageUrls: [String]) {
        let sortedUrls = sortImageUrls(imageUrls)

        let dispatchGroup = DispatchGroup()
        var loadedImages: [UIImage?] = Array(repeating: nil, count: moodImageViews.count)

        for (index, urlString) in sortedUrls.enumerated() {
            guard let imageUrl = URL(string: urlString) else {
                continue
            }

            dispatchGroup.enter()
            loadImage(from: imageUrl) { image in
                loadedImages[index] = image
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            for (index, imageView) in self.moodImageViews.enumerated() {
                imageView.image = loadedImages[index] ?? UIImage(named: "placeholder")

                let urlString = sortedUrls[index]
                let isClassicSet = urlString.contains("ClassicSet")

                let screenWidth = UIScreen.main.bounds.width

                let isTargetDevice = [390, 393].contains(screenWidth)
                let isTargetDevice414 = screenWidth == 414
                let isTargetDevice375 = screenWidth == 375

                let imageSize: CGFloat
                let leadingConstant: CGFloat

                if isTargetDevice {
                    imageSize = isClassicSet ? 40 : 55
                    leadingConstant = isClassicSet ? 25 : 5
                    
                } else if isTargetDevice375 {
                    imageSize = isClassicSet ? 40 : 50
                    leadingConstant = isClassicSet ? 35 : -5
                    
                } else if isTargetDevice414 {
                    imageSize = isClassicSet ? 40 : 55
                    leadingConstant = isClassicSet ? 30 : 5
                } else {
                    imageSize = isClassicSet ? 40 : 60
                    leadingConstant = isClassicSet ? 40 : 30
                }

                imageView.constraints.forEach { constraint in
                    if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                        imageView.removeConstraint(constraint)
                    }
                }

                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: imageSize),
                    imageView.heightAnchor.constraint(equalToConstant: imageSize),
                    imageView.leadingAnchor.constraint(equalTo: imageView.superview!.leadingAnchor, constant: leadingConstant),
                    imageView.centerYAnchor.constraint(equalTo: imageView.superview!.centerYAnchor)
                ])

                DispatchQueue.main.async {
                    imageView.superview?.layoutIfNeeded()
                    self.layoutIfNeeded()
                }
            }
        }
    }


        private func sortImageUrls(_ imageUrls: [String]) -> [String] {
         
            return imageOrder.compactMap { order in
                imageUrls.first { $0.contains(order) }
            }
        }

  

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
      
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
       
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }



        func removeLockOverlay() {
           if let overlay = self.viewWithTag(999) {
               overlay.removeFromSuperview()
           }
       }


    private func calculateMoodPercentages(for entries: [JournalEntryInfo]) -> [(mood: String, color: UIColor, percentage: Double)] {
        let imageOrder = ["kissing", "smile", "wow", "sleep", "angry", "sad"]
        
       
        var moodCounts: [String: Int] = imageOrder.reduce(into: [:]) { $0[$1] = 0 }
        let totalEntries = entries.count

      
        entries.forEach { entry in
            if let moodKey = imageOrder.first(where: { entry.coffeeMoodType.contains($0) }) {
                moodCounts[moodKey, default: 0] += 1
            }
        }

        let colors: [String: UIColor] = [
            "kissing": AppColors.color83,
            "smile": AppColors.color82,
            "wow": AppColors.color85,
            "sleep": AppColors.color84,
            "angry": AppColors.color87,
            "sad":  AppColors.color86
        ]

        return imageOrder.map { mood in
            let count = moodCounts[mood] ?? 0
            let percentage = totalEntries > 0 ? (Double(count) / Double(totalEntries)) * 100 : 0
            return (mood: mood, color: colors[mood] ?? UIColor.gray, percentage: percentage)
        }
    }


    private func create3DPieChartWithColors(moodData: [(mood: String, color: UIColor, percentage: Double)]) -> UIView {
        let pieChartView = UIView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false

        let radius: CGFloat = 80
        let innerRadius: CGFloat = 35
        let center = CGPoint(x: radius, y: radius)
        var startAngle: CGFloat = -.pi / 2

        for data in moodData {
            let endAngle = startAngle + (CGFloat(data.percentage) / 100.0) * 2 * .pi
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()

            let sliceLayer = CAShapeLayer()
            sliceLayer.path = path.cgPath
            sliceLayer.fillColor = data.color.cgColor
            sliceLayer.shadowColor = UIColor.black.cgColor
            sliceLayer.shadowOpacity = 0.3
            sliceLayer.shadowOffset = CGSize(width: 3, height: 3)
            sliceLayer.shadowRadius = 4
            pieChartView.layer.addSublayer(sliceLayer)

            startAngle = endAngle
        }

        let outerLayer = CAShapeLayer()
        let outerPath = UIBezierPath(arcCenter: center, radius: radius + 12, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        outerLayer.path = outerPath.cgPath
        outerLayer.fillColor = AppColors.color64.cgColor
        pieChartView.layer.insertSublayer(outerLayer, at: 0)

        return pieChartView
    }
}

