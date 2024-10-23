//
//  SortByView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.10.2024.
//

import UIKit

class SortByView: UIViewController {
    
    private let modalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 1.0) // Soft pastel arka plan
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort By"
        label.font = UIFont(name: "AvenirNext-Bold", size: 24) // Büyük, dikkat çekici, modern bir font
        label.textColor = UIColor(red: 0.35, green: 0.25, blue: 0.2, alpha: 1.0) // Zarif kahve tonları
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        
        // Simgenin boyutunu büyütmek için preferredSymbolConfiguration ekliyoruz
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        button.setImage(image?.withConfiguration(configuration), for: .normal)
        
        button.tintColor = UIColor(red: 0.7, green: 0.6, blue: 0.55, alpha: 1.0) // Kibar soft renkler
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let mostRecordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Most Records", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        button.backgroundColor = UIColor(red: 0.35, green: 0.25, blue: 0.2, alpha: 1.0) // Kahve tonları
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leastRecordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Least Records", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        button.backgroundColor = UIColor(red: 0.35, green: 0.25, blue: 0.2, alpha: 1.0) // Kahve tonları
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateModalIn()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(modalView)
        modalView.addSubview(titleLabel)
        modalView.addSubview(closeButton)
        modalView.addSubview(mostRecordsButton)
        modalView.addSubview(leastRecordsButton)
    
        
        NSLayoutConstraint.activate([
            // Modal view constraints
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300),
            modalView.heightAnchor.constraint(equalToConstant: 280), // Hafif artırılmış yükseklik
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor), // Y olarak titleLabel ile ortalanmış
            closeButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -12), // Sağda konumlandırıldı
            closeButton.widthAnchor.constraint(equalToConstant: 30), // Buton genişliği
            closeButton.heightAnchor.constraint(equalToConstant: 30), // Buton yüksekliği
            
            // Most records button constraints
            mostRecordsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40), // Daha ferah aralıklar
            mostRecordsButton.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            mostRecordsButton.widthAnchor.constraint(equalTo: modalView.widthAnchor, multiplier: 0.8),
            
            // Least records button constraints
            leastRecordsButton.topAnchor.constraint(equalTo: mostRecordsButton.bottomAnchor, constant: 20),
            leastRecordsButton.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            leastRecordsButton.widthAnchor.constraint(equalTo: modalView.widthAnchor, multiplier: 0.8)
          
        ])
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func animateModalIn() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.modalView.transform = CGAffineTransform(translationX: 0, y: -300)
        }, completion: nil)
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.4, animations: {
            self.modalView.transform = .identity
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
