//
//  ViewController.swift
//  CustomCameraOverlay
//
//  Created by apple on 11/08/23.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, PhotoCapture {
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayerLeadingConstraint: NSLayoutConstraint!

    var cameraPreviewView: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    var previousButton: ActionButton = {
        let button = ActionButton()
        let image = UIImage(named: "previous")
        button.setImage(image, for: .normal)
        button.isHidden = true
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var nextButton: ActionButton = {
        let button = ActionButton()
        let image = UIImage(named: "next")
        button.setImage(image, for: .normal)
        button.isHidden = true
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
            
    let captureImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let capturedImageView = CapturedImageView()
    var capturedImages: [UIImage] = [] {
        didSet {
            let hideButtons = capturedImages.count != 1
            nextButton.isHidden = hideButtons
            previousButton.isHidden = hideButtons
        }
    }

    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupView()
        prepareForPhotoCapture(onView: cameraPreviewView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        stopSession()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        startSession()
    }

    // MARK: - Actions
    
    @objc func captureImage(_ sender: UIButton?) {
        if capturedImages.count == 2 {
            // delete old images for a new session
            showAlertForDeletingOldImages()
        } else {
            capturePhoto()
        }
    }
    
    @objc func next(_ sender: UIButton?) {
        
        nextButton.isSelected = true
        previousButton.isSelected = false
        updateConstraint()
    }
    
    @objc func previous(_ sender: UIButton?) {
        
        nextButton.isSelected = false
        previousButton.isSelected = true
        updateConstraint()
    }
    
    // MARK: - Helper Functions
    
    func showAlertForImageSaved() {
        
        let alert = UIAlertController(title: "Images saved to gallery", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func showAlertForDeletingOldImages() {
        
        let alert = UIAlertController(title: "Create new session", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.createNewSession()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
    
    func createNewSession() {
        
        capturedImages = []
        capturedImageView.image = nil
    }
    
    // MARK: - PhotoCapture Delegate Method
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let image = processPhoto(photo: photo) else { return }
        capturedImageView.image = image
        capturedImages.append(image)
        if capturedImages.count == 2 {
            // save these pair to gallery
            let resizedImages = capturedImages.compactMap { try? $0.resized(maxPixels: 12000000) }
            resizedImages.forEach { $0.writeToPhotoAlbum() }
            showAlertForImageSaved()
        }
    }
}
