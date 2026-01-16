//
//  DateSelectorButton.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//

import UIKit

protocol DateSelectorDelegate: AnyObject {
    func didSelectDate(year: Int)
       func didSelectYearMonth(year: Int, month: Int)
}

class DateSelectorButton: UIButton {
    
    weak var delegate: DateSelectorDelegate?
    private var overlayView: UIView?
    private var yearMonthSelectorView: YearMonthSelectorView?
    private var calendarMiniView: CalendarMiniView?
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
   var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    private var isDayMonthYearFormat: Bool
    var showYearMonthSelectorView: Bool
    
    init(isDayMonthYearFormat: Bool, showYearMonthSelectorView: Bool = false) {
        self.isDayMonthYearFormat = isDayMonthYearFormat
        self.showYearMonthSelectorView = showYearMonthSelectorView
        super.init(frame: .zero)
        setupButton()
        setDefaultDateTitle()
        addTarget(self, action: #selector(handleDateSelector), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        self.isDayMonthYearFormat = false
        self.showYearMonthSelectorView = false
        super.init(frame: frame)
        setupButton()
        setDefaultDateTitle()
        addTarget(self, action: #selector(handleDateSelector), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(isDayMonthYearFormat:) instead.")
    }
    
    private func setupButton() {
        self.backgroundColor = .clear
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func setDefaultDateTitle() {
        let dateFormatter = DateFormatter()
        let currentDate = Date()
        
        if isDayMonthYearFormat {
            dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
        } else {
            dateFormatter.dateFormat = "MMM yyyy"
        }
        
        let dateString = dateFormatter.string(from: currentDate)
        setDateTitle(dateString: dateString)
    }
    
    
    private func setDateTitle(dateString: String) {
        DispatchQueue.main.async {
            let fullTitle = "\(dateString)   ▼"
            let attributedTitle = NSMutableAttributedString(string: fullTitle)
            let textColor = AppColors.color2
            let arrowColor = AppColors.color20

            attributedTitle.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: dateString.count))
            attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: NSRange(location: 0, length: dateString.count))

            if let arrowRange = fullTitle.range(of: "▼") {
                let nsRange = NSRange(arrowRange, in: fullTitle)
                attributedTitle.addAttribute(.foregroundColor, value: arrowColor, range: nsRange)
                attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: nsRange)
            }

            self.setAttributedTitle(attributedTitle, for: .normal)
            self.layoutIfNeeded()
        }
    }



    
    @objc private func handleDateSelector() {
        if showYearMonthSelectorView {
            showYearMonthSelector()
        } else {
            showCalendarMiniView()
        }
        updateDateTitleForSelectedDate()
    }


    private func showYearMonthSelector() {
           
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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
           overlayView?.addGestureRecognizer(tapGesture)
        
        
           yearMonthSelectorView = YearMonthSelectorView(selectedYear: selectedYear, selectedMonth: selectedMonth)
           yearMonthSelectorView?.translatesAutoresizingMaskIntoConstraints = false
           overlayView?.addSubview(yearMonthSelectorView!)

        let screenWidth = UIScreen.main.bounds.width
        let selectorWidth: CGFloat = screenWidth <= 375 ? 330 : 360

        NSLayoutConstraint.activate([
            yearMonthSelectorView!.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
            yearMonthSelectorView!.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor),
            yearMonthSelectorView!.widthAnchor.constraint(equalToConstant: selectorWidth),
            yearMonthSelectorView!.heightAnchor.constraint(equalToConstant: 250)
        ])
 
        yearMonthSelectorView?.onDateSelected = { [weak self] selectedMonth, selectedYear in
            guard let self = self else { return }
            self.selectedYear = selectedYear
            self.selectedMonth = selectedMonth
            self.updateDateTitleForSelectedDate()
            self.notifyDateChange()
            self.dismissOverlay()
            
            if selectedMonth == 0 {
                self.delegate?.didSelectDate(year: selectedYear)
            } else {
                self.delegate?.didSelectYearMonth(year: selectedYear, month: selectedMonth)
            }
        }
    }
    private func showCalendarMiniView() {
       
        guard let parentVC = self.parentViewController else { return }
        
        
        overlayView = UIView(frame: parentVC.view.bounds)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false
        parentVC.view.addSubview(overlayView!)

        NSLayoutConstraint.activate([
            overlayView!.topAnchor.constraint(equalTo: parentVC.view.topAnchor),
            overlayView!.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor),
            overlayView!.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            overlayView!.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor)
        ])

     
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = overlayView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView?.addSubview(blurEffectView)

       
        let selectedDateComponents = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        let selectedDate = Calendar.current.date(from: selectedDateComponents) ?? Date()
        calendarMiniView = CalendarMiniView(selectedDate: selectedDate)
        calendarMiniView?.translatesAutoresizingMaskIntoConstraints = false
        overlayView?.addSubview(calendarMiniView!)

        let screenWidth = UIScreen.main.bounds.width

        let miniViewWidth: CGFloat = screenWidth <= 375 ? 340 : 360
       let miniViewHeight: CGFloat = screenWidth <= 375 ? 380 : 400

        NSLayoutConstraint.activate([
            calendarMiniView!.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
            calendarMiniView!.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor),
            calendarMiniView!.widthAnchor.constraint(equalToConstant: miniViewWidth),
            calendarMiniView!.heightAnchor.constraint(equalToConstant: miniViewHeight)
        ])

       
        calendarMiniView?.dateSelectedHandler = { [weak self] selectedDate in
            self?.updateDateTitle(with: selectedDate)
            self?.dismissOverlay()
        }

        calendarMiniView?.dismissHandler = { [weak self] in
            self?.dismissOverlay()
        }
    }

    
      func updateDateTitle(with date: Date) {
          let dateFormatter = DateFormatter()
          if isDayMonthYearFormat {
              dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
          } else {
              dateFormatter.dateFormat = "MMM yyyy"
          }
          let dateString = dateFormatter.string(from: date)
          setDateTitle(dateString: dateString)
      }

    
    private func updateDateTitleForSelectedDate() {
        if showYearMonthSelectorView {
            if selectedMonth == 0 {
                
                let dateString = "\(selectedYear)"
                setDateTitle(dateString: dateString)
            } else {
               
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM yyyy"
                let monthString = dateFormatter.monthSymbols[selectedMonth - 1].prefix(3)
                let dateString = "\(monthString) \(selectedYear)"
                setDateTitle(dateString: dateString)
            }
        } else {
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
            if let selectedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)) {
                let dateString = dateFormatter.string(from: selectedDate)
                setDateTitle(dateString: dateString)
            }
        }
    }




    @objc private func dismissOverlay() {
        overlayView?.removeFromSuperview()
        overlayView = nil
        yearMonthSelectorView = nil
        calendarMiniView = nil
    }
    
    func notifyDateChange() {
        if showYearMonthSelectorView {
            delegate?.didSelectYearMonth(year: selectedYear, month: selectedMonth)
        } else {
            delegate?.didSelectDate(year: selectedYear)
        }
        
     
        if let parentVC = self.parentViewController as? CalendarVC {
            parentVC.calendarView.updateCalendar(for: selectedMonth, year: selectedYear)
        }
    }


}

extension DateSelectorButton {
    func getFormattedDate() -> String {
        guard let title = self.titleLabel?.text else { return "" }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "EEEE, dd MMM yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd" 
        
        if let date = inputFormatter.date(from: title.replacingOccurrences(of: "   ▼", with: "")) {
            return outputFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
