//
//  ChangeProfilePhotoView.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 6.01.2025.
//

import UIKit

class ChangeProfilePhotoView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

   private let containerView: UIView = {
       let view = UIView()
       view.backgroundColor = AppColors.color26
       view.layer.cornerRadius = 16
       view.layer.masksToBounds = true
       return view
   }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

   private let applyButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle(NSLocalizedString("apply", comment: ""), for: .normal)
       button.backgroundColor = AppColors.color2
       button.setTitleColor(AppColors.color3, for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
       button.layer.cornerRadius = 10
       button.translatesAutoresizingMaskIntoConstraints = false
       return button
   }()

   private var imageUrls: [String] = []
   private var selectedIndexPath: IndexPath?
   var onComplete: ((String?) -> Void)?

   override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
       applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupView()
       applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
   }

   private func setupView() {
       backgroundColor = AppColors.color46

       addSubview(containerView)
       containerView.addSubview(collectionView)
       containerView.addSubview(applyButton)

       containerView.translatesAutoresizingMaskIntoConstraints = false

       let screenWidth = UIScreen.main.bounds.width
       let containerHeight: CGFloat = screenWidth == 375 ? 280 : 300
       
       NSLayoutConstraint.activate([
           containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
           containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
           containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
           containerView.heightAnchor.constraint(equalToConstant: containerHeight),

           collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
           collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
           collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
           collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -20),

           applyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
           applyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
           applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
           applyButton.heightAnchor.constraint(equalToConstant: 44)
       ])

       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
       tapGesture.cancelsTouchesInView = false
       addGestureRecognizer(tapGesture)
   }

   @objc private func applyButtonTapped() {
       guard let indexPath = selectedIndexPath, indexPath.item < imageUrls.count else {
           dismiss()
           return
       }

       let selectedImageUrl = imageUrls[indexPath.item]

       UserProfile.shared.profilePicture = selectedImageUrl
       SaveUserProfileRequest.shared.saveUserProfile(in: self) { result in
           switch result {
           case .success:
               NotificationCenter.default.post(
                   name: .profilePictureChanged,
                   object: nil,
                   userInfo: ["url": selectedImageUrl]
               )
           case .failure(let error):
              print("")
           }
       }

       dismiss()
   }

   @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
       let location = gesture.location(in: self)
       if !containerView.frame.contains(location) {
           dismiss()
       }
   }

   func dismiss() {
       UIView.animate(withDuration: 0.3, animations: {
           self.alpha = 0
       }) { _ in
           self.removeFromSuperview()
       }
   }

   func show(in parentView: UIView) {
       parentView.addSubview(self)
       translatesAutoresizingMaskIntoConstraints = false

       NSLayoutConstraint.activate([
           topAnchor.constraint(equalTo: parentView.topAnchor),
           bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
           leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
           trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
       ])

       alpha = 0
       UIView.animate(withDuration: 0.3) {
           self.alpha = 1
       }
   }

    func updateImages(with urls: [String]) {
            let referenceOrder = ["kissing", "smile", "wow", "sleep", "angry", "sad"]
            self.imageUrls = urls.sorted { url1, url2 in
                let key1 = referenceOrder.firstIndex { key in url1.contains(key) } ?? Int.max
                let key2 = referenceOrder.firstIndex { key in url2.contains(key) } ?? Int.max
                return key1 < key2
            }
            collectionView.reloadData()
        }
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imageUrls.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
       cell.contentView.subviews.forEach { $0.removeFromSuperview() }

       let imageView = UIImageView()
       imageView.contentMode = .scaleToFill
       imageView.clipsToBounds = true
       imageView.layer.cornerRadius = 10
       imageView.translatesAutoresizingMaskIntoConstraints = false

       if let url = URL(string: imageUrls[indexPath.item]) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image

                    
                        if self.imageUrls[indexPath.item].contains("ClassicSet") {
                            imageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        }
                    }
                }
            }.resume()
        }

       cell.contentView.addSubview(imageView)
       NSLayoutConstraint.activate([
           imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
           imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
           imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
           imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
       ])

       cell.contentView.layer.borderWidth = (selectedIndexPath == indexPath) ? 3 : 0
       cell.contentView.layer.borderColor = (selectedIndexPath == indexPath)
       ? AppColors.color2.cgColor
       : AppColors.color79.cgColor

       cell.contentView.layer.cornerRadius = cell.bounds.width / 2

       return cell
   }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
           if let previousIndexPath = selectedIndexPath {
               selectedIndexPath = nil
               collectionView.reloadItems(at: [previousIndexPath])
           }

        
           selectedIndexPath = indexPath
           collectionView.reloadItems(at: [indexPath])
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 20
        let totalPadding: CGFloat = 40
        let availableWidth = collectionView.bounds.width - totalSpacing - totalPadding
        let itemWidth = availableWidth / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
}

extension Notification.Name {
   static let profilePictureChanged = Notification.Name("profilePictureChanged")
}
