//
//  CoffeeStatusByMood.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//

import UIKit

protocol CoffeeStatusByMoodDelegate: AnyObject {
    func coffeeStatusByMoodDidTapActionButton()
    func coffeeStatusByMoodDidUpdateImages(_ imageUrls: [String])
    
}

class CoffeeStatusByMood: UIView {

    weak var delegate: CoffeeStatusByMoodDelegate?

    let titleLabel = UILabel()
    let mainTitleLabel = UILabel()
    let moodLayerContainer = UIView()
    let moodIconView = UIImageView()
    let moodIconBackgroundView = UIView()
    let recordedLabel = UILabel()
    let topTagsStackView = UIStackView()
    let bottomTagsStackView = UIStackView()
    let mainTagsStackView = UIStackView()
    let actionButton = UIButton()
    let actionButtonBackgroundView = UIView()

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

        mainTitleLabel.text = NSLocalizedString("coffee_for_your_mood", comment: "")
        mainTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        mainTitleLabel.textAlignment = .left
        mainTitleLabel.textColor = AppColors.color51
        self.addSubview(mainTitleLabel)
        self.addSubview(sampleLabel)
        
        titleLabel.text = NSLocalizedString("your_favorite_in_this_mood", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppColors.color58
        self.addSubview(titleLabel)

        moodIconBackgroundView.backgroundColor = AppColors.color64
        moodIconBackgroundView.layer.cornerRadius = 30
        moodIconBackgroundView.clipsToBounds = true
        self.addSubview(moodIconBackgroundView)

        moodIconView.contentMode = .scaleAspectFit
        moodIconBackgroundView.addSubview(moodIconView)

        moodLayerContainer.backgroundColor = .clear
        moodLayerContainer.layer.cornerRadius = 10
        moodLayerContainer.clipsToBounds = true
        self.addSubview(moodLayerContainer)

        recordedLabel.text = NSLocalizedString("recorded_together_with", comment: "")
        recordedLabel.font = UIFont.systemFont(ofSize: 14)
        recordedLabel.textColor = AppColors.color63
        self.addSubview(recordedLabel)

        mainTagsStackView.axis = .vertical
        mainTagsStackView.alignment = .fill
        mainTagsStackView.distribution = .fillEqually
        mainTagsStackView.spacing = 10
        self.addSubview(mainTagsStackView)

        topTagsStackView.axis = .horizontal
        topTagsStackView.alignment = .center
        topTagsStackView.distribution = .fillEqually
        topTagsStackView.spacing = 10

        bottomTagsStackView.axis = .horizontal
        bottomTagsStackView.alignment = .center
        bottomTagsStackView.distribution = .fillEqually
        bottomTagsStackView.spacing = 10

        mainTagsStackView.addArrangedSubview(topTagsStackView)
        mainTagsStackView.addArrangedSubview(bottomTagsStackView)

        actionButtonBackgroundView.backgroundColor = AppColors.color64
        actionButtonBackgroundView.layer.cornerRadius = 10
        actionButtonBackgroundView.clipsToBounds = true
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        self.addSubview(actionButtonBackgroundView)

        actionButton.setImage(UIImage(named: "a"), for: .normal)
        actionButton.backgroundColor = .clear
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonBackgroundView.addSubview(actionButton)

        setupConstraints()
    }

    func setPremiumStatus(isPremium: Bool) {
        sampleLabel.isHidden = isPremium
        actionButton.isEnabled = isPremium
       
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }
    
    @objc private func actionButtonTapped() {
        delegate?.coffeeStatusByMoodDidTapActionButton()
    }
    
    func updateMoodImages(with imageUrls: [String]) {
       
        delegate?.coffeeStatusByMoodDidUpdateImages(imageUrls)
    }
    

