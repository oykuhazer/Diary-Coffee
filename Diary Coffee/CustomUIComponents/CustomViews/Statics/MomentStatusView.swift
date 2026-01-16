//
//  MomentStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//



import UIKit

protocol MomentStatusViewDelegate: AnyObject {
    func didTapMomentMoreButton()
}

class MomentStatusView: UIView {

  
    weak var delegate: MomentStatusViewDelegate?

    private let columns = 4
       private let padding: CGFloat = 15

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

     
        titleLabel.text = NSLocalizedString("frequently_together", comment: "")
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColors.color51
        
        self.addSubview(titleLabel)
        self.addSubview(sampleLabel)

        momentsDescriptionLabel = UILabel()

        let fullText = NSLocalizedString("moments_you_drank_coffee", comment: "")
              let attributedText = NSMutableAttributedString(string: fullText)

              
              let brownColor = AppColors.color65
              let brownFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        attributedText.addAttribute(.foregroundColor, value: brownColor, range: (fullText as NSString).range(of: NSLocalizedString("you_drank_coffee", comment: "")))
        attributedText.addAttribute(.font, value: brownFont, range: (fullText as NSString).range(of: NSLocalizedString("you_drank_coffee", comment: "")))

           
              let greenColor = AppColors.color61
              let greenFont = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)!
        attributedText.addAttribute(.foregroundColor, value: greenColor, range: (fullText as NSString).range(of: NSLocalizedString("moments", comment: "")))
        attributedText.addAttribute(.font, value: greenFont, range: (fullText as NSString).range(of: NSLocalizedString("moments", comment: "")))
        
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
              self.addSubview(moreButton)
              moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)

           
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
       
        let defaultMoments = [
            (momentType: "Morning", count: 0, imageName: "Morning"),
            (momentType: "Work Break", count: 0, imageName: "Work Break"),
            (momentType: "Friends", count: 0, imageName: "Friends")
        ]
        
     
        if entries.isEmpty {
            updateWithTopMoments(defaultMoments)
            return
        }
        
        
        var momentCount: [String: Int] = [:]
        for entry in entries {
            momentCount[entry.coffeeMomentType, default: 0] += 1
        }
        
    
        let topMoments = momentCount.sorted { $0.value > $1.value }.prefix(3)
        
       
        var topMomentViews = [(momentType: String, count: Int, imageName: String)]()
        for (momentType, count) in topMoments {
            let imageName = momentType
            topMomentViews.append((momentType: momentType, count: count, imageName: imageName))
        }
        
       
        if topMomentViews.count < 3 {
            let remainingDefaultMoments = defaultMoments.prefix(3 - topMomentViews.count)
            topMomentViews.append(contentsOf: remainingDefaultMoments)
        }
        
       
        updateWithTopMoments(topMomentViews)
    }


    private func updateWithTopMoments(_ topMoments: [(momentType: String, count: Int, imageName: String)]) {
        
        momentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, moment) in topMoments.enumerated() {
            let momentView = createMomentView(rank: "\(index + 1)", imageName: moment.imageName, label: moment.momentType, count: "x\(moment.count)")
            momentsStackView.addArrangedSubview(momentView)
        }
    }
    
    private func createMomentView(rank: String, imageName: String, label: String, count: String) -> UIView {
          let momentView = UIView()
          momentView.layer.cornerRadius = 12
        momentView.backgroundColor = AppColors.color20
          momentView.layer.shadowColor = UIColor.black.cgColor
          momentView.layer.shadowOpacity = 0.2
          momentView.layer.shadowOffset = CGSize(width: 0, height: 4)
          momentView.layer.shadowRadius = 6
          momentView.translatesAutoresizingMaskIntoConstraints = false

        
          let circleView = UIView()
          circleView.layer.cornerRadius = 35
          circleView.backgroundColor = AppColors.color50
          circleView.layer.shadowColor = UIColor.black.cgColor
          circleView.layer.shadowOpacity = 0.1
          circleView.layer.shadowOffset = CGSize(width: 0, height: 2)
          circleView.layer.shadowRadius = 4
          circleView.translatesAutoresizingMaskIntoConstraints = false
          momentView.addSubview(circleView)

         
          let imageView = UIImageView(image: UIImage(named: imageName))
          imageView.contentMode = .scaleAspectFit
          imageView.tintColor = UIColor.white
          circleView.addSubview(imageView)

        
          let rankLabel = UILabel()
          rankLabel.text = rank
          rankLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
          rankLabel.textColor = AppColors.color50
          rankLabel.textAlignment = .left
          momentView.addSubview(rankLabel)

         
          let descriptionLabel = UILabel()
          descriptionLabel.text = label
          descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
          descriptionLabel.textColor = AppColors.color5
          descriptionLabel.textAlignment = .center
          momentView.addSubview(descriptionLabel)

          
          let countLabel = UILabel()
          countLabel.text = count
          countLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
          countLabel.textColor = AppColors.color5
          countLabel.textAlignment = .center
          momentView.addSubview(countLabel)

        
          circleView.translatesAutoresizingMaskIntoConstraints = false
          imageView.translatesAutoresizingMaskIntoConstraints = false
          rankLabel.translatesAutoresizingMaskIntoConstraints = false
          descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
          countLabel.translatesAutoresizingMaskIntoConstraints = false

          NSLayoutConstraint.activate([

              rankLabel.topAnchor.constraint(equalTo: momentView.topAnchor, constant: 10),
              rankLabel.leadingAnchor.constraint(equalTo: momentView.leadingAnchor, constant: 12),

              circleView.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 5),
              circleView.centerXAnchor.constraint(equalTo: momentView.centerXAnchor),
              circleView.widthAnchor.constraint(equalToConstant: 70),
              circleView.heightAnchor.constraint(equalToConstant: 70),

              imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
              imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
              imageView.widthAnchor.constraint(equalToConstant: 70),
              imageView.heightAnchor.constraint(equalToConstant: 70),

              descriptionLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 10),
              descriptionLabel.centerXAnchor.constraint(equalTo: momentView.centerXAnchor),
              descriptionLabel.leadingAnchor.constraint(equalTo: momentView.leadingAnchor, constant: 16),
              descriptionLabel.trailingAnchor.constraint(equalTo: momentView.trailingAnchor, constant: -16),

              countLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
              countLabel.centerXAnchor.constraint(equalTo: momentView.centerXAnchor),
              countLabel.bottomAnchor.constraint(equalTo: momentView.bottomAnchor, constant: -10)
          ])

          return momentView
      }

    @objc private func moreButtonTapped() {
        delegate?.didTapMomentMoreButton()
    }
}



