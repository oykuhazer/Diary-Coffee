//
//  LoadingView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 19.11.2024.
//

import UIKit


class LoadingView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "loading")
        return imageView
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.color2
        view.layer.cornerRadius = 50
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
       
        backgroundColor = AppColors.color31
        
        addSubview(circleView)
        circleView.addSubview(imageView)
        
      
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 100),
            circleView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
     
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        startRotation()
    }
    
    private func startRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 2
        rotationAnimation.repeatCount = .infinity 
        circleView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
