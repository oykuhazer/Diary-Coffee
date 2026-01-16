//
//  CoffeeAnalysisDetailCell.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.10.2024.
//

import Foundation
import UIKit

class CoffeeAnalysisDetailCell: UITableViewCell {
    
    let rowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let momentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textColor = AppColors.color5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.textColor = AppColors.color10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = AppColors.color24
        
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        
     
        imageView.layer.borderColor = AppColors.color7.cgColor
        imageView.layer.borderWidth = 2
        
       
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageView.layer.shadowRadius = 4

        return imageView
    }()
    
    func configure(with imageName: String, rowNumber: Int, momentText: String, countText: String) {
        iconImageView.image = UIImage(named: imageName)
        rowLabel.text = "\(rowNumber)"
        momentLabel.text = momentText
        countLabel.text = countText
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(rowLabel)
        addSubview(imageContainerView)
        imageContainerView.addSubview(iconImageView)
        addSubview(momentLabel)
        addSubview(countLabel)
        
      
        NSLayoutConstraint.activate([
            rowLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            rowLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            rowLabel.widthAnchor.constraint(equalToConstant: 30),
            
            imageContainerView.leadingAnchor.constraint(equalTo: rowLabel.trailingAnchor, constant: 20),
            imageContainerView.topAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            imageContainerView.widthAnchor.constraint(equalToConstant: 40),
            imageContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            momentLabel.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: 20),
            momentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: momentLabel.leadingAnchor),
            countLabel.topAnchor.constraint(equalTo: momentLabel.bottomAnchor, constant: 3)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

