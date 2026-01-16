//
//  CoffeeDiaryCalendarCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit

class CoffeeDiaryCalendarCell: UICollectionViewCell {
    
   weak var delegate: CoffeeDiaryCalendarCellDelegate?
   private var entryId: String?
   let diaryText = UITextView()
   private let circularView = UIView()
   private let coffeeTagView = DiaryListTagView(iconName: "")
   private let coffeeTagView2 = DiaryListTagView(iconName: "")
   private let imageView = UIImageView()
   private let lineView = UIView()
   private let dayLabel = UILabel()

   private let sticker1Container = UIView()
   private let sticker2Container = UIView()
   private let sticker3Container = UIView()
   private let sticker1 = UIImageView()
   private let sticker2 = UIImageView()
   private let sticker3 = UIImageView()
   
   private let imageContainerView = UIView()
   private let image1Container = UIView()
   private let image2Container = UIView()
   private let image3Container = UIView()
    
   private let image1 = UIImageView()
   private let image2 = UIImageView()
   private let image3 = UIImageView()

   private var diaryTextHeightConstraint: NSLayoutConstraint!
    /*"square.and.pencil"*/
   private let actionButtonStack: UIStackView = {
          let buttonSymbols = ["trash"]
          var buttons = [UIButton]()
          
          for symbolName in buttonSymbols {
              let button = UIButton(type: .system)
              button.setImage(UIImage(systemName: symbolName), for: .normal)
              button.tintColor = AppColors.color5
              if symbolName == "trash" {
                  button.tag = 1
              }
              buttons.append(button)
          }
       
          let stackView = UIStackView(arrangedSubviews: buttons)
          stackView.axis = .horizontal
          stackView.spacing = 8
          stackView.translatesAutoresizingMaskIntoConstraints = false
          return stackView
      }()
   
