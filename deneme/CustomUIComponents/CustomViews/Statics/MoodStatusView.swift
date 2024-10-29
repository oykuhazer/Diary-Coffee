//
//  MoodStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 16.10.2024.
//

import UIKit

class MoodStatusView: UIView {
    
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Arka plan ve köşe ayarları
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0) // Yumuşak bej arka plan
        self.layer.cornerRadius = 16

        // Başlık sola yaslanacak
        titleLabel.text = "Mood İstatistikleri"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        self.addSubview(titleLabel)
        
        // Daire grafiği boyutu biraz küçültüldü, 3D gölge efekti ve dışına belirgin kahve tonlarında efekt eklendi
        let pieChartView = create3DPieChartWithShadowsAndOuterCoffeeEffect()
        self.addSubview(pieChartView)
        
        // Mood resimleri ve label'ları içine alacak View
        let moodDetailsView = UIView()
        moodDetailsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(moodDetailsView)

        // Mood resimlerini ve label'ları yatayda göstermek için bir StackView
        let moodStackView = UIStackView()
        moodStackView.axis = .vertical
        moodStackView.alignment = .leading
        moodStackView.distribution = .equalSpacing
        moodStackView.spacing = 8  // Aralarındaki mesafeyi azalttık
        moodStackView.translatesAutoresizingMaskIntoConstraints = false
        moodDetailsView.addSubview(moodStackView)

        // Mood bilgileri
        let moodImages = ["a", "b", "c", "d", "e", "f"]
        let moodPercentages = ["15%", "25%", "35%", "45%", "55%", "60%"]

        for i in 0..<moodImages.count {
            // Mood resim ve label'ını içeren bir View
            let moodView = UIView()
            moodView.translatesAutoresizingMaskIntoConstraints = false
              
            let imageView = UIImageView(image: UIImage(named: moodImages[i]))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            moodView.addSubview(imageView)
            
            let percentageLabel = UILabel()
            percentageLabel.text = moodPercentages[i]
            percentageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            percentageLabel.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
            percentageLabel.translatesAutoresizingMaskIntoConstraints = false
            moodView.addSubview(percentageLabel)
            
            moodStackView.addArrangedSubview(moodView)
            
            // Constraint'ler (Resim ve Label arasında mesafeyi azaltıyoruz)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50),
                imageView.leadingAnchor.constraint(equalTo: moodView.leadingAnchor,constant: 10),
                imageView.centerYAnchor.constraint(equalTo: moodView.centerYAnchor),
                
                percentageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20), // Label resmin sağında
                percentageLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor), // Label ve resim hizalı
                percentageLabel.trailingAnchor.constraint(equalTo: moodView.trailingAnchor),
                moodView.heightAnchor.constraint(equalToConstant: 30) // Her moodView yüksekliği
            ])
        }
        
        // Constraint'ler
        setupConstraints(pieChartView: pieChartView, moodDetailsView: moodDetailsView, moodStackView: moodStackView)
    }
    
    private func create3DPieChartWithShadowsAndOuterCoffeeEffect() -> UIView {
        let pieChartView = UIView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        
        let radius: CGFloat = 85  // Daire boyutu biraz daha küçültüldü
        let innerRadius: CGFloat = 40  // Ortası açık olacak şekilde iç çap belirledik
        let center = CGPoint(x: radius, y: radius)
        let totalSlices = 6  // 6 dilim
        let anglePerSlice = CGFloat.pi * 2 / CGFloat(totalSlices)
        let coffeeAndGreenColors: [UIColor] = [
            UIColor(red: 0.65, green: 0.5, blue: 0.35, alpha: 1.0),  // Orta kahverengi
            UIColor(red: 0.5, green: 0.65, blue: 0.45, alpha: 1.0),  // Yeşil kahve
            UIColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1.0),    // Koyu kahve
            UIColor(red: 0.35, green: 0.55, blue: 0.35, alpha: 1.0), // Pastel yeşil
            UIColor(red: 0.9, green: 0.75, blue: 0.55, alpha: 1.0),  // Tarçın rengi
            UIColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 1.0)     // Koyu tarçın
        ]
        
        for i in 0..<totalSlices {
            let startAngle = CGFloat(i) * anglePerSlice - CGFloat.pi / 2
            let endAngle = startAngle + anglePerSlice
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()

            let sliceLayer = CAShapeLayer()
            sliceLayer.path = path.cgPath
            sliceLayer.fillColor = coffeeAndGreenColors[i].cgColor
            
            // 3D gölge efekti
            sliceLayer.shadowColor = UIColor.black.cgColor
            sliceLayer.shadowOpacity = 0.3
            sliceLayer.shadowOffset = CGSize(width: 3, height: 3)
            sliceLayer.shadowRadius = 4

            pieChartView.layer.addSublayer(sliceLayer)
        }
        
        let outerLayer = CAShapeLayer()
        let outerPath = UIBezierPath(arcCenter: center, radius: radius + 15, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        outerLayer.path = outerPath.cgPath
        outerLayer.fillColor = UIColor(red: 0.75, green: 0.65, blue: 0.55, alpha: 0.3).cgColor  // Dış kahve tonları efekti
        pieChartView.layer.insertSublayer(outerLayer, at: 0)
        
        return pieChartView
    }

    private func setupConstraints(pieChartView: UIView, moodDetailsView: UIView, moodStackView: UIStackView) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            pieChartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            pieChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            pieChartView.widthAnchor.constraint(equalToConstant: 170),
            pieChartView.heightAnchor.constraint(equalToConstant: 170),
            
            moodDetailsView.leadingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 40), // Resim ve label'ları pieChart yanında konumlandırıyoruz
            moodDetailsView.centerYAnchor.constraint(equalTo: pieChartView.centerYAnchor),
            moodDetailsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            moodStackView.topAnchor.constraint(equalTo: moodDetailsView.topAnchor),
            moodStackView.leadingAnchor.constraint(equalTo: moodDetailsView.leadingAnchor),
            moodStackView.trailingAnchor.constraint(equalTo: moodDetailsView.trailingAnchor),
            moodStackView.bottomAnchor.constraint(equalTo: moodDetailsView.bottomAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
