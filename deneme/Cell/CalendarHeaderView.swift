//
//  CalendarHeaderView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 10.10.2024.
//

import UIKit

class CalendarHeaderView: UIView {
    var onDaySelected: ((String) -> Void)?
    var selectedDayLabel: UILabel?
    var selectedDay: String?
    let months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    // Yeni kahve tonlarında bir başlık butonu
    let monthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ekim 2024", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor(red: 85/255, green: 50/255, blue: 35/255, alpha: 1), for: .normal)

        let chevronImage = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .medium))
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor(red: 85/255, green: 50/255, blue: 35/255, alpha: 1)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.backgroundColor = UIColor(red: 240/255, green: 230/255, blue: 220/255, alpha: 1) // Daha sıcak bir arka plan rengi
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func updateCalendar(for month: Int, year: Int) {
        let calendar = Calendar.current
        var components = DateComponents(year: year, month: month)
        let date = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstDay = calendar.component(.weekday, from: date) - 1

        dayGridView.subviews.forEach { $0.removeFromSuperview() }

        var currentDay = 1
        let daysPerRow = 7
        let totalRows = Int(ceil(Double(range.count + firstDay) / Double(daysPerRow)))

        for row in 0..<totalRows {
            for col in 0..<daysPerRow {
                let index = row * daysPerRow + col
                let dayLabel = UILabel()
                dayLabel.textAlignment = .center
                dayLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                dayLabel.layer.cornerRadius = 20
                dayLabel.layer.masksToBounds = true
                dayLabel.translatesAutoresizingMaskIntoConstraints = false

                if index >= firstDay && currentDay <= range.count {
                    dayLabel.text = "\(currentDay)"
                    dayLabel.textColor = UIColor(red: 123/255, green: 63/255, blue: 52/255, alpha: 1)
                    dayLabel.backgroundColor = UIColor(red: 232/255, green: 226/255, blue: 213/255, alpha: 1)

                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayTapped(_:)))
                    dayLabel.isUserInteractionEnabled = true
                    dayLabel.addGestureRecognizer(tapGesture)

                    currentDay += 1
                } else {
                    dayLabel.text = ""
                }

                dayGridView.addSubview(dayLabel)
                NSLayoutConstraint.activate([
                    dayLabel.widthAnchor.constraint(equalToConstant: 40),
                    dayLabel.heightAnchor.constraint(equalToConstant: 40),
                    dayLabel.leadingAnchor.constraint(equalTo: dayGridView.leadingAnchor, constant: CGFloat(col) * 50),
                    dayLabel.topAnchor.constraint(equalTo: dayGridView.topAnchor, constant: CGFloat(row) * 50)
                ])
            }
        }
    }

    @objc func dayTapped(_ sender: UITapGestureRecognizer) {
            guard let tappedLabel = sender.view as? UILabel else { return }

            if let previousLabel = selectedDayLabel {
                previousLabel.backgroundColor = UIColor(red: 232/255, green: 226/255, blue: 213/255, alpha: 1)
                previousLabel.textColor = UIColor(red: 123/255, green: 63/255, blue: 52/255, alpha: 1)
            }

            tappedLabel.backgroundColor = UIColor(red: 123/255, green: 63/255, blue: 52/255, alpha: 1)
            tappedLabel.textColor = UIColor(red: 232/255, green: 226/255, blue: 213/255, alpha: 1)

            selectedDayLabel = tappedLabel
            selectedDay = tappedLabel.text
            
            // Seçilen günü closure ile bildiriyoruz
            if let selectedDay = selectedDay {
                onDaySelected?(selectedDay)
            }
        }

    func getSelectedDate(month: String, year: Int) -> String? {
        guard let day = selectedDay else { return nil }
        
        // Seçilen ayı sayıya çevirelim
        if let monthIndex = months.firstIndex(of: month) {
            let monthNumber = monthIndex + 1 // Ayların sıfırdan başladığını dikkate alarak düzeltelim
            let formattedMonth = String(format: "%02d", monthNumber) // İki haneli ay formatı
            
            // Günü, ayı ve yılı birleştirerek geri döndürelim
            return "\(day)/\(formattedMonth)/\(year)"
        }
        
        return nil
    }

    let dayOfWeekStackView: UIStackView = {
        let days = ["P", "P", "S", "Ç", "P", "C", "C"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for day in days {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.textColor = UIColor(red: 120/255, green: 70/255, blue: 40/255, alpha: 1)
            label.text = day
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    let dayGridView: UIView = {
        let gridView = UIView()
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(monthButton)
        addSubview(dayOfWeekStackView)
        addSubview(dayGridView)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            monthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            monthButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dayOfWeekStackView.topAnchor.constraint(equalTo: monthButton.bottomAnchor, constant: 10),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dayOfWeekStackView.heightAnchor.constraint(equalToConstant: 30),
            
            dayGridView.topAnchor.constraint(equalTo: dayOfWeekStackView.bottomAnchor, constant: 20),
            dayGridView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dayGridView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dayGridView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}

