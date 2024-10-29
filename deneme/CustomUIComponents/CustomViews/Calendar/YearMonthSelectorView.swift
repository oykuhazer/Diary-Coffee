//
//  YearMonthSelector.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//

import UIKit

class YearMonthSelectorView: UIView {
    var onDateSelected: ((Int, Int) -> Void)?

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "2024"
        label.textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        return label
    }()

    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.addTarget(self, action: #selector(decreaseYear), for: .touchUpInside)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.addTarget(self, action: #selector(increaseYear), for: .touchUpInside)
        return button
    }()

    private lazy var monthButtons: [UIButton] = {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months.enumerated().map { index, month in
            let button = UIButton()
            button.setTitle(month, for: .normal)
            button.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
            button.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
            button.layer.cornerRadius = 12
            button.clipsToBounds = true
            button.tag = index + 1
            button.addTarget(self, action: #selector(monthButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()

    private var currentYear: Int {
        didSet {
            updateYearLabel()
            updateMonthButtons()
            resetSelectedMonthButton()
        }
    }
    private var selectedButton: UIButton?

    init(selectedYear: Int, selectedMonth: Int) {
        self.currentYear = selectedYear
        super.init(frame: .zero)
        setupView()
        setInitialSelection(year: selectedYear, month: selectedMonth)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0)
        layer.cornerRadius = 20
        clipsToBounds = true

        let headerStack = UIStackView(arrangedSubviews: [leftButton, yearLabel, rightButton])
        headerStack.axis = .horizontal
        headerStack.spacing = 20
        headerStack.alignment = .center
        addSubview(headerStack)

        headerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            headerStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 8
        gridStack.distribution = .fillEqually
        addSubview(gridStack)

        gridStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 10),
            gridStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            gridStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            gridStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35)
        ])

        for i in 0..<3 {
            let rowStack = UIStackView(arrangedSubviews: Array(monthButtons[i * 4..<(i + 1) * 4]))
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually
            gridStack.addArrangedSubview(rowStack)
        }
        
        updateMonthButtons()
    }
    
    private func setInitialSelection(year: Int, month: Int) {
        currentYear = year
        yearLabel.text = "\(year)"
        if let button = monthButtons.first(where: { $0.tag == month }) {
            monthButtonTapped(button)
        }
    }

    @objc private func monthButtonTapped(_ sender: UIButton) {
        selectedButton?.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
        sender.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
        selectedButton = sender
        onDateSelected?(sender.tag, currentYear)
    }

    @objc private func decreaseYear() {
        if currentYear > 2000 {
            currentYear -= 1
        }
    }

    @objc private func increaseYear() {
        let currentCalendarYear = Calendar.current.component(.year, from: Date())
        if currentYear < currentCalendarYear {
            currentYear += 1
        }
    }

    private func updateYearLabel() {
        yearLabel.text = "\(currentYear)"
    }

    private func updateMonthButtons() {
        let currentCalendarYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        for button in monthButtons {
            if currentYear == currentCalendarYear && button.tag > currentMonth {
                button.isEnabled = false
                button.setTitleColor(UIColor(red: 0.6, green: 0.5, blue: 0.45, alpha: 0.6), for: .normal)
            } else {
                button.isEnabled = true
                button.setTitleColor(UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0), for: .normal)
            }
        }
    }

    private func resetSelectedMonthButton() {
        if let selected = selectedButton {
            selected.backgroundColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0)
            selectedButton = nil
        }
    }
}
