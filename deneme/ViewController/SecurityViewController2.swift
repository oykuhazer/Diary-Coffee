//
//  SecurityViewController2.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 6.10.2024.
//

import UIKit

class SecurityViewController2: UIViewController {

    private let containerView = UIView() // Tüm öğeleri içeren ana view
    private let titleLabel = UILabel()
    private let patternContainerView = UIView() // Desen noktalarının içinde olacağı ana container
    private let setPatternButton = UIButton()
    private var selectedDots: [UIView] = [] // Seçilen noktalar
    private var linePath = UIBezierPath() // Çizilen yol
    private let pathLayer = CAShapeLayer() // Noktalar arası çizgi
    private let outlineLayer = CAShapeLayer() // Çizgilerin dış kenarlığı
    private var currentTouchLocation: CGPoint? // Parmağın bulunduğu yer

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground() // Gradient arka plan
        setupUI()
    }

    // Arka plan için gradient fonksiyonu
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 240/255, green: 224/255, blue: 208/255, alpha: 1.0).cgColor,  // Üst: Açık kahve
            UIColor(red: 176/255, green: 132/255, blue: 100/255, alpha: 1.0).cgColor  // Alt: Koyu kahve
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        setupContainerView() // Tüm öğelerin yer alacağı ana container
        setupTitleLabel()
        setupPatternContainerView() // Desen noktaları için ana container
        setupSetPatternButton()
        setupLineLayer() // Çizgileri oluşturma
        setupConstraints()
    }

    private func setupContainerView() {
        containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.85)
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    }

    private func setupTitleLabel() {
        titleLabel.text = "Desen ile Kilit"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 101/255, green: 67/255, blue: 33/255, alpha: 1.0) // Koyu kahve tonları
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
    }

    private func setupPatternContainerView() {
        patternContainerView.backgroundColor = UIColor(red: 230/255, green: 210/255, blue: 190/255, alpha: 1.0) // Yumuşak kahve tonları
        patternContainerView.layer.cornerRadius = 30
        patternContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(patternContainerView)

        for i in 0..<9 {
            let dotView = createDotView()
            dotView.tag = i
            patternContainerView.addSubview(dotView)
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        patternContainerView.addGestureRecognizer(panGesture)
    }

    // Daireler: Canlı, dikkat çekici kahve tonları, hafif ışıltı ve degrade efekti ile
    private func createDotView() -> UIView {
        let dotView = UIView()
        dotView.backgroundColor = UIColor(red: 175/255, green: 140/255, blue: 110/255, alpha: 1.0) // Daha koyu kahve tonu
        dotView.layer.cornerRadius = 25
        dotView.layer.shadowColor = UIColor(red: 210/255, green: 150/255, blue: 120/255, alpha: 1.0).cgColor // Hafif degrade ışıltı
        dotView.layer.shadowRadius = 10
        dotView.layer.shadowOpacity = 0.8
        dotView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dotView.translatesAutoresizingMaskIntoConstraints = false
        return dotView
    }

    private func setupSetPatternButton() {
        setPatternButton.setTitle("Deseni Ayarla", for: .normal)
        setPatternButton.backgroundColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0) // Aynı ton
        setPatternButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        setPatternButton.setTitleColor(.white, for: .normal) // Yazı rengi beyaz
        setPatternButton.layer.cornerRadius = 30
        setPatternButton.layer.shadowColor = UIColor.black.cgColor
        setPatternButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        setPatternButton.layer.shadowOpacity = 0.4
        setPatternButton.layer.shadowRadius = 5
        setPatternButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(setPatternButton)
    }

    private func setupLineLayer() {
        // Çizgilerin iç kısmı
        pathLayer.strokeColor = UIColor(red: 120/255, green: 85/255, blue: 62/255, alpha: 1.0).cgColor // Belirtilen kahve tonunda çizgi
        pathLayer.lineWidth = 7 // Çizgi hafif kalın
        pathLayer.lineCap = .round  // Çizgi başlangıç ve bitişi yuvarlatıldı
        pathLayer.lineJoin = .round  // Tüm köşelere yuvarlatma (radius) uygulandı
        pathLayer.fillColor = UIColor.clear.cgColor

        // Çizgilerin dış kenarlığı (daha açık renkte)
        outlineLayer.strokeColor = UIColor(red: 200/255, green: 170/255, blue: 140/255, alpha: 1.0).cgColor // Daha açık kahverengi kenarlık
        outlineLayer.lineWidth = 10 // Kenarlık daha geniş
        outlineLayer.lineCap = .round
        outlineLayer.lineJoin = .round
        outlineLayer.fillColor = UIColor.clear.cgColor

        // Gölgeler
        pathLayer.shadowColor = UIColor(red: 180/255, green: 140/255, blue: 100/255, alpha: 1.0).cgColor // Hafif açık gölge rengi
        pathLayer.shadowOpacity = 0.8
        pathLayer.shadowRadius = 10
        pathLayer.shadowOffset = CGSize(width: 0, height: 0)

        patternContainerView.layer.addSublayer(outlineLayer) // Dış kenarlık önce eklenir
        patternContainerView.layer.addSublayer(pathLayer) // İç çizgi üzerine eklenir
    }


    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: patternContainerView)
        currentTouchLocation = location

        for dotView in patternContainerView.subviews where dotView.frame.contains(location) && !selectedDots.contains(dotView) {
            selectedDots.append(dotView)
            animateDotSelection(dotView)

            if selectedDots.count == 1 {
                linePath.move(to: dotView.center)
            } else {
                linePath.addLine(to: dotView.center)
            }
        }

        if gesture.state == .changed {
            linePath.removeAllPoints()
            for (index, dotView) in selectedDots.enumerated() {
                if index == 0 {
                    linePath.move(to: dotView.center)
                } else {
                    linePath.addLine(to: dotView.center)
                }
            }

            if let touchLocation = currentTouchLocation {
                linePath.addLine(to: touchLocation)
            }
            pathLayer.path = linePath.cgPath
            outlineLayer.path = linePath.cgPath // Kenarlık ve çizgi aynı yolu takip eder
        } else if gesture.state == .ended {
            processPattern()
        }
    }

    private func animateDotSelection(_ dotView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            dotView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Seçildiğinde hafif büyüme
            dotView.layer.shadowRadius = 20 // Işıltı genişler
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                dotView.transform = .identity
                dotView.layer.shadowRadius = 15
            }
        }
    }

    private func processPattern() {
        let patternSequence = selectedDots.map { $0.tag }
        print("Seçilen desen sırası: \(patternSequence)")

        selectedDots.removeAll()
        linePath.removeAllPoints()
        pathLayer.path = nil
        outlineLayer.path = nil
    }

    @objc private func setPatternButtonTapped() {
        print("Desen başarıyla ayarlandı.")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 350),
            containerView.heightAnchor.constraint(equalToConstant: 550),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40), // Üst kenar ile aynı mesafe
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            patternContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40), // Eşit mesafeli boşluk
            patternContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            patternContainerView.widthAnchor.constraint(equalToConstant: 300),
            patternContainerView.heightAnchor.constraint(equalToConstant: 300),

            setPatternButton.topAnchor.constraint(equalTo: patternContainerView.bottomAnchor, constant: 40), // Eşit mesafeli boşluk
            setPatternButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            setPatternButton.widthAnchor.constraint(equalToConstant: 200),
            setPatternButton.heightAnchor.constraint(equalToConstant: 60),
            setPatternButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40) // Alt kenar ile aynı mesafe
        ])
        
        // Dairelerin tam ortalanması için düzenleme yapıldı
        for (index, dotView) in patternContainerView.subviews.enumerated() {
            let row = index / 3
            let col = index % 3

            NSLayoutConstraint.activate([
                dotView.widthAnchor.constraint(equalToConstant: 50), // Zarif boyutlar
                dotView.heightAnchor.constraint(equalToConstant: 50),
                dotView.centerXAnchor.constraint(equalTo: patternContainerView.leadingAnchor, constant: CGFloat(col) * 100 + 50),
                dotView.centerYAnchor.constraint(equalTo: patternContainerView.topAnchor, constant: CGFloat(row) * 100 + 50)
            ])
        }
    }
}
