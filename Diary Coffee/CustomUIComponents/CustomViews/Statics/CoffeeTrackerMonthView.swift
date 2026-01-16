//
//  CoffeeTrackerMonthView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 10.11.2024.
//

import UIKit

class CoffeeTrackerMonthView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var yearLabel: UILabel?
    var dates: [String] = []
    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    private var collectionView: UICollectionView!
    private var currentYear: Int = Calendar.current.component(.year, from: Date())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override var intrinsicContentSize: CGSize {
        collectionView.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: collectionView.contentSize.height + 120)
    }

    
    private func setupUI() {
        self.backgroundColor = AppColors.color20
        self.layer.cornerRadius = 10

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MonthCell.self, forCellWithReuseIdentifier: "MonthCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)

        addYearLabelIfNeeded()
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }

    func addYearLabelIfNeeded() {
        guard let yearLabel = yearLabel else { return }
        self.addSubview(yearLabel)
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            yearLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func updateDayCircles(for year: Int) {
        currentYear = year
        collectionView.reloadData()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell
        cell.configure(with: months[indexPath.item], for: currentYear, monthIndex: indexPath.item + 1, dates: dates)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: width * 1.05)
    }
}


class MonthCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let daysContainer = UIView()
    private let separatorLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColors.color50.cgColor

        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        separatorLine.backgroundColor = AppColors.color50
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            separatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])

        daysContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(daysContainer)

        NSLayoutConstraint.activate([
            daysContainer.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 10),
            daysContainer.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: 5),
            daysContainer.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            daysContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }

    func configure(with month: String, for year: Int, monthIndex: Int, dates: [String]) {
        titleLabel.text = month
        setupDaysGrid(for: year, month: monthIndex, dates: dates)
    }

    private func setupDaysGrid(for year: Int, month: Int, dates: [String]) {
        daysContainer.subviews.forEach { $0.removeFromSuperview() }

        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        let daysInMonth = calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!)?.count ?? 30

        let weekday = calendar.component(.weekday, from: calendar.date(from: dateComponents)!) - 1
        let numberOfColumns = 7
        let circleSize: CGFloat = 12
        let spacing: CGFloat = 6

        for day in 0..<daysInMonth + weekday {
            let row = day / numberOfColumns
            let col = day % numberOfColumns

            if day < weekday {
                continue
            }

            let dayCircle = UIView()
            dayCircle.backgroundColor = AppColors.color66
            dayCircle.layer.cornerRadius = circleSize / 2
            dayCircle.translatesAutoresizingMaskIntoConstraints = false
            daysContainer.addSubview(dayCircle)

            NSLayoutConstraint.activate([
                dayCircle.widthAnchor.constraint(equalToConstant: circleSize),
                dayCircle.heightAnchor.constraint(equalToConstant: circleSize),
                dayCircle.leadingAnchor.constraint(equalTo: daysContainer.leadingAnchor, constant: CGFloat(col) * (circleSize + spacing)),
                dayCircle.topAnchor.constraint(equalTo: daysContainer.topAnchor, constant: CGFloat(row) * (circleSize + spacing))
            ])

    
            let formattedDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day - weekday + 1))"
            if dates.contains(formattedDate) {
                dayCircle.backgroundColor = AppColors.color6
            }
        }
    }
}
