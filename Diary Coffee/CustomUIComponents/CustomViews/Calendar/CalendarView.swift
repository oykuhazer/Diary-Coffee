//
//  CalendarView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//


import UIKit

protocol CalendarViewDelegate: AnyObject {
    func fetchJournalEntries(for year: Int, month: Int, day: Int?)
}

class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    private var collectionView: UICollectionView!
    private var daysInMonth: [Int] = []
    private let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var selectedDate: Date?
    var currentMonth: Int = Calendar.current.component(.month, from: Date())
    var currentYear: Int = Calendar.current.component(.year, from: Date())
    private let currentDay = Calendar.current.component(.day, from: Date())
    weak var delegate: CalendarViewDelegate?
    var journalEntries: [String] = []
    
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
            label.textColor = AppColors.color1
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

    func updateCalendar(for month: Int, year: Int) {
        currentMonth = month
        currentYear = year
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            daysInMonth = Array(range)
            
          
            if selectedDate == nil {
                selectedDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: currentDay))
            }
            
            collectionView.reloadData()
        }
    }
    
    func updateJournalEntries(_ entries: [String]) {
        self.journalEntries = Array(Set(self.journalEntries).union(entries))
        collectionView.reloadData()
      }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.clearBackgroundColor()
        cell.clearBorderAndGradient()

        let day = daysInMonth[indexPath.item]
        let cellDateComponents = DateComponents(year: currentYear, month: currentMonth, day: day)
        let cellDate = Calendar.current.date(from: cellDateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        cell.configure(day: day, color: getColorForDay(day))

        if let cellDate = cellDate {
            let formattedDate = dateFormatter.string(from: cellDate)
            if journalEntries.contains(formattedDate) {
                      cell.configure(day: day, color: AppColors.color47)
                  } else {
                      cell.configure(day: day, color: getColorForDay(day)) 
                  }
        }

        if Calendar.current.isDate(selectedDate ?? Date(), inSameDayAs: cellDate ?? Date()) {
            cell.setSelectedBackgroundColor(AppColors.color1)
        }

        if day == currentDay && currentMonth == Calendar.current.component(.month, from: Date()) && currentYear == Calendar.current.component(.year, from: Date()) {
            cell.setBorderAndGradient()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = daysInMonth[indexPath.item]
        let selectedDateComponents = DateComponents(year: currentYear, month: currentMonth, day: selectedDay)
        selectedDate = Calendar.current.date(from: selectedDateComponents)

        
        let today = Date()
          let calendar = Calendar.current
          let selectedFullDate = calendar.date(from: selectedDateComponents)
        
          if let selectedFullDate = selectedFullDate, selectedFullDate > today {
              showFutureDateAlert()
              return
          }
        
        for visibleCell in collectionView.visibleCells {
            guard let cell = visibleCell as? CalendarCell,
                  let visibleIndexPath = collectionView.indexPath(for: cell) else { continue }
            let day = daysInMonth[visibleIndexPath.item]
            let cellDateComponents = DateComponents(year: currentYear, month: currentMonth, day: day)
            let cellDate = Calendar.current.date(from: cellDateComponents)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            if let cellDate = cellDate {
                let formattedDate = dateFormatter.string(from: cellDate)
                if journalEntries.contains(formattedDate) {
                    cell.configure(day: day, color: AppColors.color47
)
                } else {
                    cell.configure(day: day, color: getColorForDay(day))
                }
            }

            if Calendar.current.isDate(selectedDate ?? Date(), inSameDayAs: cellDate ?? Date()) {
                cell.setSelectedBackgroundColor(AppColors.color1)
            } else {
                cell.clearBackgroundColor()
            }
        }

        delegate?.fetchJournalEntries(for: currentYear, month: currentMonth, day: selectedDay)
    }

    private func showFutureDateAlert() {
        if let parentView = self.superview {
            var frame = parentView.bounds
            frame.origin.y -= 90
            let requiredActionView = RequiredActionView(frame: frame)
            requiredActionView.configure(
                icon: UIImage(named: "nonday"),
                message: NSLocalizedString("oops_day_yet_to_come", comment: "")
            )
            parentView.addSubview(requiredActionView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                requiredActionView.removeFromSuperview()
            }
        }
    }

    private func getColorForDay(_ day: Int) -> UIColor {
        return AppColors.color20
    }
 
    func reloadCalendarView() {
          collectionView.reloadData()
      }
    func removeJournalEntry(for date: String) {
        self.journalEntries.removeAll { $0 == date }
        
        collectionView.reloadData()
    }
}


class CalendarCell: UICollectionViewCell {
    
    private let dayLabel = UILabel()
    internal var circleView = UIView()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = circleView.bounds
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
        dayLabel.textColor = AppColors.color2
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
        gradientLayer.colors = [AppColors.color2.cgColor, UIColor.white.cgColor]
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
        circleView.layer.borderColor = AppColors.color2.cgColor
        if gradientLayer.superlayer == nil {
            circleView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    func clearBorderAndGradient() {
        circleView.layer.borderWidth = 0
        gradientLayer.isHidden = true
    }

    func setSelectedBackgroundColor(_ color: UIColor) {
        dayLabel.backgroundColor = color
    }
    
    func clearBackgroundColor() {
        dayLabel.backgroundColor = .clear
    }
    
    
}