   override init(frame: CGRect) {
          super.init(frame: frame)
          setupCell()
       if let trashButton = actionButtonStack.arrangedSubviews.first(where: { $0.tag == 1 }) as? UIButton {
             trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
         }

        
         if let editButton = actionButtonStack.arrangedSubviews.first(where: { ($0 as? UIButton)?.currentImage == UIImage(systemName: "square.and.pencil") }) as? UIButton {
             editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
         }
      }

    
    @objc private func editButtonTapped() {
        guard let entryId = entryId else { return }
        delegate?.editEntry(with: entryId, isFromEditButton: true)
    }


    
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   
   private func setupCell() {
       backgroundColor = AppColors.color26
       layer.cornerRadius = 12
       layer.masksToBounds = true

       circularView.backgroundColor = AppColors.color4
       circularView.translatesAutoresizingMaskIntoConstraints = false
       circularView.layer.cornerRadius = 25
       circularView.layer.borderWidth = 1
       circularView.layer.borderColor = AppColors.color5.cgColor
       circularView.layer.shadowColor = UIColor.black.cgColor
       circularView.layer.shadowOpacity = 0.15
       circularView.layer.shadowOffset = CGSize(width: 0, height: 2)
       circularView.layer.shadowRadius = 3
       contentView.addSubview(circularView)

       lineView.backgroundColor = AppColors.color20
       lineView.translatesAutoresizingMaskIntoConstraints = false
       contentView.addSubview(lineView)

       imageView.contentMode = .scaleAspectFit
       imageView.translatesAutoresizingMaskIntoConstraints = false
       circularView.addSubview(imageView)

       dayLabel.text = "12 Tue"
       dayLabel.textAlignment = .center
       dayLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
       dayLabel.translatesAutoresizingMaskIntoConstraints = false
       dayLabel.textColor = AppColors.color2
       dayLabel.backgroundColor = AppColors.color1
       dayLabel.layer.cornerRadius = 5
       dayLabel.layer.masksToBounds = true
       contentView.addSubview(dayLabel)

       coffeeTagView.translatesAutoresizingMaskIntoConstraints = false
       contentView.addSubview(coffeeTagView)
       
       coffeeTagView2.translatesAutoresizingMaskIntoConstraints = false
       contentView.addSubview(coffeeTagView2)

       
       diaryText.translatesAutoresizingMaskIntoConstraints = false
              diaryText.textAlignment = .justified
              diaryText.textColor = AppColors.color2
              diaryText.font = UIFont.boldSystemFont(ofSize: 16)
              diaryText.isScrollEnabled = false
              diaryText.isEditable = false
              diaryText.isSelectable = false
              diaryText.showsVerticalScrollIndicator = false
              diaryText.showsHorizontalScrollIndicator = false
              diaryText.backgroundColor = .clear
              contentView.addSubview(diaryText)



       setupStickerContainer(sticker1Container, with: sticker1)
       setupStickerContainer(sticker2Container, with: sticker2)
       setupStickerContainer(sticker3Container, with: sticker3)

       contentView.addSubview(sticker1Container)
       contentView.addSubview(sticker2Container)
       contentView.addSubview(sticker3Container)
       contentView.addSubview(actionButtonStack)
    
       imageContainerView.translatesAutoresizingMaskIntoConstraints = false
       contentView.addSubview(imageContainerView)

     
       [image1Container, image2Container, image3Container].forEach { container in
           container.backgroundColor = AppColors.color7
           container.layer.cornerRadius = 10
           container.layer.shadowColor = UIColor.black.cgColor
           container.layer.shadowOpacity = 0.1
           container.layer.shadowOffset = CGSize(width: 1, height: 1)
           container.layer.shadowRadius = 2
           container.translatesAutoresizingMaskIntoConstraints = false
           imageContainerView.addSubview(container)
       }

     
       [image1, image2, image3].enumerated().forEach { index, image in
           image.contentMode = .scaleAspectFill
           image.layer.cornerRadius = 8
           image.layer.masksToBounds = true
           image.translatesAutoresizingMaskIntoConstraints = false
           
           let container = [image1Container, image2Container, image3Container][index]
           container.addSubview(image)
           
           NSLayoutConstraint.activate([
               image.widthAnchor.constraint(equalToConstant: 50),
               image.heightAnchor.constraint(equalToConstant: 50),
               image.centerXAnchor.constraint(equalTo: container.centerXAnchor),
               image.centerYAnchor.constraint(equalTo: container.centerYAnchor)
           ])
       }
       diaryTextHeightConstraint = diaryText.heightAnchor.constraint(equalToConstant: 20)
       NSLayoutConstraint.activate([
           circularView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
           circularView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
           circularView.widthAnchor.constraint(equalToConstant: 50),
           circularView.heightAnchor.constraint(equalToConstant: 50),

           imageView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
           imageView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor),
           imageView.widthAnchor.constraint(equalToConstant: 50),
           imageView.heightAnchor.constraint(equalToConstant: 50),

           dayLabel.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: 10),
           dayLabel.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
           dayLabel.widthAnchor.constraint(equalToConstant: 50),
           dayLabel.heightAnchor.constraint(equalToConstant: 20),

           lineView.leadingAnchor.constraint(equalTo: circularView.trailingAnchor, constant: 20),
           lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
           lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
           lineView.widthAnchor.constraint(equalToConstant: 3),

           
           coffeeTagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
           coffeeTagView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 40),

           coffeeTagView2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
           coffeeTagView2.leadingAnchor.constraint(equalTo: coffeeTagView.trailingAnchor, constant: 60),
           
