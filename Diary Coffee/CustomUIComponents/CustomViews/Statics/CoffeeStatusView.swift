//
//  CoffeeStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//

import Foundation
import UIKit


protocol CoffeeStatusViewDelegate: AnyObject {
    func didTapCoffeeMoreButton()
}


class CoffeeStatusView: UIView {

    weak var delegate: CoffeeStatusViewDelegate?
    
    private let titleLabel = UILabel()
    private var momentsDescriptionLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let momentsStackView = UIStackView()

    private let sampleLabel: SampleLabel = {
           let label = SampleLabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
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

       titleLabel.text = NSLocalizedString("your_favorite_coffees", comment: "")
       titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColors.color51
        self.addSubview(titleLabel)
        self.addSubview(sampleLabel)

              momentsDescriptionLabel = UILabel()

        let fullText = NSLocalizedString("the_coffee_you_enjoyed_the_most", comment: "")
              let attributedText = NSMutableAttributedString(string: fullText)


              let brownColor = AppColors.color65
              let brownFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        attributedText.addAttribute(.foregroundColor, value: brownColor, range: (fullText as NSString).range(of: NSLocalizedString("you_enjoyed_the_most", comment: "")))
        attributedText.addAttribute(.font, value: brownFont, range: (fullText as NSString).range(of: NSLocalizedString("you_enjoyed_the_most", comment: "")))

            
              let greenColor = AppColors.color61
              let greenFont = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)!
        attributedText.addAttribute(.foregroundColor, value: greenColor, range: (fullText as NSString).range(of: NSLocalizedString("the_coffee", comment: "")))
        attributedText.addAttribute(.font, value: greenFont, range: (fullText as NSString).range(of: NSLocalizedString("the_coffee", comment: "")))

            
              let paragraphStyle = NSMutableParagraphStyle()
              paragraphStyle.lineSpacing = 4
              attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, fullText.count))
              attributedText.addAttribute(.kern, value: 0.8, range: NSMakeRange(0, fullText.count))

          
              momentsDescriptionLabel.attributedText = attributedText
              momentsDescriptionLabel.textAlignment = .center
              momentsDescriptionLabel.numberOfLines = 0
              momentsDescriptionLabel.adjustsFontSizeToFitWidth = true
              momentsDescriptionLabel.minimumScaleFactor = 0.5
              self.addSubview(momentsDescriptionLabel)


              let moreImage = UIImage(systemName: "ellipsis")
              moreButton.setImage(moreImage, for: .normal)
              moreButton.tintColor = AppColors.color51
              moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
              self.addSubview(moreButton)

              momentsStackView.axis = .horizontal
              momentsStackView.alignment = .center
              momentsStackView.distribution = .fillEqually
              momentsStackView.spacing = 10
              self.addSubview(momentsStackView)


        setupConstraints()
    }
    
    func setPremiumStatus(isPremium: Bool) {
        sampleLabel.isHidden = isPremium
        moreButton.isEnabled = isPremium
       
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }

    private func setupConstraints() {
         titleLabel.translatesAutoresizingMaskIntoConstraints = false
         momentsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
         moreButton.translatesAutoresizingMaskIntoConstraints = false
         momentsStackView.translatesAutoresizingMaskIntoConstraints = false

         NSLayoutConstraint.activate([
             titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
             titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

             sampleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
             sampleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
             sampleLabel.widthAnchor.constraint(equalToConstant: 80),
             sampleLabel.heightAnchor.constraint(equalToConstant: 30),
             
             momentsDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
             momentsDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

             moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
             moreButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

             momentsStackView.topAnchor.constraint(equalTo: momentsDescriptionLabel.bottomAnchor, constant: 30),
             momentsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
             momentsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
             momentsStackView.heightAnchor.constraint(equalToConstant: 180),

             self.heightAnchor.constraint(equalToConstant: 320)
         ])
     }


    func configureWithEntries(_ entries: [JournalEntryInfo]) {
      
        var defaultCoffees = [
            (coffeeType: "Espresso", count: 0, imageName: "Espresso"),
            (coffeeType: "Latte", count: 0, imageName: "Latte"),
            (coffeeType: "Cappuccino", count: 0, imageName: "Cappuccino")
        ]
        
     
        if entries.isEmpty {
            updateWithTopCoffees(defaultCoffees)
            return
        }
        
      
        var coffeeTypeCount: [String: Int] = [:]
        for entry in entries {
            coffeeTypeCount[entry.coffeeType, default: 0] += 1
        }
        
      
        let topCoffeeTypes = coffeeTypeCount.sorted { $0.value > $1.value }.prefix(3)
        
       
        var topCoffeeViews = [(coffeeType: String, count: Int, imageName: String)]()
        for (coffeeType, count) in topCoffeeTypes {
            let imageName = coffeeType
            topCoffeeViews.append((coffeeType: coffeeType, count: count, imageName: imageName))
        }
        
      
        let remainingDefaultCoffees = defaultCoffees.prefix(3 - topCoffeeViews.count)
        topCoffeeViews.append(contentsOf: remainingDefaultCoffees)
        
       
        updateWithTopCoffees(topCoffeeViews)
    }


    private func updateWithTopCoffees(_ topCoffees: [(coffeeType: String, count: Int, imageName: String)]) {
        momentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, coffee) in topCoffees.enumerated() {
            let coffeeView = createCoffeeView(rank: "\(index + 1)", imageName: coffee.imageName, label: coffee.coffeeType, count: "x\(coffee.count)")
            momentsStackView.addArrangedSubview(coffeeView)
        }
    }
    
    private func createCoffeeView(rank: String, imageName: String, label: String, count: String) -> UIView {
        let coffeeView = UIView()
        coffeeView.layer.cornerRadius = 12
        coffeeView.backgroundColor = AppColors.color20
        coffeeView.layer.shadowColor = UIColor.black.cgColor
        coffeeView.layer.shadowOpacity = 0.2
        coffeeView.layer.shadowOffset = CGSize(width: 0, height: 4)
        coffeeView.layer.shadowRadius = 6
        coffeeView.translatesAutoresizingMaskIntoConstraints = false

        let circleView = UIView()
        circleView.layer.cornerRadius = 35
        circleView.backgroundColor = AppColors.color50
        coffeeView.addSubview(circleView)

        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        circleView.addSubview(imageView)

        let rankLabel = UILabel()
        rankLabel.text = rank
        rankLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        rankLabel.textColor = AppColors.color50
        coffeeView.addSubview(rankLabel)

        let descriptionLabel = UILabel()
        descriptionLabel.text = label
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = AppColors.color5
        coffeeView.addSubview(descriptionLabel)

        let countLabel = UILabel()
        countLabel.text = count
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        countLabel.textColor = AppColors.color5
        coffeeView.addSubview(countLabel)

        circleView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rankLabel.topAnchor.constraint(equalTo: coffeeView.topAnchor, constant: 10),
            rankLabel.leadingAnchor.constraint(equalTo: coffeeView.leadingAnchor, constant: 12),

            circleView.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 5),
            circleView.centerXAnchor.constraint(equalTo: coffeeView.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 70),
            circleView.heightAnchor.constraint(equalToConstant: 70),

            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),

            descriptionLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: coffeeView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: coffeeView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: coffeeView.trailingAnchor, constant: -16),

            countLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            countLabel.centerXAnchor.constraint(equalTo: coffeeView.centerXAnchor),
            countLabel.bottomAnchor.constraint(equalTo: coffeeView.bottomAnchor, constant: -10)
        ])

        return coffeeView
    }
    
    @objc private func moreButtonTapped() {
        delegate?.didTapCoffeeMoreButton()
    }
}
