//
//  PhotoSelectView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 2.12.2024.
//

import UIKit

class PhotoSelectView: UIViewController {
    
    var photoSelectCompletion: ((String) -> Void)?

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
        label.text = NSLocalizedString("photo_options", comment: "")
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
    
    private let albumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("select_from_album", comment: ""), for: .normal)
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
        button.addTarget(self, action: #selector(selectFromAlbum), for: .touchUpInside)
        return button
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("open_camera", comment: ""), for: .normal)
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
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
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
    
    @objc private func selectFromAlbum() {
        photoSelectCompletion?(NSLocalizedString("album", comment: ""))
        dismissModal()
    }

    @objc private func openCamera() {
        photoSelectCompletion?(NSLocalizedString("camera", comment: ""))
        dismissModal()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(modalView)
        modalView.addSubview(titleLabel)
        modalView.addSubview(closeButton)
        modalView.addSubview(albumButton)
        modalView.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300),
            modalView.heightAnchor.constraint(equalToConstant: 280),
            
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            albumButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            albumButton.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            albumButton.widthAnchor.constraint(equalTo: modalView.widthAnchor, multiplier: 0.8),
            
            cameraButton.topAnchor.constraint(equalTo: albumButton.bottomAnchor, constant: 20),
            cameraButton.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            cameraButton.widthAnchor.constraint(equalTo: modalView.widthAnchor, multiplier: 0.8)
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

