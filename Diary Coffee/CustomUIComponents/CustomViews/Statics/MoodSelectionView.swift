//
//  MoodSelectionView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 18.10.2024.
//

import UIKit

protocol MoodSelectionViewDelegate: AnyObject {
    func moodSelectionView(_ view: MoodSelectionView, didSelectMoodType moodType: String)
}

class MoodSelectionView: UIView {

    weak var delegate: MoodSelectionViewDelegate?
    
    private let coffeeToneView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color20
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let buttons: [UIButton] = {
        let imageNames = ["a", "b", "c", "d", "e", "f"]
        return imageNames.map {
            let button = UIButton()
            button.setImage(UIImage(named: $0), for: .normal)
            button.backgroundColor = AppColors.color10
            button.layer.cornerRadius = 45
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowRadius = 6
            button.layer.masksToBounds = false
            button.translatesAutoresizingMaskIntoConstraints = false
            button.accessibilityIdentifier = $0
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if let moodTypeURL = sender.accessibilityIdentifier {
            delegate?.moodSelectionView(self, didSelectMoodType: moodTypeURL)
        }
    }


    private func setupView() {
        backgroundColor = AppColors.color68
          addSubview(coffeeToneView)
        
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
          addGestureRecognizer(tapGesture)

        let screenWidth = UIScreen.main.bounds.width
            let widthMultiplier: CGFloat = screenWidth <= 375 ? 0.95 : 0.9

            NSLayoutConstraint.activate([
                coffeeToneView.centerXAnchor.constraint(equalTo: centerXAnchor),
                coffeeToneView.centerYAnchor.constraint(equalTo: centerYAnchor),
                coffeeToneView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier),
                coffeeToneView.heightAnchor.constraint(equalToConstant: 280)
            ])

          for (index, button) in buttons.enumerated() {
              coffeeToneView.addSubview(button)

              let row = index / 3
              let column = index % 3

              NSLayoutConstraint.activate([
                  button.centerXAnchor.constraint(equalTo: coffeeToneView.centerXAnchor, constant: CGFloat((column - 1) * 120)),
                  button.centerYAnchor.constraint(equalTo: coffeeToneView.centerYAnchor, constant: CGFloat((row - 1) * 120) + 60),
                  button.widthAnchor.constraint(equalToConstant: 90),
                  button.heightAnchor.constraint(equalToConstant: 90)
              ])
          }
      }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
          
            let tapLocation = sender.location(in: self)
            if !coffeeToneView.frame.contains(tapLocation) {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 0
                }
            }
        }
    
    func updateMoodButtons(with imageUrls: [String]) {
        let moodKeywords = ["kissing", "smile", "wow", "sleep", "angry", "sad"]

        let sortedUrls = moodKeywords.compactMap { keyword in
            imageUrls.first { $0.contains(keyword) }
        }

        buttons.forEach { $0.removeFromSuperview() }

        let newButtons = sortedUrls.map { url -> UIButton in
            let button = UIButton()
            button.backgroundColor = AppColors.color10
            button.layer.cornerRadius = 45
           /* button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowRadius = 6 */
            button.layer.masksToBounds = false
            button.translatesAutoresizingMaskIntoConstraints = false
            button.accessibilityIdentifier = url
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false

            if let imageUrl = URL(string: url) {
                URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                    guard error == nil, let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        imageView.image = image

                        if url.contains("ClassicSet") {
                            NSLayoutConstraint.activate([
                                imageView.widthAnchor.constraint(equalToConstant: 50),
                                imageView.heightAnchor.constraint(equalToConstant: 50)
                            ])
                        } else {
                            NSLayoutConstraint.activate([
                                imageView.widthAnchor.constraint(equalToConstant: 80),
                                imageView.heightAnchor.constraint(equalToConstant: 80)
                            ])
                        }

                        button.addSubview(imageView)
                        NSLayoutConstraint.activate([
                            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                        ])
                    }
                }.resume()
            }

            return button
        }

        for (index, button) in newButtons.enumerated() {
            coffeeToneView.addSubview(button)

            let row = index / 3
            let column = index % 3

            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: coffeeToneView.centerXAnchor, constant: CGFloat((column - 1) * 120)),
                button.centerYAnchor.constraint(equalTo: coffeeToneView.centerYAnchor, constant: CGFloat((row - 1) * 120) + 60),
                button.widthAnchor.constraint(equalToConstant: 90),
                button.heightAnchor.constraint(equalToConstant: 90)
            ])
        }

        
        if let kissingMood = sortedUrls.first(where: { $0.contains("smile") }) {
            delegate?.moodSelectionView(self, didSelectMoodType: kissingMood)
        }
    }


}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: width, height: newHeight)

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
