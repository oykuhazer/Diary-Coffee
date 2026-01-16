//
//  SampleView.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 3.02.2025.
//

import UIKit

class SampleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        text = "SAMPLE"
        textColor = AppColors.color2
        font = UIFont.boldSystemFont(ofSize: 10)
        textAlignment = .center
        backgroundColor = AppColors.color20
        layer.cornerRadius = 8
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
