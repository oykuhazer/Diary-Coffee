//
//  CoffeeDiaryEntryViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.10.2024.
//

import UIKit


struct PhotoMetadata {
    var image: UIImage
    var fileName: String
   
}


class DiaryEntryVC: UIViewController, UITextViewDelegate, PhotoManagerDelegate {

    let months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    var selectedOption: String?
    var alertView: UIView?
    var dimmedBackground: UIView?
    var moodCollectionView: UICollectionView?
    var selectedMoodImage: UIImage?
    var photoManager: PhotoManager?
    var selectedDate: String?
    let maxCharacterCount = 100
    var photoMetadataList: [PhotoMetadata] = []

  

    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pastelLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        // Üç farklı katman olacak
        let line1 = UIView()
        line1.backgroundColor = UIColor(red: 0.95, green: 0.85, blue: 0.75, alpha: 1.0)
        line1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line1)

        let line2 = UIView()
        line2.backgroundColor = UIColor(red: 0.85, green: 0.75, blue: 0.65, alpha: 1.0)
        line2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line2)

        let line3 = UIView()
        line3.backgroundColor = UIColor(red: 0.75, green: 0.65, blue: 0.55, alpha: 1.0)
        line3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line3)

        // Constraint'ler ile katmanları hizalıyoruz
        NSLayoutConstraint.activate([
            line1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line1.topAnchor.constraint(equalTo: view.topAnchor),
            line1.heightAnchor.constraint(equalToConstant: 6),

            line2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line2.topAnchor.constraint(equalTo: line1.bottomAnchor, constant: 2),
            line2.heightAnchor.constraint(equalToConstant: 4),

            line3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line3.topAnchor.constraint(equalTo: line2.bottomAnchor, constant: 2),
            line3.heightAnchor.constraint(equalToConstant: 2),
            line3.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }()

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let monthYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Ekim, 2024"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let weekdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Cuma"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let monthYearStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let selectMomentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kahve Anını Seç", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        // Gradient arka plan
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.5, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
                                UIColor(red: 0.7, green: 0.4, blue: 0.4, alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 25
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true

        // Gölge efekti
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4

        // Yazının tam ortada olmasını sağlayalım
        button.titleLabel?.textAlignment = .center
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let selectCoffeeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kahveni Seç", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        // Gradient arka plan
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0).cgColor,
                                UIColor(red: 0.6, green: 0.3, blue: 0.3, alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 25
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)

        button.layer.insertSublayer(gradientLayer, at: 0)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true

        // Gölge efekti
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4

        // Yazının tam ortada olmasını sağlayalım
        button.titleLabel?.textAlignment = .center
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        
        // Buton başlığı ve yazı stili
        button.setTitle("Kaydet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Gradient arka plan (sayfanın pastel tonlarına uygun)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0).cgColor,  // Açık pastel kahve tonları
            UIColor(red: 0.75, green: 0.6, blue: 0.5, alpha: 1.0).cgColor  // Koyu pastel kahve tonları
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 25
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 140, height: 50)
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // Gölge efekti
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4

        // Yuvarlatılmış köşeler
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    let faceButton: UIButton = {
        let button = UIButton(type: .system)

        // Asset dosyasındaki 'emotion' resmini ekleyelim ve orijinal rengini koruyalım
        let emotionImage = UIImage(named: "emotional")?.withRenderingMode(.alwaysOriginal)
        button.setImage(emotionImage, for: .normal)

        // Görseli ortalamak için
        button.imageView?.contentMode = .scaleAspectFit

        // Tint rengini kaldırdık, böylece resmin orijinal rengi korunur
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textView.textColor = UIColor(red: 0.35, green: 0.25, blue: 0.25, alpha: 1.0)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.85, green: 0.75, blue: 0.7, alpha: 1.0).cgColor
        textView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.1
        textView.layer.shadowOffset = CGSize(width: 0, height: 2)
        textView.layer.shadowRadius = 4
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .justified
        return textView
    }()

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Kahve anınızı paylaşmaya başlayın"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor(red: 0.7, green: 0.55, blue: 0.5, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let characterCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.6, green: 0.4, blue: 0.4, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let imageContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    func createImageView(size: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Dış çerçeve: İnce, dairesel ve minimal
        let outerCircleView = UIView()
        outerCircleView.translatesAutoresizingMaskIntoConstraints = false
        outerCircleView.layer.cornerRadius = size / 2
        outerCircleView.layer.borderWidth = 3
        outerCircleView.layer.borderColor = UIColor(red: 0.5, green: 0.35, blue: 0.25, alpha: 1.0).cgColor
        outerCircleView.layer.masksToBounds = true
        containerView.addSubview(outerCircleView)

        // İkonu ortaya yerleştiriyoruz
        let iconImageView = UIImageView(image: UIImage(systemName: "camera.shutter.button"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.35, green: 0.2, blue: 0.15, alpha: 1.0) // Kahve tonları
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)

        // Arka plana hafif bir gölge efekti
        outerCircleView.layer.shadowColor = UIColor.black.cgColor
        outerCircleView.layer.shadowOpacity = 0.2
        outerCircleView.layer.shadowOffset = CGSize(width: 0, height: 6)
        outerCircleView.layer.shadowRadius = 8

        // Gradient arka plan efekti (daha sade, daire içine)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.0).cgColor,  // Açık pastel ton
            UIColor(red: 0.75, green: 0.6, blue: 0.5, alpha: 1.0).cgColor   // Daha koyu kahve tonları
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = size / 2
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        outerCircleView.layer.insertSublayer(gradientLayer, at: 0)

        // Outer ve inner daire constraint'leri
        NSLayoutConstraint.activate([
            outerCircleView.widthAnchor.constraint(equalToConstant: size),
            outerCircleView.heightAnchor.constraint(equalToConstant: size),
            outerCircleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            outerCircleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // İkon constraint'leri (ortada)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: size * 0.5),
            iconImageView.heightAnchor.constraint(equalToConstant: size * 0.5)
        ])

        // Container boyut constraint'leri
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: size),
            containerView.heightAnchor.constraint(equalToConstant: size)
        ])

        return containerView
    }




    let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // Transparan bir arka plan
        
        // Arka plana şık bir gradient ekleyelim
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.0).cgColor, // Açık pastel ton
            UIColor(red: 0.85, green: 0.7, blue: 0.65, alpha: 1.0).cgColor  // Biraz daha koyu pastel ton
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 20
        gradientLayer.masksToBounds = true
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 110)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // View'e gölge efekti ekleyelim
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let customContainerView: UIView = {
          let view = UIView()
          view.layer.cornerRadius = 15
          view.layer.masksToBounds = true
          view.translatesAutoresizingMaskIntoConstraints = false

          // Gradient arka plan ekleyelim
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = [
              UIColor(red: 0.95, green: 0.85, blue: 0.75, alpha: 1.0).cgColor, // Açık pastel ton
              UIColor(red: 0.85, green: 0.75, blue: 0.65, alpha: 1.0).cgColor  // Koyu pastel ton
          ]
          gradientLayer.startPoint = CGPoint(x: 0, y: 0)
          gradientLayer.endPoint = CGPoint(x: 1, y: 1)
          gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 400)
          view.layer.insertSublayer(gradientLayer, at: 0)

          return view
      }()


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.0)
        photoManager = PhotoManager()
        photoManager?.delegate = self

        setupUI()
        addTapGesturesToImageViews()

        textView.delegate = self
        selectMomentButton.addTarget(self, action: #selector(showCoffeePicker), for: .touchUpInside)
        selectCoffeeButton.addTarget(self, action: #selector(showCoffeeTypePicker), for: .touchUpInside)
        faceButton.addTarget(self, action: #selector(showMoodButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)

        if let dateString = selectedDate {
            let dateComponents = dateString.split(separator: "/")
            if dateComponents.count == 3 {
                let day = String(dateComponents[0])
                let month = String(dateComponents[1])
                let year = String(dateComponents[2])

                dayLabel.text = day

                if let monthNumber = Int(month), monthNumber >= 1 && monthNumber <= 12 {
                    let monthName = months[monthNumber - 1]
                    monthYearLabel.text = "\(monthName), \(year)"
                }

                if let fullDate = getDateFrom(day: day, month: month, year: year) {
                    let weekday = getWeekdayFromDate(fullDate)
                    weekdayLabel.text = weekday
                }
            }
        }
    }
    
    func setupUI() {
       
        view.addSubview(headerContainerView)
        view.addSubview(saveButton)
        monthYearStackView.addArrangedSubview(monthYearLabel)
        monthYearStackView.addArrangedSubview(weekdayLabel)

        headerContainerView.addSubview(dayLabel)
        headerContainerView.addSubview(pastelLineView)
        headerContainerView.addSubview(lineView)
        headerContainerView.addSubview(monthYearStackView)
        headerContainerView.addSubview(faceButton)

        func createStyledCircularIconView(withImage image: UIImage?) -> UIView {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false

            // Butonlarla uyumlu gradient arka plan
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(red: 0.6, green: 0.4, blue: 0.4, alpha: 1.0).cgColor,  // Orta kahverengi ton
                UIColor(red: 0.5, green: 0.3, blue: 0.3, alpha: 1.0).cgColor   // Daha koyu kahverengi ton
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.cornerRadius = 35  // Daha küçük çap: 35
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 70, height: 70)  // Küçültülmüş boyut: 70x70
            containerView.layer.insertSublayer(gradientLayer, at: 0)

            // Gölge efekti
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.2
            containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            containerView.layer.shadowRadius = 6
            containerView.layer.masksToBounds = false

            // Hafif bir parlama efekti ekleyelim
            let glowLayer = CALayer()
            glowLayer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor  // Hafif beyaz parlama
            glowLayer.frame = CGRect(x: -5, y: -5, width: 80, height: 80)  // Parlama genişletme
            glowLayer.cornerRadius = 40
            containerView.layer.insertSublayer(glowLayer, at: 1)

            // Dış çerçeve: Açık bej tonunda (butonlara uygun)
            containerView.layer.cornerRadius = 35
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor(red: 0.95, green: 0.88, blue: 0.75, alpha: 1.0).cgColor  // Açık bej çerçeve

            // İçerideki görsel
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)

            // ImageView constraint'leri
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 40),  // Küçültülmüş boyut: 40x40
                imageView.heightAnchor.constraint(equalToConstant: 40)
            ])

            // Container boyut constraint'leri
            NSLayoutConstraint.activate([
                containerView.widthAnchor.constraint(equalToConstant: 70),  // Küçültülmüş ikon boyutu: 70x70
                containerView.heightAnchor.constraint(equalToConstant: 70)
            ])

            return containerView
        }




        // "Kahve Anını Seç" butonunun soluna büyük dairesel ikon ekleyelim
        let dateImage = UIImage(named: "date")
        let dateIconView = createStyledCircularIconView(withImage: dateImage)

        // "Kahveni Seç" butonunun soluna büyük dairesel ikon ekleyelim
        let coffeeImage = UIImage(named: "coffee")
        let coffeeIconView = createStyledCircularIconView(withImage: coffeeImage)

        // "Kahve Anını Seç" butonunu ikon ile hizalı hale getirelim
        let buttonStackView = UIStackView(arrangedSubviews: [dateIconView, selectMomentButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 20 // İkon ile buton arasında boşluk
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        // "Kahveni Seç" butonunu ikon ile hizalı hale getirelim
        let coffeeButtonStackView = UIStackView(arrangedSubviews: [coffeeIconView, selectCoffeeButton])
        coffeeButtonStackView.axis = .horizontal
        coffeeButtonStackView.alignment = .center
        coffeeButtonStackView.spacing = 20
        coffeeButtonStackView.translatesAutoresizingMaskIntoConstraints = false

        // Butonları ve ikonları view'e ekleyelim
        view.addSubview(buttonStackView)
        view.addSubview(coffeeButtonStackView)

        // Custom container view'i view'e ekleyelim
        view.addSubview(customContainerView)

        // TextView ve ilgili öğeleri ekleyelim
        customContainerView.addSubview(textView)
        customContainerView.addSubview(placeholderLabel)
        customContainerView.addSubview(characterCountLabel)

        // 3 adet imageView oluşturalım ve customContainerView'e ekleyelim
        let imageView1 = createImageView(size: 80)
        let imageView2 = createImageView(size: 80)
        let imageView3 = createImageView(size: 80)

        let imageStackView = UIStackView(arrangedSubviews: [imageView1, imageView2, imageView3])
        imageStackView.axis = .horizontal
        imageStackView.alignment = .center
        imageStackView.distribution = .equalSpacing
        imageStackView.spacing = 15
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        customContainerView.addSubview(imageStackView)

        // İlk headerContainerView constraint'leri
        NSLayoutConstraint.activate([
       
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
               saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               saveButton.widthAnchor.constraint(equalToConstant: 140),
               saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            headerContainerView.topAnchor.constraint(equalTo: saveButton.topAnchor, constant: 70),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerContainerView.heightAnchor.constraint(equalToConstant: 110),

            dayLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 20),

            pastelLineView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            pastelLineView.leadingAnchor.constraint(equalTo: dayLabel.leadingAnchor),
            pastelLineView.trailingAnchor.constraint(equalTo: dayLabel.trailingAnchor),
            pastelLineView.heightAnchor.constraint(equalToConstant: 12),

            lineView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 16),
              lineView.topAnchor.constraint(equalTo: dayLabel.topAnchor,constant: 10),  // dayLabel'ın üstüne hizalanır
              lineView.bottomAnchor.constraint(equalTo: pastelLineView.bottomAnchor),  // pastelLineView'in altına hizalanır
              lineView.widthAnchor.constraint(equalToConstant: 2),
            
            monthYearStackView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 16),
            monthYearStackView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),

            faceButton.widthAnchor.constraint(equalToConstant: 50),
            faceButton.heightAnchor.constraint(equalToConstant: 50),
            faceButton.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -20),
            faceButton.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),

            // "Kahve Anını Seç" butonunun yerleşimi
            buttonStackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 80),

            // "Kahveni Seç" butonunun yerleşimi
            coffeeButtonStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            coffeeButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            coffeeButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            coffeeButtonStackView.heightAnchor.constraint(equalToConstant: 80),

            // customContainerView constraint'leri
            customContainerView.topAnchor.constraint(equalTo: coffeeButtonStackView.bottomAnchor, constant: 40),
            customContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customContainerView.heightAnchor.constraint(equalToConstant: 270),

            // textView constraint'leri
            textView.topAnchor.constraint(equalTo: customContainerView.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: customContainerView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: customContainerView.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 120),

            // placeholderLabel constraint'leri
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),

            // characterCountLabel constraint'leri
            characterCountLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -5),
            characterCountLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -4),

            // imageStackView constraint'leri
            imageStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imageStackView.centerXAnchor.constraint(equalTo: customContainerView.centerXAnchor)
        ])
        
        selectMomentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectCoffeeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }








    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func convertDateToMySQLFormat(dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        inputFormatter.timeZone = TimeZone.current

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            outputFormatter.timeZone = TimeZone.current
            return outputFormatter.string(from: date)
        }
        return nil
    }

    
    @objc func saveButtonTapped() {
     
        let userId = "oyku"
        let eventId = "8"
        let eventDescription = textView.text ?? "Today is a very beautiful day."
        let eventDate = convertDateToMySQLFormat(dateString: selectedDate ?? "08/10/2024") ?? "2024-10-08"
        let coffeeEventDescription = selectMomentButton.title(for: .normal) ?? "While drinking my morning coffee, I enjoyed a wonderful view."
        
   
        var images: [[String: Any]] = []

        if let selectedMoodImage = selectedMoodImage, let moodImageData = selectedMoodImage.jpegData(compressionQuality: 0.8)?.base64EncodedString() {
            images.append([
                "FileName": "selected_mood_emoji.jpg",
                "DocumentGUID": UUID().uuidString,
                "DocumentCategory": "emoji",
                "data": moodImageData
            ])
        }

        for metadata in photoMetadataList {
            if let imageData = metadata.image.jpegData(compressionQuality: 0.8)?.base64EncodedString() {
                images.append([
                    "FileName": metadata.fileName,
                    "DocumentGUID": UUID().uuidString,
                    "DocumentCategory": "normal",
                    "data": imageData
                ])
            }
        }
        
        AniKaydetRequest.shared.sendAniKaydet(
            userId: userId,
            eventId: eventId,
            eventDescription: eventDescription,
            eventDate: eventDate,
            coffeeEventDescription: coffeeEventDescription,
            images: images
        ) { result in
            switch result {
            case .success(let response):
                print("Başarıyla kaydedildi: \(response)")
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }


    func getDateFrom(day: String, month: String, year: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        let dateString = "\(day)/\(month)/\(year)"
        return dateFormatter.date(from: dateString)
    }

    func getWeekdayFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    
    func addTapGesturesToImageViews() {
       
        for subview in imageContainerStackView.arrangedSubviews {
            if let imageView = subview as? UIImageView {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGesture)
             
            } else {
              
            }
        }
    }


    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        if let tappedImageView = sender.view as? UIImageView {
          
            openCamera()
        } else {
           
        }
    }

    func openCamera() {
      
        guard let photoManager = photoManager else {
         return
        }
     
        photoManager.openCamera(from: self)
    }
    
    func photoManagerDidSavePhoto(base64String: String, fileName: String) {
          
            if let imageData = Data(base64Encoded: base64String), let image = UIImage(data: imageData) {
                let newPhoto = PhotoMetadata(image: image, fileName: fileName)
                photoMetadataList.append(newPhoto)
              
                updateImageView(with: image)
            } else {
              
            }
        }

    func updateImageView(with image: UIImage) {
        for subview in imageContainerStackView.arrangedSubviews {
            if let imageView = subview as? UIImageView {
               
                if imageView.image?.isSymbolImage == true {
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    break
                }
            }
        }
    }
   

    
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text ?? ""
        
        
        placeholderLabel.isHidden = !currentText.isEmpty
        
        
        if currentText.isEmpty {
            characterCountLabel.isHidden = true
        } else {
            characterCountLabel.isHidden = false
            characterCountLabel.text = "\(currentText.count)/\(maxCharacterCount)"
        }
        
       
        if currentText.count > maxCharacterCount {
            textView.text = String(currentText.prefix(maxCharacterCount))
        }
    }
    
    
    @objc private func showCoffeePicker() {
        let coffeePickerVC = CoffeePickerViewController()
        coffeePickerVC.onSelection = { [weak self] selectedOption in
            self?.selectMomentButton.setTitle(selectedOption, for: .normal)
        }
        coffeePickerVC.modalPresentationStyle = .overCurrentContext
        coffeePickerVC.modalTransitionStyle = .crossDissolve
        present(coffeePickerVC, animated: true, completion: nil)
    }

    @objc private func showCoffeeTypePicker() {
        let coffeePickerVC = CoffeeTypePickerViewController()
        coffeePickerVC.onSelection = { [weak self] selectedOption in
            self?.selectCoffeeButton.setTitle(selectedOption, for: .normal)
        }
        coffeePickerVC.modalPresentationStyle = .overCurrentContext
        coffeePickerVC.modalTransitionStyle = .crossDissolve
        present(coffeePickerVC, animated: true, completion: nil)
    }
    
    @objc private func onConfirm() {
        alertView?.removeFromSuperview()
        dimmedBackground?.removeFromSuperview()
        if let selectedOption = selectedOption {
            selectMomentButton.setTitle(selectedOption, for: .normal)
        }
    }
    
    @objc private func onCancel() {
        alertView?.removeFromSuperview()
        dimmedBackground?.removeFromSuperview()
    }
    
  

    @objc private func showMoodButtonTapped() {
        let moodVC = MoodViewController()
        
        moodVC.onMoodSelected = { [weak self] selectedImage in
            if let selectedImage = selectedImage {
                
                self?.faceButton.setImage(nil, for: .normal)
                
             
                let originalImage = selectedImage.withRenderingMode(.alwaysOriginal)
                
                self?.faceButton.setImage(originalImage, for: .normal)
            }
        }
        
       
        moodVC.modalPresentationStyle = .overCurrentContext
        moodVC.modalTransitionStyle = .crossDissolve
      
        moodVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
     
        moodVC.view.frame = CGRect(x: 20, y: self.view.frame.height * 0.3, width: self.view.frame.width - 40, height: self.view.frame.height * 0.4)
        moodVC.view.layer.cornerRadius = 15
        moodVC.view.clipsToBounds = true

    
        present(moodVC, animated: true, completion: nil)
    }


       @objc private func closeMoodView() {
           UIView.animate(withDuration: 0.3, animations: {
               self.moodCollectionView?.superview?.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
           }) { _ in
               self.moodCollectionView?.superview?.superview?.removeFromSuperview()
           }
       }
   
}
