//
//  NoteView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 30.10.2024.
//

import UIKit

class NoteView: UIView, UITextViewDelegate {
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("todays_brewed_thoughts", comment: "")
        label.textColor = AppColors.color2
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = AppColors.color20
        textView.textColor = AppColors.color2
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var text: String {
         return textView.text
     }
    
    var hasText: Bool {
           return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
       }
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("write", comment: "")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = AppColors.color41
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textViewHeightConstraint: NSLayoutConstraint!
    var onHeightChange: ((CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = AppColors.color26
        self.layer.cornerRadius = 10
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(placeholderLabel)
        
        textView.delegate = self
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textViewHeightConstraint,
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 15)
        ])
        
       
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = AppColors.color41.cgColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
       
        placeholderLabel.isHidden = !textView.text.isEmpty
        
       
        if textView.text.count > 500 {
            textView.text = String(textView.text.prefix(500))
        }
        
      
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height != textViewHeightConstraint.constant {
            textViewHeightConstraint.constant = max(40, newSize.height)
            onHeightChange?(newSize.height + 80)
        }
    }
}
