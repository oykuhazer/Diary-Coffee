//
//  DateSelectorButton.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//

import UIKit

class DateSelectorButton: UIButton {
    private var overlayView: UIView?
    private var yearMonthSelectorView: YearMonthSelectorView?
    private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setDefaultDateTitle()
        addTarget(self, action: #selector(showYearMonthSelector), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setDefaultDateTitle()
        addTarget(self, action: #selector(showYearMonthSelector), for: .touchUpInside)
    }

    private func setupButton() {
        self.backgroundColor = .clear
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        setDefaultDateTitle()
    }

    private func setDefaultDateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        setDateTitle(dateString: dateString)
    }

    private func setDateTitle(dateString: String) {
        let fullTitle = "\(dateString)   ▼"
        
        let attributedTitle = NSMutableAttributedString(string: fullTitle)
        let textColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0)
        let arrowColor = UIColor(red: 0.4, green: 0.3, blue: 0.25, alpha: 1.0)

        attributedTitle.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: dateString.count))
        attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: NSRange(location: 0, length: dateString.count))

        if let arrowRange = fullTitle.range(of: "▼") {
            let nsRange = NSRange(arrowRange, in: fullTitle)
            attributedTitle.addAttribute(.foregroundColor, value: arrowColor, range: nsRange)
            attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nsRange)
        }

        self.setAttributedTitle(attributedTitle, for: .normal)
    }

    @objc private func showYearMonthSelector() {
        guard let parentVCView = self.window?.rootViewController?.view else { return }

        overlayView = UIView(frame: parentVCView.bounds)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false
        parentVCView.addSubview(overlayView!)

        NSLayoutConstraint.activate([
            overlayView!.topAnchor.constraint(equalTo: parentVCView.topAnchor),
            overlayView!.bottomAnchor.constraint(equalTo: parentVCView.bottomAnchor),
            overlayView!.leadingAnchor.constraint(equalTo: parentVCView.leadingAnchor),
            overlayView!.trailingAnchor.constraint(equalTo: parentVCView.trailingAnchor)
        ])

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = overlayView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView?.addSubview(blurEffectView)

        yearMonthSelectorView = YearMonthSelectorView(selectedYear: selectedYear, selectedMonth: selectedMonth)
        yearMonthSelectorView?.translatesAutoresizingMaskIntoConstraints = false
        overlayView?.addSubview(yearMonthSelectorView!)

        NSLayoutConstraint.activate([
            yearMonthSelectorView!.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
            yearMonthSelectorView!.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor),
            yearMonthSelectorView!.widthAnchor.constraint(equalToConstant: 360),
            yearMonthSelectorView!.heightAnchor.constraint(equalToConstant: 250)
        ])

        yearMonthSelectorView?.onDateSelected = { [weak self] selectedMonth, selectedYear in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            let monthString = dateFormatter.monthSymbols[selectedMonth - 1].prefix(3)
            let dateString = "\(monthString) \(selectedYear)"
            self?.setDateTitle(dateString: dateString)
            self?.selectedYear = selectedYear
            self?.selectedMonth = selectedMonth
            self?.dismissOverlay()
        }
    }


    @objc private func dismissOverlay() {
        overlayView?.removeFromSuperview()
        overlayView = nil
        yearMonthSelectorView = nil
    }
}
