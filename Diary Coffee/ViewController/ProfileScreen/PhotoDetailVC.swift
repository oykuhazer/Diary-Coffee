//
//  PhotoDetailVC.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 12.11.2024.
//

import UIKit
import Photos

class PhotoDetailVC: UIViewController {
    
  
    var documentInfo: DocumentInfo?
    var entryDate: String?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupScrollView()
        setupNavigationBar()
        displayImage()
        
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
           
            tabBarController.tabBar.isHidden = true
            tabBarController.tabBar.isUserInteractionEnabled = false
            tabBarController.tabBar.items?.forEach { $0.isEnabled = false }

           
            tabBarController.circularView.isHidden = true
            tabBarController.circularView.isUserInteractionEnabled = false
            
           
            if let gestures = tabBarController.circularView.gestureRecognizers {
                gestures.forEach { tabBarController.circularView.removeGestureRecognizer($0) }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? CustomTabBarController {
           
            tabBarController.tabBar.isHidden = false
            tabBarController.tabBar.isUserInteractionEnabled = true
            tabBarController.tabBar.items?.forEach { $0.isEnabled = true }

            
            tabBarController.circularView.isHidden = false
            tabBarController.circularView.isUserInteractionEnabled = true
            
            
            let tapGesture = UITapGestureRecognizer(target: tabBarController, action: #selector(tabBarController.circularViewTapped))
            tabBarController.circularView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setupNavigationBar() {
       
        navigationItem.title = formattedDateTitle(entryDate)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = AppColors.color5
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.color5
        ]
    
        let downloadButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(downloadImage)
        )
        downloadButton.tintColor = navigationController?.navigationBar.tintColor
        navigationItem.rightBarButtonItem = downloadButton
    }

    @objc private func downloadImage() {
        
        guard let image = imageView.image else {
          
            return
        }
        
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
              
                self.saveImageToGallery(image)
            case .denied, .restricted: break
               
            case .notDetermined: break
                
            @unknown default:
                break
            }
        }
    }

    private func saveImageToGallery(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if success {
              
            } else if let error = error {
                
            }
        }
    }

    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    
    private func displayImage() {
        if let base64String = documentInfo?.base64Data, let imageData = Data(base64Encoded: base64String) {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func formattedDateTitle(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEEE, MMMM d"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
}


extension PhotoDetailVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
