//
//  CalendarCellButtonStack.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 28.10.2024.
//

import UIKit

class CalendarCellButtonStack: UIStackView {
    
    private let buttonColor = AppColors.color1
    private let buttonSize: CGFloat = 20
    
    init(buttonSymbols: [String]) {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false

        for symbolName in buttonSymbols {
            let button = createButton(withSystemName: symbolName, color: buttonColor, size: buttonSize)
            addArrangedSubview(button)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createButton(withSystemName systemName: String, color: UIColor, size: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        return button
    }
}
