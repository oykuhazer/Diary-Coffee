//
//  CoffeeTrackerYearView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 10.11.2024.
//

import UIKit

class CoffeeTrackerYearView: UIView {
    private let entireYearView = UIView()
    private let byMonthView = CoffeeTrackerMonthView()
    let yearLabel = UILabel()
    var selectedYear: Int?
    private var circleViews = [UIView]()
    var dates: [String] = [] {
           didSet {
               print("📌 Güncellenmiş Tarihler: ", dates) 
               byMonthView.dates = dates
               print("📌 Güncellenmiş Tarihler: ", dates) 
           }
       }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        byMonthView.yearLabel = yearLabel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        byMonthView.yearLabel = yearLabel
    }

    func setYearLabel(year: Int) {
        yearLabel.text = "\(year)"
        print("yearLabel Güncellendi:", yearLabel.text ?? "")
        byMonthView.updateDayCircles(for: year)
    }
   
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color20
        self.layer.cornerRadius = 16

        let segmentControl = UISegmentedControl(items: [
            NSLocalizedString("entire_year", comment: ""),
            NSLocalizedString("by_month", comment: "")
        ])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = AppColors.color50
        segmentControl.selectedSegmentTintColor = AppColors.color6
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColors.color6], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColors.color50], for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.addSubview(segmentControl)

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            segmentControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalToConstant: 200),
            segmentControl.heightAnchor.constraint(equalToConstant: 30)
        ])

        yearLabel.text = "2024"
        yearLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        yearLabel.textColor = AppColors.color50
        yearLabel.textAlignment = .center
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(yearLabel)

        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            yearLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        setupByMonthView()
        setupEntireYearView(with: dates)
        
    }

    func setupEntireYearView(with dates: [String]) {
        self.dates = dates
        
        if let selectedYear = selectedYear {
            yearLabel.text = "\(selectedYear)"
        } else {
          
        }
        
        guard let yearText = yearLabel.text, let year = Int(yearText) else {
           
            return
        }
        
        entireYearView.subviews.forEach { $0.removeFromSuperview() }
        entireYearView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(entireYearView)

        NSLayoutConstraint.activate([
            entireYearView.topAnchor.constraint(equalTo: yearLabel.topAnchor, constant: 30),
            entireYearView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            entireYearView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            entireYearView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -75)
        ])

        let numberOfColumns = 12
        let numberOfRows = 31
        let cellSpacing: CGFloat = -25
        let tableContainerWidth = UIScreen.main.bounds.width - 20
        let cellWidth: CGFloat = (tableContainerWidth - CGFloat(numberOfColumns - 1) * cellSpacing) / CGFloat(numberOfColumns)
        let cellHeight = cellWidth
        let circleSize = cellWidth * 0.3
        let monthFont = UIFont.systemFont(ofSize: 9, weight: .bold)
        let cellColor = AppColors.color50
        let lineColor = AppColors.color66

        var lastDayLabel: UILabel?
        var firstMonthLabel: UILabel?

        for day in 1...numberOfRows {
            let dayLabel = UILabel()
            dayLabel.text = "\(day)"
            dayLabel.font = monthFont
            dayLabel.textColor = cellColor
            dayLabel.textAlignment = .center
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            entireYearView.addSubview(dayLabel)

            NSLayoutConstraint.activate([
                dayLabel.leadingAnchor.constraint(equalTo: entireYearView.leadingAnchor, constant: -10),
                dayLabel.widthAnchor.constraint(equalToConstant: cellWidth),
                dayLabel.heightAnchor.constraint(equalToConstant: cellHeight),
                dayLabel.topAnchor.constraint(equalTo: entireYearView.topAnchor, constant: CGFloat(day) * (cellHeight + cellSpacing) + cellHeight - 20)
            ])

            lastDayLabel = dayLabel

            for month in 1...numberOfColumns {
                let circleView = UIView()
                circleView.layer.cornerRadius = circleSize / 2
                circleView.clipsToBounds = true
                circleView.backgroundColor = AppColors.color66
                circleView.translatesAutoresizingMaskIntoConstraints = false
                entireYearView.addSubview(circleView)

                let formattedDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
                circleView.accessibilityLabel = formattedDate

                NSLayoutConstraint.activate([
                    circleView.widthAnchor.constraint(equalToConstant: circleSize),
                    circleView.heightAnchor.constraint(equalToConstant: circleSize),
                    circleView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: CGFloat(month - 1) * (cellWidth + cellSpacing - 3)),
                    circleView.topAnchor.constraint(equalTo: dayLabel.topAnchor, constant: (cellHeight - circleSize) / 2)
                ])

                if dates.contains(formattedDate) {
                    circleView.backgroundColor = AppColors.color6
                  
                }

                if day == 1 {
                    let monthLabel = UILabel()
                    monthLabel.text = "\(month)"
                    monthLabel.font = monthFont
                    monthLabel.textColor = cellColor
                    monthLabel.textAlignment = .center
                    monthLabel.translatesAutoresizingMaskIntoConstraints = false
                    entireYearView.addSubview(monthLabel)

                    NSLayoutConstraint.activate([
                        monthLabel.bottomAnchor.constraint(equalTo: circleView.topAnchor, constant: -5),
                        monthLabel.widthAnchor.constraint(equalToConstant: cellWidth * 0.6),
                        monthLabel.heightAnchor.constraint(equalToConstant: cellHeight),
                        monthLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor)
                    ])
                    
                    if firstMonthLabel == nil {
                        firstMonthLabel = monthLabel
                    }
                }
            }
        }

        if let lastDayLabel = lastDayLabel, let firstMonthLabel = firstMonthLabel {
            let verticalLine = UIView()
            verticalLine.backgroundColor = lineColor
            verticalLine.translatesAutoresizingMaskIntoConstraints = false
            entireYearView.addSubview(verticalLine)

            NSLayoutConstraint.activate([
                verticalLine.widthAnchor.constraint(equalToConstant: 1),
                verticalLine.topAnchor.constraint(equalTo: firstMonthLabel.topAnchor, constant: -1),
                verticalLine.bottomAnchor.constraint(equalTo: entireYearView.bottomAnchor),
                verticalLine.trailingAnchor.constraint(equalTo: lastDayLabel.trailingAnchor, constant: -10)
            ])

            let horizontalLine = UIView()
            horizontalLine.backgroundColor = lineColor
            horizontalLine.translatesAutoresizingMaskIntoConstraints = false
            entireYearView.addSubview(horizontalLine)

            NSLayoutConstraint.activate([
                horizontalLine.heightAnchor.constraint(equalToConstant: 1),
                horizontalLine.leadingAnchor.constraint(equalTo: entireYearView.leadingAnchor),
                horizontalLine.trailingAnchor.constraint(equalTo: entireYearView.trailingAnchor),
                horizontalLine.topAnchor.constraint(equalTo: firstMonthLabel.bottomAnchor, constant: -10)
            ])
        }

        if let lastDayLabel = lastDayLabel {
            NSLayoutConstraint.activate([
                entireYearView.bottomAnchor.constraint(equalTo: lastDayLabel.bottomAnchor, constant: 2)
            ])
        }
    }


    private func setupByMonthView() {
        byMonthView.translatesAutoresizingMaskIntoConstraints = false
        byMonthView.isHidden = true
        self.addSubview(byMonthView)

       
        let screenHeight = UIScreen.main.bounds.height
      

        let byMonthHeight: CGFloat
        if screenHeight == 2532 {
            byMonthHeight = 1040
        } else if screenHeight == 2556 {
            byMonthHeight = 1050
        } else if screenHeight == 2778 {
            byMonthHeight = 1160
        } else if screenHeight == 2796 {
            byMonthHeight = 1165
        } else if screenHeight == 2436 {
            byMonthHeight = 1000
        } else if screenHeight == 667 {
            byMonthHeight = 1000
        } else {
            byMonthHeight = 1110
        }



        NSLayoutConstraint.activate([
            byMonthView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            byMonthView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            byMonthView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            byMonthView.heightAnchor.constraint(equalToConstant: byMonthHeight)
        ])
    }








       @objc private func segmentChanged(_ sender: UISegmentedControl) {
           entireYearView.isHidden = sender.selectedSegmentIndex != 0
           byMonthView.isHidden = sender.selectedSegmentIndex == 0

           if sender.selectedSegmentIndex == 0 {
               self.addSubview(yearLabel)
           } else {
               byMonthView.addYearLabelIfNeeded()
           }
       }
}

