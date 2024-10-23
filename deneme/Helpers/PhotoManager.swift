//
//  PhotoManager.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 7.10.2024.
//


import UIKit
import Foundation
import AVFoundation

protocol PhotoManagerDelegate: AnyObject {
    func photoManagerDidSavePhoto(base64String: String, fileName: String)
}

class PhotoManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var imageViewForZoom: UIImageView?
    var base64String: String?
    var fileName: String?
    weak var delegate: PhotoManagerDelegate?
    
    private let randomStringLength = 16

    func openCamera(from viewController: UIViewController) {
        let customCameraVC = CustomCameraViewController()
        customCameraVC.photoManager = self
        viewController.present(customCameraVC, animated: true, completion: nil)
    }

    func savePhoto(takenPhoto: UIImage) {
        guard let jpegData = takenPhoto.jpegData(compressionQuality: 0.5) else {
            print("JPEG verisi oluşturulamadı")
            return
        }
        
        let randomString = getRandomString(length: randomStringLength)
        let fileName = "\(randomString).jpg"
        let filePath = createFilePath(fileName)
        
        do {
            try jpegData.write(to: filePath)
            delegate?.photoManagerDidSavePhoto(base64String: jpegData.base64EncodedString(), fileName: fileName)
        } catch {
            print("Dosya yazılırken hata oluştu: \(error)")
        }
    }

    func createFilePath(_ fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }

    func getRandomString(length: Int) -> String {
        let letters = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    func showImageFullscreen(from viewController: UIViewController, dokumanURL: URL) {
        URLSession.shared.dataTask(with: dokumanURL) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                let scrollView = UIScrollView(frame: UIScreen.main.bounds)
                scrollView.backgroundColor = .black
                scrollView.delegate = self
                scrollView.minimumZoomScale = 1.0
                scrollView.maximumZoomScale = 6.0
                
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = scrollView.bounds
                scrollView.addSubview(imageView)
                
                self.imageViewForZoom = imageView
                
                let closeButton = UIButton(type: .system)
                closeButton.setTitle("Kapat", for: .normal)
                closeButton.tintColor = .black
                closeButton.backgroundColor = .white.withAlphaComponent(0.7)
                closeButton.layer.cornerRadius = 15
                closeButton.translatesAutoresizingMaskIntoConstraints = false
                closeButton.addTarget(self, action: #selector(self.dismissFullscreenView), for: .touchUpInside)
                
                let imageViewerView = UIView(frame: UIScreen.main.bounds)
                imageViewerView.backgroundColor = .black
                imageViewerView.addSubview(scrollView)
                imageViewerView.addSubview(closeButton)
                
                NSLayoutConstraint.activate([
                    closeButton.topAnchor.constraint(equalTo: imageViewerView.safeAreaLayoutGuide.topAnchor, constant: 20),
                    closeButton.trailingAnchor.constraint(equalTo: imageViewerView.trailingAnchor, constant: -20),
                    closeButton.widthAnchor.constraint(equalToConstant: 70),
                    closeButton.heightAnchor.constraint(equalToConstant: 30)
                ])
                
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    window.addSubview(imageViewerView)
                }
            }
        }.resume()
    }

    @objc func dismissFullscreenView(_ sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewForZoom
    }
}

class CustomCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoManager: PhotoManager?

    let captureButton: UIButton = {
           let button = UIButton(type: .system)
           button.backgroundColor = UIColor.red
           button.layer.cornerRadius = 35
           button.layer.shadowColor = UIColor.black.cgColor
           button.layer.shadowOpacity = 0.3
           button.layer.shadowOffset = CGSize(width: 0, height: 3)
           button.layer.shadowRadius = 5
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
           
           let imageView = UIImageView(image: UIImage(systemName: "camera.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.contentMode = .scaleAspectFit
           button.addSubview(imageView)
           
           NSLayoutConstraint.activate([
               imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
               imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
               imageView.widthAnchor.constraint(equalToConstant: 50),
               imageView.heightAnchor.constraint(equalToConstant: 50)
           ])
           
           return button
       }()
       
    let retakeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 45
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(retakePhoto), for: .touchUpInside)

        let imageView = UIImageView(image: UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return button
    }()

    let usePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 45
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(usePhoto), for: .touchUpInside)
        
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("KAPAT", for: .normal)
        button.backgroundColor = UIColor(red: 120 / 255, green: 120 / 255, blue: 120 / 255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    var capturedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Kamera bulunamadı")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            print("Kameraya erişilemedi: \(error)")
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(photoOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        setupUI()
        
        captureSession.startRunning()
    }
    
    func setupUI() {
        view.addSubview(captureButton)
        view.addSubview(retakeButton)
        view.addSubview(usePhotoButton)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            retakeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            retakeButton.widthAnchor.constraint(equalToConstant: 90),
            retakeButton.heightAnchor.constraint(equalToConstant: 90),
            
            usePhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            usePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            usePhotoButton.widthAnchor.constraint(equalToConstant: 90),
            usePhotoButton.heightAnchor.constraint(equalToConstant: 90),

            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func retakePhoto() {
        retakeButton.isHidden = true
        usePhotoButton.isHidden = true
        captureButton.isHidden = false
        captureSession.startRunning()
    }
    
    @objc func usePhoto() {
        if let photo = capturedImage {
            photoManager?.savePhoto(takenPhoto: photo)
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
        capturedImage = image
        
        captureSession.stopRunning()
        captureButton.isHidden = true
        retakeButton.isHidden = false
        usePhotoButton.isHidden = false
    }
}
