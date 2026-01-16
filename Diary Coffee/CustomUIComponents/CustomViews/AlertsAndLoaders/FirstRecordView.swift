//
//  FirstRecordView.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 23.11.2024.
//

import UIKit

class FirstRecordView: UIView, UIScrollViewDelegate {

  
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = AppColors.color20
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 20
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.4)
        return pageControl
    }()
    
    private func createCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = AppColors.color32
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }
    
    private let congratulationsView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let deeperLookView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.color20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    private func setupView() {
        backgroundColor = AppColors.color31

        scrollView.delegate = self
        addSubview(scrollView)
        addSubview(pageControl)

        setupCongratulationsView()
        setupDeeperLookView()

        setupScrollView()
        setupConstraints()
    }

    private func setupScrollView() {
        scrollView.addSubview(congratulationsView)
        scrollView.addSubview(deeperLookView)

        NSLayoutConstraint.activate([
            congratulationsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            congratulationsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            congratulationsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            congratulationsView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            deeperLookView.leadingAnchor.constraint(equalTo: congratulationsView.trailingAnchor),
            deeperLookView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            deeperLookView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            deeperLookView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            deeperLookView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
           
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 500),

           
            pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupCongratulationsView() {
        let titleLabel = createTitleLabel(
            text: NSLocalizedString("congratulations", comment: "")
        )

        let subtitleLabel = createSubtitleLabel(
            text: NSLocalizedString("first_coffee_recorded", comment: "")
        )

        let nextButton = createButton(
            title: NSLocalizedString("next", comment: "")
        )

        let firstRecordImageView = createImageView(named: "firstrecord")
        nextButton.addTarget(self, action: #selector(scrollToNextPage), for: .touchUpInside)
        let closeButton = createCloseButton()

        congratulationsView.addSubview(titleLabel)
        congratulationsView.addSubview(subtitleLabel)
        congratulationsView.addSubview(firstRecordImageView)
        congratulationsView.addSubview(nextButton)
        congratulationsView.addSubview(closeButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: congratulationsView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: congratulationsView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: congratulationsView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: congratulationsView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: congratulationsView.trailingAnchor, constant: -20),

            firstRecordImageView.centerXAnchor.constraint(equalTo: congratulationsView.centerXAnchor),
            firstRecordImageView.centerYAnchor.constraint(equalTo: congratulationsView.centerYAnchor),
            firstRecordImageView.widthAnchor.constraint(equalToConstant: 220),
            firstRecordImageView.heightAnchor.constraint(equalToConstant: 220),

            nextButton.bottomAnchor.constraint(equalTo: congratulationsView.bottomAnchor, constant: -50),
            nextButton.centerXAnchor.constraint(equalTo: congratulationsView.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 220),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            closeButton.topAnchor.constraint(equalTo: congratulationsView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: congratulationsView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupDeeperLookView() {
        let titleLabel = createTitleLabel(
            text: NSLocalizedString("look_a_bit_deeper", comment: "")
        )

        let subtitleLabel = createSubtitleLabel(
            text: NSLocalizedString("personal_reports", comment: "")
        )

        let gotItButton = createButton(
            title: NSLocalizedString("got_it", comment: "")
        )

        let analysisImageView = createImageView(named: "danalysis")
        gotItButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        let closeButton = createCloseButton()

        deeperLookView.addSubview(titleLabel)
        deeperLookView.addSubview(subtitleLabel)
        deeperLookView.addSubview(analysisImageView)
        deeperLookView.addSubview(gotItButton)
        deeperLookView.addSubview(closeButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: deeperLookView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: deeperLookView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: deeperLookView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: deeperLookView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: deeperLookView.trailingAnchor, constant: -20),

            analysisImageView.centerXAnchor.constraint(equalTo: deeperLookView.centerXAnchor),
            analysisImageView.centerYAnchor.constraint(equalTo: deeperLookView.centerYAnchor,constant: 10),
            analysisImageView.widthAnchor.constraint(equalToConstant: 200),
            analysisImageView.heightAnchor.constraint(equalToConstant: 200),

            gotItButton.bottomAnchor.constraint(equalTo: deeperLookView.bottomAnchor, constant: -50),
            gotItButton.centerXAnchor.constraint(equalTo: deeperLookView.centerXAnchor),
            gotItButton.widthAnchor.constraint(equalToConstant: 220),
            gotItButton.heightAnchor.constraint(equalToConstant: 50),

            closeButton.topAnchor.constraint(equalTo: deeperLookView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: deeperLookView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

   
    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }

    private func createSubtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = AppColors.color33
        label.numberOfLines = 0
        return label
    }

    private func createImageView(named: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: named)
        return imageView
    }

    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.color28
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

   
    @objc private func scrollToNextPage() {
        let nextOffset = CGPoint(x: scrollView.frame.width, y: 0)
        scrollView.setContentOffset(nextOffset, animated: true)
        pageControl.currentPage = 1
    }

    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
