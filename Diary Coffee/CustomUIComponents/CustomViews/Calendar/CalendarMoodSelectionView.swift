//
//  CalendarMoodSelectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 3.11.2024.
//

import UIKit

class CalendarMoodSelectionView: UIView {

    private var emojiImageURLs: [String] = []
    private var selectedImageIndex: Int? = nil
    private var transitionTimer: Timer?
    weak var overlayView: UIView?
    
    private var isClassicSet: Bool = false

    init(frame: CGRect, emojiImageURLs: [String], isClassicSet: Bool = false) {
        super.init(frame: frame)
        self.emojiImageURLs = reorderImageURLs(emojiImageURLs)
        self.isClassicSet = isClassicSet
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func reorderImageURLs(_ urls: [String]) -> [String] {
        let desiredOrder = ["smile", "kissing", "wow", "sleep", "angry", "sad"]
        return desiredOrder.compactMap { mood in
            urls.first { $0.contains(mood) }
        }
    }

    private func setupView() {
        self.backgroundColor = AppColors.color20
        self.layer.cornerRadius = 15

        let label = UILabel()
        label.text = NSLocalizedString("how_was_your_day", comment: "")
        label.textColor = AppColors.color2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        let emojiStack = UIStackView()
        emojiStack.axis = .horizontal
        emojiStack.alignment = .center
        emojiStack.distribution = .fillEqually
        emojiStack.spacing = 10
        emojiStack.translatesAutoresizingMaskIntoConstraints = false

        let emojiSize: CGFloat = isClassicSet ? 40 : 70

        for (index, imageURL) in emojiImageURLs.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emojiTapped(_:))))
            
            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: emojiSize),
                imageView.heightAnchor.constraint(equalToConstant: emojiSize)
            ])

            if let url = URL(string: imageURL) {
                downloadImage(from: url) { image in
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }

            emojiStack.addArrangedSubview(imageView)
        }

        self.addSubview(emojiStack)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            emojiStack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: isClassicSet ? 5 : 0),
            emojiStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            emojiStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            emojiStack.heightAnchor.constraint(equalToConstant: isClassicSet ? 80 : 100)
        ])
    }

    @objc private func emojiTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }

        UIView.animate(withDuration: 0.1, animations: {
            tappedImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                tappedImageView.transform = .identity
            }
        }

        selectedImageIndex = tappedImageView.tag
        transitionTimer?.invalidate()
        transitionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(transitionToDiaryEntryVC), userInfo: nil, repeats: false)
    }

    @objc private func transitionToDiaryEntryVC() {
        guard let selectedImageIndex = selectedImageIndex,
              let parentViewController = self.parentViewController as? CustomTabBarController else { return }

        parentViewController.removeOverlayAndMoodSelection()

        let diaryEntryVC = DiaryEntryVC()
        diaryEntryVC.selectedMoodIndex = selectedImageIndex
        diaryEntryVC.modalPresentationStyle = .fullScreen
        parentViewController.present(diaryEntryVC, animated: true, completion: nil)
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