    func updateWithMoodType(_ moodType: String, coffeeTypeCounts: [(coffeeType: String, count: Int)]) {
      
      
        let defaultCoffees: [(coffeeType: String, count: Int)] = [
            (coffeeType: "Espresso", count: 0),
            (coffeeType: "Americano", count: 0),
            (coffeeType: "Cappuccino", count: 0),
            (coffeeType: "Latte", count: 0)
        ]
        
     
        let combinedCounts: [(coffeeType: String, count: Int)]
        if coffeeTypeCounts.isEmpty {
           
            combinedCounts = defaultCoffees
        } else {
           
            var updatedCounts = defaultCoffees
            for coffee in coffeeTypeCounts {
                if let index = updatedCounts.firstIndex(where: { $0.coffeeType == coffee.coffeeType }) {
                    
                    updatedCounts[index].count = coffee.count
                } else {
                   
                    updatedCounts.insert(coffee, at: 0)
                }
            }
            combinedCounts = updatedCounts
        }
        
       
        moodIconView.image = UIImage(named: moodType)
        
      
        mainTagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        topTagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        bottomTagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        createMoodSegments(coffeeTypeCounts: combinedCounts)
        
     
        for (index, coffeeType) in combinedCounts.prefix(4).enumerated() {
            let tagView = createTagView(iconName: coffeeType.coffeeType, label: "\(coffeeType.coffeeType) x\(coffeeType.count)")
            if index < 2 {
                topTagsStackView.addArrangedSubview(tagView)
            } else {
                bottomTagsStackView.addArrangedSubview(tagView)
            }
        }
        
       
        mainTagsStackView.addArrangedSubview(topTagsStackView)
        mainTagsStackView.addArrangedSubview(bottomTagsStackView)
    }

