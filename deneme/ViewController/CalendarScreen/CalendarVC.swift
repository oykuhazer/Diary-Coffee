//
//  CalendarVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 27.10.2024.
//

import UIKit

class CalendarVC: UIViewController {

    let scrollView = UIScrollView()
       let contentView = UIView()
       
       let dateSelectorButton = DateSelectorButton()
       let calendarView = CalendarView()
       let yearMonthSelectorView = YearMonthSelectorView(selectedYear: 2024, selectedMonth: 1)
       let coffeeDiaryCalendar = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

       override func viewDidLoad() {
           super.viewDidLoad()

           view.backgroundColor = UIColor(red: 0.18, green: 0.12, blue: 0.08, alpha: 1.0)
           
           setupNavigationBarButtons()
           setupScrollView()
           setupDateSelectorButton()
           setupCalendarView()
           setupCoffeeDiaryCalendar()
           setupActionButtons()
       }

       private func setupNavigationBarButtons() {
           let buttonColor = UIColor(red: 0.5, green: 0.4, blue: 0.35, alpha: 1.0)
           
           // Create buttons
           let searchButton = UIButton(type: .system)
           searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
           searchButton.tintColor = buttonColor
           searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
           
           let paintButton = UIButton(type: .system)
           paintButton.setImage(UIImage(systemName: "paintpalette"), for: .normal)
           paintButton.tintColor = buttonColor
           paintButton.addTarget(self, action: #selector(paintButtonTapped), for: .touchUpInside)
           
           let gridButton = UIButton(type: .system)
           gridButton.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
           gridButton.tintColor = buttonColor
           gridButton.addTarget(self, action: #selector(gridButtonTapped), for: .touchUpInside)
           
           // Stack view to hold buttons
           let buttonStack = UIStackView(arrangedSubviews: [searchButton, paintButton, gridButton])
           buttonStack.axis = .horizontal
           buttonStack.spacing = 15 // Set spacing between buttons
           buttonStack.alignment = .center

           // Add stack view as custom view to navigation item
           navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonStack)
       }

       @objc private func searchButtonTapped() {
           print("Search button tapped")
       }

       @objc private func paintButtonTapped() {
           print("Paint button tapped")
       }

       @objc private func gridButtonTapped() {
           print("Grid button tapped")
       }

       private func setupScrollView() {
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           contentView.translatesAutoresizingMaskIntoConstraints = false

           scrollView.showsVerticalScrollIndicator = false
           scrollView.showsHorizontalScrollIndicator = false

           view.addSubview(scrollView)
           scrollView.addSubview(contentView)

           NSLayoutConstraint.activate([
               scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

               contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
               contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
               contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
               contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
               contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
           ])
       }

       private func setupDateSelectorButton() {
           dateSelectorButton.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(dateSelectorButton)

           NSLayoutConstraint.activate([
               dateSelectorButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               dateSelectorButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               dateSelectorButton.widthAnchor.constraint(equalToConstant: 150)
           ])
       }

       private func setupCalendarView() {
           calendarView.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(calendarView)

           NSLayoutConstraint.activate([
               calendarView.topAnchor.constraint(equalTo: dateSelectorButton.bottomAnchor, constant: 20),
               calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
               calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
               calendarView.heightAnchor.constraint(equalToConstant: 420)
           ])
       }

       private func setupCoffeeDiaryCalendar() {
           coffeeDiaryCalendar.translatesAutoresizingMaskIntoConstraints = false
           coffeeDiaryCalendar.backgroundColor = .clear
           coffeeDiaryCalendar.delegate = self
           coffeeDiaryCalendar.dataSource = self
           coffeeDiaryCalendar.register(CoffeeDiaryCalendarCell.self, forCellWithReuseIdentifier: "CoffeeDiaryCalendarCell")
           coffeeDiaryCalendar.showsVerticalScrollIndicator = false
           coffeeDiaryCalendar.showsHorizontalScrollIndicator = false

           contentView.addSubview(coffeeDiaryCalendar)

           NSLayoutConstraint.activate([
               coffeeDiaryCalendar.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 40),
               coffeeDiaryCalendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
               coffeeDiaryCalendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
               coffeeDiaryCalendar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
               coffeeDiaryCalendar.heightAnchor.constraint(equalToConstant: 500)
           ])
       }
       
       private func setupActionButtons() {
           let buttonSymbols = ["square.and.arrow.up", "square.and.pencil", "trash"]
           let actionButtonStack = CalendarCellButtonStack(buttonSymbols: buttonSymbols)

           contentView.addSubview(actionButtonStack)

           NSLayoutConstraint.activate([
               actionButtonStack.topAnchor.constraint(equalTo: coffeeDiaryCalendar.topAnchor, constant: -30),
               actionButtonStack.trailingAnchor.constraint(equalTo: coffeeDiaryCalendar.trailingAnchor, constant: -10)
           ])
       }
    }
