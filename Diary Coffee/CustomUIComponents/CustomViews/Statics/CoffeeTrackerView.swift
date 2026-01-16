//
//  CoffeeTracker.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 10.11.2024.
//

import UIKit

class CoffeeTrackerView: UIView {
    
    var goButtonAction: (() -> Void)?
    var goButton: UIButton!
    private var imageViews: [[UIImageView]] = []
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = AppColors.color2
        self.layer.cornerRadius = 16
        
    
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("a_year_gone_with_coffee", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColors.color51
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
       
        descriptionLabel.text = String(format: NSLocalizedString("look_back_on_2024", comment: ""), Calendar.current.component(.year, from: Date()))
               descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
               descriptionLabel.textColor = AppColors.color65
               descriptionLabel.textAlignment = .left
               descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
               self.addSubview(descriptionLabel)
        
        
        let tableContainer = UIView()
        tableContainer.backgroundColor = AppColors.color2
        tableContainer.layer.cornerRadius = 10
        tableContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableContainer)
        
       
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = AppColors.color20
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        tableContainer.addSubview(horizontalLine)
        
        let verticalLine = UIView()
        verticalLine.backgroundColor = AppColors.color20
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        tableContainer.addSubview(verticalLine)
        
      
        let numberOfColumns = 12
        let numberOfRows = 6
        let cellSpacing: CGFloat = 2
        let totalPadding: CGFloat = 40
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - totalPadding - CGFloat(numberOfColumns + 1) * cellSpacing) / CGFloat(numberOfColumns) - 2
        let cellHeight = cellWidth
        
        let monthFont = UIFont.systemFont(ofSize: 10, weight: .bold)
        let cellColor = AppColors.color20
        

      
        for month in 0..<numberOfColumns {
            let monthLabel = UILabel()
            monthLabel.text = "\(month + 1)"
            monthLabel.font = monthFont
            monthLabel.textColor = cellColor
            monthLabel.textAlignment = .center
            monthLabel.translatesAutoresizingMaskIntoConstraints = false
            tableContainer.addSubview(monthLabel)
            
            NSLayoutConstraint.activate([
                monthLabel.topAnchor.constraint(equalTo: tableContainer.topAnchor),
                monthLabel.widthAnchor.constraint(equalToConstant: cellWidth),
                monthLabel.heightAnchor.constraint(equalToConstant: cellHeight),
                monthLabel.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: CGFloat(month) * (cellWidth + cellSpacing) + cellSpacing)
            ])
        }
        

        for row in 0..<numberOfRows {
            let rowLabel = UILabel()
            rowLabel.text = "\(row + 1)"
            rowLabel.font = monthFont
            rowLabel.textColor = cellColor.withAlphaComponent(row < 3 ? 1.0 : 0.4)
            rowLabel.textAlignment = .center
            rowLabel.translatesAutoresizingMaskIntoConstraints = false
            tableContainer.addSubview(rowLabel)
            
            NSLayoutConstraint.activate([
                rowLabel.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor),
                rowLabel.widthAnchor.constraint(equalToConstant: cellWidth),
                rowLabel.heightAnchor.constraint(equalToConstant: cellHeight),
                rowLabel.topAnchor.constraint(equalTo: tableContainer.topAnchor, constant: CGFloat(row + 1) * (cellHeight + cellSpacing) + cellSpacing)
            ])
            
            var rowImageViews: [UIImageView] = []
                      for col in 0..<numberOfColumns {
                          let imageView = UIImageView()
                         // imageView.layer.cornerRadius = cellWidth / 2
                          imageView.clipsToBounds = true
                          imageView.contentMode = .scaleAspectFill
                          imageView.image = nil
                          imageView.translatesAutoresizingMaskIntoConstraints = false
                          tableContainer.addSubview(imageView)
                          rowImageViews.append(imageView) 
                          
                          imageView.alpha = row < 3 ? 1.0 : (1.0 - 0.2 * CGFloat(row - 2))
                          
                          NSLayoutConstraint.activate([
                              imageView.widthAnchor.constraint(equalToConstant: cellWidth),
                              imageView.heightAnchor.constraint(equalToConstant: cellHeight),
                              imageView.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: CGFloat(col) * (cellWidth + cellSpacing) + cellSpacing),
                              imageView.topAnchor.constraint(equalTo: rowLabel.bottomAnchor, constant: -20)
                          ])
                      }
                      imageViews.append(rowImageViews)
                
        }

      
        NSLayoutConstraint.activate([
            horizontalLine.heightAnchor.constraint(equalToConstant: 2),
            horizontalLine.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor),
            horizontalLine.trailingAnchor.constraint(equalTo: tableContainer.trailingAnchor),
            horizontalLine.topAnchor.constraint(equalTo: tableContainer.topAnchor, constant: cellHeight + cellSpacing),
            
            verticalLine.widthAnchor.constraint(equalToConstant: 2),
            verticalLine.topAnchor.constraint(equalTo: tableContainer.topAnchor),
            verticalLine.bottomAnchor.constraint(equalTo: tableContainer.bottomAnchor),
            verticalLine.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor, constant: cellWidth + cellSpacing)
        ])
        
              goButton = UIButton()
              goButton.setTitle(NSLocalizedString("go", comment: ""), for: .normal)
              goButton.backgroundColor = AppColors.color20
              goButton.setTitleColor(self.backgroundColor, for: .normal)
              goButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
              goButton.layer.cornerRadius = 10
              goButton.translatesAutoresizingMaskIntoConstraints = false
             goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
              self.addSubview(goButton)
        
       
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            tableContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            tableContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            tableContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            tableContainer.heightAnchor.constraint(equalToConstant: CGFloat(numberOfRows) * (cellHeight + cellSpacing) + cellHeight + 10),
            
            goButton.topAnchor.constraint(equalTo: tableContainer.bottomAnchor, constant: 30),
                       goButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                       goButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                       goButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setPremiumStatus(isPremium: Bool) {
           goButton.isEnabled = isPremium
          
       }
    
    @objc private func goButtonTapped() {
         if goButton.isEnabled {
             goButtonAction?()
         }
     }
    
    func updateMoodImages(with imageUrls: [String]) {
        let orderedKeys = ["kissing", "smile", "wow", "sleep", "angry", "sad"]
        
       
        for (rowIndex, key) in orderedKeys.enumerated() {
           
            let rowImageViews = imageViews[rowIndex]
          
            if let matchingUrlString = imageUrls.first(where: { $0.contains(key) }),
               let url = URL(string: matchingUrlString) {
                
              
                for imageView in rowImageViews {
                    URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                        guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else { return }
                        
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }.resume()
                }
            }
        }
    }
   

    func updateDescriptionLabel(year: Int) {
        let localizedString = NSLocalizedString("look_back_on_2024", comment: "")
        let updatedText = String(format: localizedString, year)
        descriptionLabel.text = updatedText
    }


}

