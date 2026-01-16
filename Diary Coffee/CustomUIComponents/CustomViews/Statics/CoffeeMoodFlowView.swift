//
//  CoffeeMoodFlowView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 13.11.2024.
//

import UIKit

class CoffeeMoodFlowView: UIView {
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    private var currentEntries: [(date: String, mood: String)] = []

    private let startY: CGFloat = 70
    private let endY: CGFloat = 285

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("mood_flow", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = AppColors.color51
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var moodImages: [UIImage?] = [
        UIImage(named: "a"),
        UIImage(named: "b"),
        UIImage(named: "c"),
        UIImage(named: "d"),
        UIImage(named: "e"),
        UIImage(named: "f")
    ]


    private let chartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color2
        view.layer.cornerRadius = 16
        return view
    }()
    
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

        addSubview(chartView)
        chartView.addSubview(titleLabel)

       
        let containsClassicSet = moodImages.contains { image in
            image?.accessibilityIdentifier?.contains("ClassicSet") == true
        }

       
        setupMoodIndicators(containsClassicSet: containsClassicSet)

        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 16)
        ])
    }



    func updateMoodImages(with imageUrls: [String]) {
        chartView.subviews.filter { $0 is UIImageView }.forEach { $0.removeFromSuperview() }

        let orderedKeys = ["kissing", "smile", "wow", "sleep", "angry", "sad"]
        let sortedUrls = imageUrls.sorted { firstUrl, secondUrl in
            let firstIndex = orderedKeys.firstIndex { firstUrl.contains($0) } ?? Int.max
            let secondIndex = orderedKeys.firstIndex { secondUrl.contains($0) } ?? Int.max
            return firstIndex < secondIndex
        }

        moodImages = Array(repeating: nil, count: sortedUrls.count)

        var containsClassicSet = false

        for (index, urlString) in sortedUrls.enumerated() {
            guard let url = URL(string: urlString) else { continue }

            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    self.moodImages[index] = image

                  
                    if urlString.contains("ClassicSet") {
                        containsClassicSet = true
                    }

                    self.setupMoodIndicators(containsClassicSet: containsClassicSet)
                }
            }.resume()
        }
    }

    private func setupMoodIndicators(containsClassicSet: Bool) {
        chartView.subviews.filter { $0 is UIImageView }.forEach { $0.removeFromSuperview() }

        var imageSize: CGFloat = 30
        var totalHeight = endY - startY - 10
        var spacing = totalHeight / CGFloat(moodImages.count - 1)
        var startYOffset: CGFloat = startY

        if !containsClassicSet {
            imageSize = 50
            totalHeight *= 0.95
            spacing = totalHeight / CGFloat(moodImages.count - 1)
            startYOffset -= 5
        }

        for (index, image) in moodImages.enumerated() {
            guard let image = image else { continue }
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            chartView.addSubview(imageView)

            let leadingConstant: CGFloat = containsClassicSet ? 16 : 5

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: imageSize),
                imageView.heightAnchor.constraint(equalToConstant: imageSize),
                imageView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: leadingConstant),
                imageView.topAnchor.constraint(equalTo: chartView.topAnchor, constant: startYOffset + CGFloat(index) * spacing - 10)
            ])
        }
    }


    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 16, y: 16)

        if let overlay = self.viewWithTag(999) {
            overlay.frame = self.bounds
        }

        setupChart()

     
        if currentEntries.isEmpty {
            showDailySeriesLockOverlay()
        } else {
            removeLockOverlay()
        }
    }


    
    func configureWithEntries(entries: [(date: String, mood: String)]) {
        currentEntries = entries


        if entries.isEmpty {
            showDailySeriesLockOverlay()
        } else {
            removeLockOverlay()
            DispatchQueue.main.async {
                self.drawMoodChart(entries: entries)
            }
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
            messageLabel.text = NSLocalizedString("start_mood_flow", comment: "")
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

    private func removeLockOverlay() {
        if let overlay = self.viewWithTag(999) {
            overlay.removeFromSuperview()
        }
    }

    private func getSpacingFactor() -> CGFloat {
        let deviceModel = UIDevice.current.name.lowercased()

        let specialDevices = [
            "iphone 12 pro max",
            "iphone 13 pro max",
            "iphone 14 plus",
            "iphone 14 pro max",
            "iphone 15 plus",
            "iphone 15 pro max",
            "iphone 11",
            "iphone xr",
            "iphone 11 pro max",
            "iphone xs max",
            "iphone 8 plus",
            "iphone 7 plus",
            "iphone 6s plus",
        ]

        return specialDevices.contains(deviceModel) ? 1.2 : 1.3
    }

    func setupChart() {
        chartView.layer.sublayers?.removeAll { $0 is CAShapeLayer }
        chartView.subviews.forEach { if $0 is UILabel && $0 != titleLabel { $0.removeFromSuperview() } }

        let lineColor = AppColors.color57.cgColor
        let startX: CGFloat = 90
        let totalWidth = chartView.bounds.width - 2 * startX

        let calendar = Calendar.current
        let baseDateComponents = DateComponents(year: selectedYear, month: selectedMonth, day: 1)
        guard let baseDate = calendar.date(from: baseDateComponents),
              let daysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count else { return }

        let lineCount = 6
        let spacingFactor: CGFloat = getSpacingFactor()
        let lineSpacing = (totalWidth / CGFloat(lineCount - 1)) * spacingFactor

        for i in 0..<lineCount {
            let lineLayer = CAShapeLayer()
            let linePath = UIBezierPath()

            let xPosition = startX + CGFloat(i) * lineSpacing

            linePath.move(to: CGPoint(x: xPosition, y: startY))
            linePath.addLine(to: CGPoint(x: xPosition, y: endY))

            lineLayer.path = linePath.cgPath
            lineLayer.strokeColor = lineColor
            lineLayer.lineWidth = 2
            chartView.layer.addSublayer(lineLayer)

            let dateLabel = UILabel()
            dateLabel.font = UIFont.systemFont(ofSize: 12)
            dateLabel.textColor = AppColors.color51
            dateLabel.textAlignment = .center

            let dayOffset = Int((Double(daysInMonth - 1) / Double(lineCount - 1)) * Double(i))
            let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: baseDate)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d"
            dateLabel.text = dateFormatter.string(from: currentDate ?? baseDate)

            chartView.addSubview(dateLabel)
            dateLabel.sizeToFit()
            dateLabel.frame = CGRect(
                x: xPosition - (dateLabel.frame.width / 2),
                y: endY + 5,
                width: dateLabel.frame.width,
                height: dateLabel.frame.height
            )
        }
    }

    func drawMoodChart(entries: [(date: String, mood: String)]) {
        chartView.layer.sublayers?.removeAll(where: { $0.name == "moodGraph" })

        let moodLevels: [String: CGFloat] = [
            "kissing": startY,
            "smile": startY + 45,
            "wow": startY + 90,
            "sleep": startY + 135,
            "angry": startY + 180,
            "sad": endY
        ]

        let path = UIBezierPath()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let baseDateComponents = DateComponents(year: selectedYear, month: selectedMonth, day: 1)
        guard let startDate = Calendar.current.date(from: baseDateComponents) else { return }

        let totalDaysInMonth = Calendar.current.range(of: .day, in: .month, for: startDate)?.count ?? 30
        let availableWidth = chartView.bounds.width - 2 * 90
        let daySpacing = (availableWidth / CGFloat(totalDaysInMonth - 1)) * getSpacingFactor()

        var previousPoint: CGPoint? = nil

        for entry in entries {
            let moodKey = extractMoodKey(from: entry.mood)
            guard let moodYPosition = moodLevels[moodKey],
                  let entryDate = dateFormatter.date(from: entry.date) else {
                continue
            }

            let daysFromStart = Calendar.current.dateComponents([.day], from: startDate, to: entryDate).day ?? 0
            let xPosition = 90 + CGFloat(daysFromStart) * daySpacing
            let currentPoint = CGPoint(x: xPosition, y: moodYPosition)

            if let previous = previousPoint {
                path.move(to: previous)
                path.addLine(to: currentPoint)
            } else {
                path.move(to: currentPoint)
            }

            previousPoint = currentPoint

            let pointLayer = CAShapeLayer()
            let pointPath = UIBezierPath(arcCenter: currentPoint, radius: 4, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            pointLayer.path = pointPath.cgPath
            pointLayer.fillColor = AppColors.color51.cgColor
            pointLayer.name = "moodGraph"
            chartView.layer.addSublayer(pointLayer)
        }

        let moodLineLayer = CAShapeLayer()
        moodLineLayer.path = path.cgPath
        moodLineLayer.strokeColor = AppColors.color58.cgColor
        moodLineLayer.lineWidth = 2
        moodLineLayer.name = "moodGraph"
        chartView.layer.addSublayer(moodLineLayer)
    }



    func extractMoodKey(from urlString: String) -> String {
       
        let components = urlString.components(separatedBy: "/")
        guard let lastComponent = components.last else { return "" }

        return lastComponent.replacingOccurrences(of: ".png", with: "")
    }

    func updateChart(withYear year: Int) {
        selectedYear = year

        if let parentVC = self.parentViewController as? AnalysisVC,
           let entries = parentVC.journalEntriesResponse?.journalEntriesInfoList {
            let filteredEntries = parentVC.filterEntries(entries: entries, forYear: year)
            configureWithEntries(entries: filteredEntries)
        }
    }

    func updateChart(withYear year: Int, month: Int) {
        selectedYear = year
        selectedMonth = month

        if let parentVC = self.parentViewController as? AnalysisVC,
           let entries = parentVC.journalEntriesResponse?.journalEntriesInfoList {
            let filteredEntries = parentVC.filterEntries(entries: entries, forYear: year, month: month)
            configureWithEntries(entries: filteredEntries)
        }
    }

}
