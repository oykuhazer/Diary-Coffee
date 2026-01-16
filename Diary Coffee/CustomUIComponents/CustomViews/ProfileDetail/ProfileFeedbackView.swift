//
//  ProfileFeedbackView.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 12.12.2024.
//

import UIKit

class ProfileFeedbackView: UIView, UITextViewDelegate {
    
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


    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("write", comment: "")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = AppColors.color41
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var feedbackContainerBottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addKeyboardObservers()
        addKeyboardDismissGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addKeyboardObservers()
        addKeyboardDismissGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        backgroundColor = AppColors.color46
        
        
        let feedbackContainer = UIView()
        feedbackContainer.backgroundColor = AppColors.color26
        feedbackContainer.layer.cornerRadius = 15
        feedbackContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(feedbackContainer)
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("send_feedback", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.color2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackContainer.addSubview(titleLabel)
        
       
        feedbackContainer.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.delegate = self
        
       let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(AppColors.color2, for: .normal)
        cancelButton.backgroundColor = AppColors.color4
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.layer.cornerRadius = 10
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside) 
        feedbackContainer.addSubview(cancelButton)
        
       
        let sendButton = UIButton(type: .system)
        sendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        sendButton.setTitleColor(AppColors.color3, for: .normal)
        sendButton.backgroundColor = AppColors.color2
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        sendButton.layer.cornerRadius = 10
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackContainer.addSubview(sendButton)
        
       
        feedbackContainerBottomConstraint = feedbackContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            feedbackContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            feedbackContainerBottomConstraint,
            feedbackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            feedbackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            feedbackContainer.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: feedbackContainer.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: feedbackContainer.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 50),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 15),
            
            cancelButton.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: feedbackContainer.bottomAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalTo: feedbackContainer.widthAnchor, multiplier: 0.42),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            sendButton.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -20),
            sendButton.bottomAnchor.constraint(equalTo: feedbackContainer.bottomAnchor, constant: -16),
            sendButton.widthAnchor.constraint(equalTo: feedbackContainer.widthAnchor, multiplier: 0.42),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        feedbackContainerBottomConstraint.constant = -keyboardFrame.height
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        feedbackContainerBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func cancelButtonTapped() {
        self.removeFromSuperview()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
     
        if textView.text.count > 200 {
            textView.text = String(textView.text.prefix(200))
        }
        
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = max(50, estimatedSize.height)
            }
        }
        
        
        let feedbackContainerHeight = 200 + (estimatedSize.height - 50)
        if let feedbackContainer = textView.superview {
            feedbackContainer.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = feedbackContainerHeight
                }
            }
        }
    }

}
