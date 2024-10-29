//
//  CalendarView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//

import UIKit

class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    private var collectionView: UICollectionView!
    private let daysInMonth = Array(1...31)
    private let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private var selectedIndexPath: IndexPath?
    private let currentDay = Calendar.current.component(.day, from: Date())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWeekDayLabels()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWeekDayLabels()
        setupCollectionView()
    }
    
    private func setupWeekDayLabels() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for day in weekDays {
            let label = UILabel()
            label.text = day
            label.textColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
            label.textAlignment = .natural
            label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            stackView.addArrangedSubview(label)
        }
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 40, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        let day = daysInMonth[indexPath.item]
        
        cell.configure(day: day, color: getColorForDay(day))
        
        // Geçerli günse, gradyan ve kenarlık ekle
        if day == currentDay {
            cell.setBorderAndGradient()
        } else {
            cell.clearBorderAndGradient()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CalendarCell {
            previousCell.clearBackgroundColor()
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
        cell.setSelectedBackgroundColor(UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0))
        selectedIndexPath = indexPath
    }

    private func getColorForDay(_ day: Int) -> UIColor {
        return UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0)
    }
}

class CalendarCell: UICollectionViewCell {
    
    private let dayLabel = UILabel()
    private let circleView = UIView()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        circleView.layer.cornerRadius = 20
        circleView.layer.masksToBounds = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circleView)
        
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        dayLabel.backgroundColor = .clear
        dayLabel.layer.cornerRadius = 5
        dayLabel.clipsToBounds = true
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.heightAnchor.constraint(equalToConstant: 40),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 4),
            dayLabel.widthAnchor.constraint(equalToConstant: 30),
            dayLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        gradientLayer.frame = circleView.bounds
        gradientLayer.colors = [UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = 20
    }
    
    func configure(day: Int, color: UIColor) {
        dayLabel.text = "\(day)"
        circleView.backgroundColor = color
    }

    func setBorderAndGradient() {
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0).cgColor
        if gradientLayer.superlayer == nil {
            circleView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func clearBorderAndGradient() {
        circleView.layer.borderWidth = 0
        gradientLayer.removeFromSuperlayer()
    }

    func setSelectedBackgroundColor(_ color: UIColor) {
        dayLabel.backgroundColor = color
    }
    
    func clearBackgroundColor() {
        dayLabel.backgroundColor = .clear
    }
}