    private func createMoodSegments(coffeeTypeCounts: [(coffeeType: String, count: Int)]) {
        let total = coffeeTypeCounts.reduce(0) { $0 + $1.count }
        let segmentColors: [UIColor] = [
            AppColors.color63,
            AppColors.color59,
            AppColors.color62,
            AppColors.color61
        ]

        moodLayerContainer.subviews.forEach { $0.removeFromSuperview() }
        var previousSegment: UIView? = nil

    
        if total == 0 {
            for (index, color) in segmentColors.enumerated() {
                let segmentView = UIView()
                segmentView.backgroundColor = color
                moodLayerContainer.addSubview(segmentView)

                segmentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    segmentView.topAnchor.constraint(equalTo: moodLayerContainer.topAnchor),
                    segmentView.bottomAnchor.constraint(equalTo: moodLayerContainer.bottomAnchor),
                    segmentView.widthAnchor.constraint(equalTo: moodLayerContainer.widthAnchor, multiplier: 0.25)
                ])

                if let previous = previousSegment {
                    segmentView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
                } else {
                    segmentView.leadingAnchor.constraint(equalTo: moodLayerContainer.leadingAnchor).isActive = true
                }

                previousSegment = segmentView
            }
            return
        }

       
        for (index, coffeeType) in coffeeTypeCounts.enumerated() {
            let segmentView = UIView()
            segmentView.backgroundColor = segmentColors[index % segmentColors.count]
            moodLayerContainer.addSubview(segmentView)

            segmentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                segmentView.topAnchor.constraint(equalTo: moodLayerContainer.topAnchor),
                segmentView.bottomAnchor.constraint(equalTo: moodLayerContainer.bottomAnchor),
                segmentView.widthAnchor.constraint(equalTo: moodLayerContainer.widthAnchor, multiplier: CGFloat(coffeeType.count) / CGFloat(total))
            ])

            if let previous = previousSegment {
                segmentView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
            } else {
                segmentView.leadingAnchor.constraint(equalTo: moodLayerContainer.leadingAnchor).isActive = true
            }

            previousSegment = segmentView
        }
    }



    private func createTagView(iconName: String, label: String) -> UIView {
        let tagContainerView = UIView()
        tagContainerView.backgroundColor = AppColors.color24
        tagContainerView.layer.borderColor = AppColors.color7.cgColor
        tagContainerView.layer.borderWidth = 1
        tagContainerView.layer.shadowColor = UIColor.black.cgColor
        tagContainerView.layer.shadowOpacity = 0.1
        tagContainerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        tagContainerView.layer.shadowRadius = 3
        tagContainerView.translatesAutoresizingMaskIntoConstraints = false

        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        innerStackView.alignment = .center
        innerStackView.spacing = 8
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainerView.addSubview(innerStackView)

        let circularBackgroundView = UIView()
        circularBackgroundView.backgroundColor = AppColors.color88
        circularBackgroundView.layer.cornerRadius = 14
        circularBackgroundView.layer.borderColor = AppColors.color67.cgColor
        circularBackgroundView.layer.borderWidth = 1
        circularBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        circularBackgroundView.addSubview(iconImageView)

        let tagLabel = UILabel()
        tagLabel.text = label
        tagLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tagLabel.textColor = AppColors.color36
        tagLabel.numberOfLines = 1
        tagLabel.lineBreakMode = .byTruncatingTail
        tagLabel.minimumScaleFactor = 0.7
        tagLabel.adjustsFontSizeToFitWidth = true
        tagLabel.translatesAutoresizingMaskIntoConstraints = false

        innerStackView.addArrangedSubview(circularBackgroundView)
        innerStackView.addArrangedSubview(tagLabel)

        NSLayoutConstraint.activate([
            innerStackView.leadingAnchor.constraint(equalTo: tagContainerView.leadingAnchor, constant: 10),
            innerStackView.trailingAnchor.constraint(equalTo: tagContainerView.trailingAnchor, constant: -10),
            innerStackView.topAnchor.constraint(equalTo: tagContainerView.topAnchor, constant: 4),
            innerStackView.bottomAnchor.constraint(equalTo: tagContainerView.bottomAnchor, constant: -4),

            circularBackgroundView.widthAnchor.constraint(equalToConstant: 28),
            circularBackgroundView.heightAnchor.constraint(equalToConstant: 28),

            iconImageView.centerXAnchor.constraint(equalTo: circularBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circularBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),

            tagContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            tagContainerView.heightAnchor.constraint(equalToConstant: 40),
        ])

        tagContainerView.layer.cornerRadius = 20
        return tagContainerView
    }

    private func setupConstraints() {
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        moodLayerContainer.translatesAutoresizingMaskIntoConstraints = false
        moodIconView.translatesAutoresizingMaskIntoConstraints = false
        moodIconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        recordedLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTagsStackView.translatesAutoresizingMaskIntoConstraints = false
        topTagsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomTagsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButtonBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            mainTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            sampleLabel.centerYAnchor.constraint(equalTo: mainTitleLabel.centerYAnchor),
            sampleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor, constant: 10),
            sampleLabel.widthAnchor.constraint(equalToConstant: 80),
            sampleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            moodIconBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            moodIconBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            moodIconBackgroundView.widthAnchor.constraint(equalToConstant: 60),
            moodIconBackgroundView.heightAnchor.constraint(equalToConstant: 60),

            moodIconView.centerXAnchor.constraint(equalTo: moodIconBackgroundView.centerXAnchor),
            moodIconView.centerYAnchor.constraint(equalTo: moodIconBackgroundView.centerYAnchor),
            moodIconView.widthAnchor.constraint(equalToConstant: 50),
            moodIconView.heightAnchor.constraint(equalToConstant: 50),

            moodLayerContainer.centerYAnchor.constraint(equalTo: moodIconBackgroundView.centerYAnchor),
            moodLayerContainer.leadingAnchor.constraint(equalTo: moodIconBackgroundView.trailingAnchor, constant: 15),
            moodLayerContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            moodLayerContainer.heightAnchor.constraint(equalToConstant: 20),

            recordedLabel.topAnchor.constraint(equalTo: moodIconBackgroundView.bottomAnchor, constant: 30),
            recordedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            mainTagsStackView.topAnchor.constraint(equalTo: recordedLabel.bottomAnchor, constant: 20),
            mainTagsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainTagsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainTagsStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -20),

            actionButtonBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            actionButtonBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            actionButtonBackgroundView.widthAnchor.constraint(equalToConstant: 50),
            actionButtonBackgroundView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.centerXAnchor.constraint(equalTo: actionButtonBackgroundView.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: actionButtonBackgroundView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 50),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
