//
//  DiaryEntryCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 4.10.2024.
//

import UIKit

class DiaryEntryCell: UICollectionViewCell {

    let dayLabel = UILabel()
    let monthYearLabel = UILabel()
    let weekdayLabel = UILabel()
    let verticalLine = UIView()
    let textView = UILabel()
    let additionalLabel = UILabel() // CoffeeEventDescription için
    let square1 = UIImageView() // Normal resimler için
    let square2 = UIImageView()
    let square3 = UIImageView()
    let circleView = UIImageView() // Emoji resimleri için

    let baseURL = "http://192.168.0.12:3000" // Sunucu temel URL'si

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyShadowAndStyling()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        dayLabel.font = UIFont(name: "AvenirNext-Bold", size: 28)
        dayLabel.textColor = UIColor(red: 86/255, green: 58/255, blue: 49/255, alpha: 1)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)

        monthYearLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        monthYearLabel.textColor = UIColor(red: 135/255, green: 100/255, blue: 90/255, alpha: 1)
        monthYearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(monthYearLabel)

        weekdayLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        weekdayLabel.textColor = UIColor(red: 100/255, green: 70/255, blue: 60/255, alpha: 1)
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weekdayLabel)

        verticalLine.backgroundColor = UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1)
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalLine)

        textView.numberOfLines = 4
        textView.font = UIFont(name: "AvenirNext-Regular", size: 14)
        textView.textColor = UIColor(red: 86/255, green: 58/255, blue: 49/255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)

        additionalLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        additionalLabel.textColor = .darkGray
        additionalLabel.textAlignment = .right
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(additionalLabel)

        setupSquaresAndCircle()

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            verticalLine.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            verticalLine.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 10),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.heightAnchor.constraint(equalToConstant: 40),

            monthYearLabel.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor, constant: -10),
            monthYearLabel.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 10),

            weekdayLabel.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor, constant: 4),
            weekdayLabel.leadingAnchor.constraint(equalTo: monthYearLabel.leadingAnchor),

            additionalLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10),
            additionalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            additionalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            textView.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            square1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            square1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            square1.widthAnchor.constraint(equalToConstant: 40),
            square1.heightAnchor.constraint(equalToConstant: 40),

            square2.centerYAnchor.constraint(equalTo: square1.centerYAnchor),
            square2.leadingAnchor.constraint(equalTo: square1.trailingAnchor, constant: 10),
            square2.widthAnchor.constraint(equalToConstant: 40),
            square2.heightAnchor.constraint(equalToConstant: 40),

            square3.centerYAnchor.constraint(equalTo: square1.centerYAnchor),
            square3.leadingAnchor.constraint(equalTo: square2.trailingAnchor, constant: 10),
            square3.widthAnchor.constraint(equalToConstant: 40),
            square3.heightAnchor.constraint(equalToConstant: 40),

            circleView.centerYAnchor.constraint(equalTo: square1.centerYAnchor),
            circleView.leadingAnchor.constraint(equalTo: square3.trailingAnchor, constant: 10),
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupSquaresAndCircle() {
        [square1, square2, square3].forEach { square in
            square.layer.cornerRadius = 6
            square.layer.masksToBounds = true
            square.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(square)
        }

        circleView.layer.cornerRadius = 20
        circleView.layer.masksToBounds = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circleView)
    }

    func applyShadowAndStyling() {
        contentView.backgroundColor = UIColor(red: 242/255, green: 235/255, blue: 228/255, alpha: 1)
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 4, height: 4)
        contentView.layer.shadowRadius = 6
    }

    func configure(with entry: AniListesi) {
        // Placeholder görselleri ayarlıyoruz
        square1.image = nil
        square2.image = nil
        square3.image = nil
        circleView.image = nil
        
        // EventDescription -> textView
        textView.text = entry.eventDescription
        
        // CoffeeEventDescription -> additionalLabel
        additionalLabel.text = entry.coffeeEventDescription
        
        // Images -> square1, square2, square3 (normal), circleView (emoji)
        var imageCount = 0
        for image in entry.images {
            let fullURL = "\(baseURL)\(image.imageURL)" // Tam URL oluşturuluyor
            if image.documentCategory == "emoji" {
                loadImage(from: fullURL, into: circleView)
            } else {
                switch imageCount {
                case 0:
                    loadImage(from: fullURL, into: square1)
                case 1:
                    loadImage(from: fullURL, into: square2)
                case 2:
                    loadImage(from: fullURL, into: square3)
                default:
                    break
                }
                imageCount += 1
            }
        }

        // EventDate -> dayLabel, monthYearLabel, weekdayLabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: entry.eventDate) {
            let calendar = Calendar.current
            var day = calendar.component(.day, from: date)
            let month = dateFormatter.shortMonthSymbols[calendar.component(.month, from: date) - 1].uppercased()
            let year = calendar.component(.year, from: date)
            let weekday = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: date) - 1]

            // Gün 1 ile 9 arasındaysa başına '0' ekleyin
            let dayString = day < 10 ? "0\(day)" : "\(day)"
            
            dayLabel.text = dayString
            monthYearLabel.text = "\(month), \(year)"
            weekdayLabel.text = weekday.capitalized
        }
    }

    // Resimleri yükleyen fonksiyon (Kingfisher kullanmadan)
    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
}
