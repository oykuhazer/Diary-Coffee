//
//  YearMonthPickerView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 12.11.2024.
//


import UIKit

protocol YearMonthPickerViewDelegate: AnyObject {
    func yearPickerView(_ pickerView: YearMonthPickerView, didSelectYear year: Int, month: Int)
    func yearPickerViewDidCancel(_ pickerView: YearMonthPickerView)
}

class YearMonthPickerView: UIView {
    
    weak var delegate: YearMonthPickerViewDelegate?
    private let tableView = UITableView()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        let configuration = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .large)
        button.setImage(image?.withConfiguration(configuration), for: .normal)
        button.tintColor = AppColors.color4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let chooseMonthLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("choose_month_and_year", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.color2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color26
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private var monthYearPairs: [String] = []
    var selectedYear = Calendar.current.component(.year, from: Date())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        generateMonthYearPairs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 4
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
        addSubview(containerView)
        containerView.addSubview(tableView)
        containerView.addSubview(closeButton)
        containerView.addSubview(chooseMonthLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        chooseMonthLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300),

            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),

            chooseMonthLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            chooseMonthLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    @objc private func handleTapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !containerView.frame.contains(location) {
            dismissModal()
        }
    }

    @objc private func dismissModal() {
        delegate?.yearPickerViewDidCancel(self)
    }
    
    private func generateMonthYearPairs() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())

        for year in (2000...currentYear).reversed() {
            for month in (1...12).reversed() {
                if year == currentYear && month > currentMonth {
                    continue
                }
                let dateComponents = DateComponents(year: year, month: month)
                if let date = Calendar.current.date(from: dateComponents) {
                    let monthYearString = dateFormatter.string(from: date)
                    monthYearPairs.append(monthYearString)
                }
            }
        }
        
        tableView.reloadData()
    }
}

extension YearMonthPickerView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthYearPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = AppColors.color26
        cell.textLabel?.text = "  \(monthYearPairs[indexPath.row])"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.textColor = AppColors.color2
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("✅ Kullanıcı Hücreye TIKLADI!")

        let selectedDateString = monthYearPairs[indexPath.row]
        let components = selectedDateString.split(separator: " ")

        print("✅ Seçilen Tarih String: \(selectedDateString)")

        guard let selectedYear = Int(components[1]) else {
            print("❌ Yıl Çevrim Hatası: \(components[1])")
            return
        }

        guard let selectedMonthIndex = DateFormatter().shortMonthSymbols.firstIndex(of: String(components[0])) else {
            print("❌ Ay Çevrim Hatası: \(components[0])")
            return
        }
        
        let selectedMonth = selectedMonthIndex + 1

        print("📌 Seçilen Tarih: \(selectedYear) - \(selectedMonth)")

        if let delegate = delegate {
            print("✅ `delegate` mevcut, fonksiyon çağrılıyor...")
            delegate.yearPickerView(self, didSelectYear: selectedYear, month: selectedMonth)
        } else {
            print("❌ `delegate` nil, çağrı yapılamıyor!")
        }
    }


}