           sticker1Container.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 20),
           sticker1Container.topAnchor.constraint(equalTo: coffeeTagView.topAnchor, constant: 40),
           sticker1Container.widthAnchor.constraint(equalToConstant: 40),
           sticker1Container.heightAnchor.constraint(equalToConstant: 40),

           sticker2Container.leadingAnchor.constraint(equalTo: sticker1Container.trailingAnchor, constant: 10),
           sticker2Container.topAnchor.constraint(equalTo: sticker1Container.topAnchor),
           sticker2Container.widthAnchor.constraint(equalTo: sticker1Container.widthAnchor),
           sticker2Container.heightAnchor.constraint(equalTo: sticker1Container.heightAnchor),

           sticker3Container.leadingAnchor.constraint(equalTo: sticker2Container.trailingAnchor, constant: 10),
           sticker3Container.topAnchor.constraint(equalTo: sticker2Container.topAnchor),
           sticker3Container.widthAnchor.constraint(equalTo: sticker2Container.widthAnchor),
           sticker3Container.heightAnchor.constraint(equalTo: sticker2Container.heightAnchor),

           imageContainerView.topAnchor.constraint(equalTo: sticker3Container.bottomAnchor, constant: 10),
           imageContainerView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10),
           imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           imageContainerView.heightAnchor.constraint(equalToConstant: 80),

           image1Container.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 10),
           image1Container.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 10),
           image1Container.widthAnchor.constraint(equalToConstant: 60),
           image1Container.heightAnchor.constraint(equalToConstant: 60),

           image2Container.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
           image2Container.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 10),
           image2Container.widthAnchor.constraint(equalToConstant: 60),
           image2Container.heightAnchor.constraint(equalToConstant: 60),

           image3Container.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -10),
           image3Container.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 10),
           image3Container.widthAnchor.constraint(equalToConstant: 60),
           image3Container.heightAnchor.constraint(equalToConstant: 60),

         
           diaryText.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10),
                      diaryText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                      diaryText.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 10),
                      diaryTextHeightConstraint,
           diaryText.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),

           actionButtonStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
           actionButtonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
       ])
   }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let calculatedSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        layoutAttributes.frame.size = CGSize(width: calculatedSize.width, height: calculateHeight())
        return layoutAttributes
    }

    
    func calculateHeight() -> CGFloat {
        let textViewSize = diaryText.sizeThatFits(CGSize(width: contentView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        
      
        let hasStickers = !sticker1Container.isHidden || !sticker2Container.isHidden || !sticker3Container.isHidden
        let hasImages = !imageContainerView.isHidden

        let baseHeight: CGFloat = 150
   
        if hasStickers && hasImages {
            return textViewSize.height + baseHeight + 100
        } else if hasStickers {
            return textViewSize.height + baseHeight + 10
        } else if hasImages {
            return textViewSize.height + baseHeight + 40
        } else {
            return textViewSize.height + baseHeight - 50
        }
    }



    private func setupStickerContainer(_ container: UIView, with imageView: UIImageView) {
        container.backgroundColor = AppColors.color7
        container.layer.cornerRadius = 10
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 1, height: 1)
        container.layer.shadowRadius = 2
        container.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.7),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }

   
    func configure(with entry: JournalEntryInfo) {

        diaryText.text = entry.coffeeJournalText
        self.entryId = entry.journalEntryId

        if let date = convertDateString(entry.journalEntryDate) {
            dayLabel.text = date
        } else {
            dayLabel.text = "N/A"
        }

        coffeeTagView.iconImageView.image = UIImage(named: entry.coffeeMomentType)
        coffeeTagView2.iconImageView.image = UIImage(named: entry.coffeeType)

        loadImage(from: entry.coffeeMoodType)

      
        updateStickerAndPhotoVisibility(stickers: entry.coffeeMomentStickerList, photos: entry.coffeeMomentPhotoList)

       
        updateStickers(with: entry.coffeeMomentStickerList)

        updatePhotos(with: entry.coffeeMomentPhotoList)

        adjustTextVisibility(for: entry.coffeeJournalText)
    }

  
    private func updateStickerAndPhotoVisibility(stickers: [DocumentInfo], photos: [DocumentInfo]) {
        let hasStickers = !stickers.isEmpty
        let hasPhotos = !photos.isEmpty

        sticker1Container.isHidden = !hasStickers
        sticker2Container.isHidden = stickers.count < 2
        sticker3Container.isHidden = stickers.count < 3

        image1Container.isHidden = !hasPhotos
        image2Container.isHidden = photos.count < 2
        image3Container.isHidden = photos.count < 3

        imageContainerView.isHidden = !hasPhotos

        if !hasStickers && !hasPhotos {
            NSLayoutConstraint.deactivate([
                diaryText.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 10)
            ])

            NSLayoutConstraint.activate([
                diaryText.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -5)
            ])
        }
    }

    private func updateStickers(with stickers: [DocumentInfo]) {
        if stickers.count > 0, let sticker1Data = Data(base64Encoded: stickers[0].base64Data ?? "") {
            sticker1.image = UIImage(data: sticker1Data)
        } else {
            sticker1.image = nil
        }

        if stickers.count > 1, let sticker2Data = Data(base64Encoded: stickers[1].base64Data ?? "") {
            sticker2.image = UIImage(data: sticker2Data)
        } else {
            sticker2.image = nil
        }

        if stickers.count > 2, let sticker3Data = Data(base64Encoded: stickers[2].base64Data ?? "") {
            sticker3.image = UIImage(data: sticker3Data)
        } else {
            sticker3.image = nil
        }
    }

    private func updatePhotos(with photos: [DocumentInfo]) {
        if photos.count > 0, let photo1Data = Data(base64Encoded: photos[0].base64Data ?? "") {
            image1.image = UIImage(data: photo1Data)
        } else {
            image1.image = nil
        }

        if photos.count > 1, let photo2Data = Data(base64Encoded: photos[1].base64Data ?? "") {
            image2.image = UIImage(data: photo2Data)
        } else {
            image2.image = nil
        }

        if photos.count > 2, let photo3Data = Data(base64Encoded: photos[2].base64Data ?? "") {
            image3.image = UIImage(data: photo3Data)
        } else {
            image3.image = nil
        }
    }

    private func adjustTextVisibility(for text: String) {
          
           let textViewSize = diaryText.sizeThatFits(CGSize(width: contentView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
           let textIsEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

           diaryText.isHidden = textIsEmpty
           diaryText.text = textIsEmpty ? "No text available" : text
           diaryTextHeightConstraint.constant = textIsEmpty ? 0 : textViewSize.height
       }

      private func convertDateString(_ dateString: String) -> String? {
          let inputFormatter = DateFormatter()
          inputFormatter.dateFormat = "yyyy-MM-dd"
          
          guard let date = inputFormatter.date(from: dateString) else { return nil }
          
          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = "d MMM"
          
          return outputFormatter.string(from: date)
      }
   
    @objc private func trashButtonTapped() {
        guard let entryId = entryId else { return }

       
        delegate?.deleteEntry(with: entryId)
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "defaultImage")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
           
            if let error = error {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "defaultImage")
                }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "defaultImage")
                }
                return
            }

            DispatchQueue.main.async {
                if urlString.contains("ClassicSet") {
                    let resizedImage = image.resized(to: CGSize(width: 32, height: 32))
                    self.imageView.image = resizedImage

                    self.imageView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.deactivate(self.imageView.constraints)

                    NSLayoutConstraint.activate([
                        self.imageView.widthAnchor.constraint(equalToConstant: 32),
                        self.imageView.heightAnchor.constraint(equalToConstant: 32)
                    ])
                } else {
                    self.imageView.image = image
                    NSLayoutConstraint.deactivate(self.imageView.constraints)
                    
                    NSLayoutConstraint.activate([
                        self.imageView.widthAnchor.constraint(equalToConstant: 50),
                        self.imageView.heightAnchor.constraint(equalToConstant: 50)
                    ])
                }
            }
        }.resume()
    }




}
