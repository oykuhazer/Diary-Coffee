//
//  YearMonthSegmentControl.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 11.11.2024.
//

import UIKit

class YearMonthSegmentControl: UIView {
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [
            NSLocalizedString("entire_year", comment: ""),
            NSLocalizedString("by_month", comment: "")
        ])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = AppColors.color50
        segment.selectedSegmentTintColor = AppColors.color6
        segment.setTitleTextAttributes([.foregroundColor: AppColors.color6], for: .normal)
        segment.setTitleTextAttributes([.foregroundColor: AppColors.color50], for: .selected)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.isHidden = true
        return segment
    }()
    
    let yearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.setTitleColor(AppColors.color2, for: .normal)
        return button
    }()
    
    var onYearButtonTap: (() -> Void)?
    var onSegmentChange: ((Int) -> Void)?
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(segmentControl)
        addSubview(yearButton)
        
        setYearButtonTitle(with: Date())
        
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalToConstant: 250),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            
            yearButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 30),
            yearButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            yearButton.widthAnchor.constraint(equalToConstant: 180),
            yearButton.heightAnchor.constraint(equalToConstant: 50),
            
            yearButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func yearButtonTapped() {
        onYearButtonTap?()
    }
    
    @objc private func segmentChanged() {
        onSegmentChange?(segmentControl.selectedSegmentIndex)
        updateYearButtonTitle()
    }
    
    func setYearButtonTitle(with date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        setYearButtonTitle(with: year, month: month)
    }

    func setYearButtonTitle(with year: Int, month: Int?) {
        selectedYear = year
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"

        let monthString: String
        if let month = month {
            monthString = dateFormatter.shortMonthSymbols[month - 1]
        } else {
            let currentMonth = Calendar.current.component(.month, from: Date())
            monthString = dateFormatter.shortMonthSymbols[currentMonth - 1]
        }

        yearButton.setTitle("\(monthString) \(year) ▼", for: .normal) 
    }

    
    func updateYearButtonTitle() {
        if segmentControl.selectedSegmentIndex == 0 {
            setYearButtonTitle(with: selectedYear, month: nil)
        } else {
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: Date())
            setYearButtonTitle(with: selectedYear, month: currentMonth)
        }
    }

    
    func updateYearButton(with year: Int, month: Int?) {
          selectedYear = year
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM"

          let monthString: String
          if let month = month {
              monthString = dateFormatter.shortMonthSymbols[month - 1]
          } else {
              let currentMonth = Calendar.current.component(.month, from: Date())
              monthString = dateFormatter.shortMonthSymbols[currentMonth - 1]
          }

          DispatchQueue.main.async {
              self.yearButton.setTitle("\(monthString) \(year) ▼", for: .normal)
          }
      }
}
