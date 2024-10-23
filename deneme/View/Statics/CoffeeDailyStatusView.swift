//
//  CoffeeStatsView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 15.10.2024.
//

import UIKit

class CoffeeDailyStatusView: UIView {
    
    let titleLabel = UILabel()
    let stackView = UIStackView()
    let dateLabel = UILabel()
    let lineView = UIView()
    let awardImageView = UIImageView() // Ödül resmi için UIImageView
    let awardContainerView = UIView() // Ödül resmi için dairesel container view
    var currentDate = Date() // Geçerli tarihi tutar
    let streakLabel = UILabel()
    let streakLabelStackView = UIStackView() // Burada tanımlandı
    
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
        self.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.89, alpha: 1.0) // Yumuşak bej arka plan
        self.layer.cornerRadius = 16

        // Başlık
        titleLabel.text = "Günlük Serisi"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        self.addSubview(titleLabel)

        // Sol buton (Geri)
        let leftButton = UIButton()
        leftButton.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        leftButton.tintColor = UIColor(red: 0.55, green: 0.4, blue: 0.25, alpha: 1.0)
        leftButton.addTarget(self, action: #selector(previousDay), for: .touchUpInside)
        self.addSubview(leftButton)

        // Sağ buton (İleri)
        let rightButton = UIButton()
        rightButton.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        rightButton.tintColor = UIColor(red: 0.55, green: 0.4, blue: 0.25, alpha: 1.0)
        rightButton.addTarget(self, action: #selector(nextDay), for: .touchUpInside)
        self.addSubview(rightButton)

        // Sağ üst köşede tarih
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        dateLabel.textColor = UIColor(red: 0.35, green: 0.25, blue: 0.2, alpha: 1.0) // Tarih için kahve tonu
        updateDateLabel(dateLabel) // Tarihi güncelleme fonksiyonu çağrılıyor
        self.addSubview(dateLabel)

        // Kalın çubuk view
        let thickBarView = UIView()
        thickBarView.backgroundColor = UIColor(red: 0.9, green: 0.85, blue: 0.8, alpha: 1.0)
        thickBarView.layer.cornerRadius = 20 // Yuvarlatılmış köşeler
        thickBarView.clipsToBounds = true
        self.addSubview(thickBarView)

        // StackView ile günleri ve resimleri çubuğun üstüne koyacağız
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        thickBarView.addSubview(stackView)

        let days = ["P", "S", "Ç", "P", "C", "C", "P"]
        let statusImages = ["coffeedailystatusactive", "coffeedailystatusactive", "coffeedailystatusactive", "coffeedailystatusactive", "coffeedailystatuspassive", "coffeedailystatuspassive", "coffeedailystatuspassive"]

        for (index, day) in days.enumerated() {
            let verticalStack = UIStackView()
            verticalStack.axis = .vertical
            verticalStack.alignment = .center
            verticalStack.spacing = 5
            stackView.addArrangedSubview(verticalStack)

            // Gün isimlerinin altına resim yerleştirme
            let imageView = UIImageView()
            imageView.image = UIImage(named: statusImages[index])
            imageView.contentMode = .scaleAspectFill // İçeriğin dolmasını sağlamak için
            imageView.layer.cornerRadius = 20 // Resimleri biraz daha büyüttük
            imageView.clipsToBounds = true
            verticalStack.addArrangedSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50)
            ])
           
            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.font = UIFont(name: "Avenir Next", size: 14)
            dayLabel.textAlignment = .center
            dayLabel.textColor = UIColor(red: 0.35, green: 0.2, blue: 0.1, alpha: 1.0) // Kahve tonunda bir renk
            verticalStack.addArrangedSubview(dayLabel)
        }

        lineView.backgroundColor = UIColor(red: 0.75, green: 0.6, blue: 0.45, alpha: 1.0)
        lineView.layer.cornerRadius = 1
        self.addSubview(lineView)

        awardContainerView.translatesAutoresizingMaskIntoConstraints = false
        awardContainerView.backgroundColor = UIColor(red: 0.88, green: 0.78, blue: 0.68, alpha: 1.0)
        awardContainerView.layer.cornerRadius = 25
        awardContainerView.clipsToBounds = true
        self.addSubview(awardContainerView)

        awardImageView.image = UIImage(named: "award")
        awardImageView.contentMode = .scaleAspectFit
        awardImageView.translatesAutoresizingMaskIntoConstraints = false
        awardContainerView.addSubview(awardImageView)

      
        streakLabel.text = "En uzun kahve serisi: 5 gün"
        streakLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        streakLabel.textColor = UIColor(red: 0.35, green: 0.2, blue: 0.1, alpha: 1.0) // Kahve tonunda bir renk
        streakLabel.textAlignment = .left
        streakLabelStackView.addArrangedSubview(streakLabel)
        self.addSubview(streakLabelStackView)

        setupConstraints(thickBarView: thickBarView, leftButton: leftButton, rightButton: rightButton)
    }
    
    

    private func setupConstraints(thickBarView: UIView, leftButton: UIButton, rightButton: UIButton) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        thickBarView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        streakLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        awardContainerView.translatesAutoresizingMaskIntoConstraints = false
        awardImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),

           
            leftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor), // Yükseklik olarak hizalama
               leftButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
               leftButton.widthAnchor.constraint(equalToConstant: 40),
               leftButton.heightAnchor.constraint(equalToConstant: 40),

               // Right button'un titleLabel ile hizalanması
               rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor), // Yükseklik olarak hizalama
               rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
               rightButton.widthAnchor.constraint(equalToConstant: 40),
               rightButton.heightAnchor.constraint(equalToConstant: 40),

           
            dateLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -10),

            thickBarView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 20),
            thickBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            thickBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            thickBarView.heightAnchor.constraint(equalToConstant: 80),

          
            stackView.centerXAnchor.constraint(equalTo: thickBarView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: thickBarView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: thickBarView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: thickBarView.trailingAnchor, constant: -20),

      
            lineView.topAnchor.constraint(equalTo: thickBarView.bottomAnchor, constant: 20),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            lineView.heightAnchor.constraint(equalToConstant: 2),

            awardContainerView.widthAnchor.constraint(equalToConstant: 50),
                awardContainerView.heightAnchor.constraint(equalToConstant: 50),
                awardContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                awardContainerView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20),
                
                // Ödül resmini daire container içine ortalama
                awardImageView.centerXAnchor.constraint(equalTo: awardContainerView.centerXAnchor),
                awardImageView.centerYAnchor.constraint(equalTo: awardContainerView.centerYAnchor),
                awardImageView.widthAnchor.constraint(equalToConstant: 30),
                awardImageView.heightAnchor.constraint(equalToConstant: 30),
                
                // Streak label stack view'in awardImageView'in sağında ve yüksekliğinin merkezde olması
                streakLabelStackView.centerYAnchor.constraint(equalTo: awardContainerView.centerYAnchor), // Yükseklik olarak ortalama
                streakLabelStackView.leadingAnchor.constraint(equalTo: awardContainerView.trailingAnchor, constant: 20) // 50 birim sağa
        ])
    }

    @objc private func previousDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
        updateDateLabel(dateLabel)
    }

    @objc private func nextDay() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        updateDateLabel(dateLabel)
    }

   
    private func updateDateLabel(_ label: UILabel) {
        let sixDaysLater = Calendar.current.date(byAdding: .day, value: 6, to: currentDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let todayString = dateFormatter.string(from: currentDate)
        let sixDaysLaterString = dateFormatter.string(from: sixDaysLater!)
        label.text = "\(todayString) - \(sixDaysLaterString)"
    }

}
