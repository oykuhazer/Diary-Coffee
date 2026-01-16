//
//  SortByView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.10.2024.
//

import UIKit

class SortByView: UIViewController {
    
    var sortCompletion: ((Bool) -> Void)?
    
    private let modalView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color29
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
        label.text = NSLocalizedString("sort_by", comment: "")
        label.font = UIFont(name: "AvenirNext-Bold", size: 24)
        label.textColor = AppColors.color30
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        
     
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        button.setImage(image?.withConfiguration(configuration), for: .normal)
        
        button.tintColor = AppColors.color4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let mostRecordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("most_records", comment: ""), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        button.backgroundColor = AppColors.color30
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sortByMostRecords), for: .touchUpInside)
        return button
    }()
    
    private let leastRecordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("least_records", comment: ""), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        button.backgroundColor = AppColors.color30
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sortByLeastRecords), for: .touchUpInside)
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
    
    @objc private func sortByLeastRecords() {
        sortCompletion?(true)
        dismissModal()
    }
    
    @objc private func sortByMostRecords() {
        sortCompletion?(false)
        dismissModal()
    }
    

    
    private func setupView() {
        view.backgroundColor = AppColors.color42
        view.addSubview(modalView)
        modalView.addSubview(titleLabel)
        modalView.addSubview(closeButton)
        modalView.addSubview(mostRecordsButton)
        modalView.addSubview(leastRecordsButton)
    
        let isIphone8 = UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 667
        let isIphone8PlusOr7Plus = UIScreen.main.bounds.width == 414 && UIScreen.main.bounds.height == 736

        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (isIphone8 || isIphone8PlusOr7Plus) ? 320 : 300),
            modalView.heightAnchor.constraint(equalToConstant: 280),
 
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            mostRecordsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            mostRecordsButton.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            mostRecordsButton.widthAnchor.constraint(equalTo: modalView.widthAnchor, multiplier: 0.8),
          
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
         self.dismiss(animated: true, completion: nil)
     }
}
