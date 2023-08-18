//
//  ViewController.swift
//  CustomCameraOverlay
//
//  Created by apple on 11/08/23.
//

import UIKit
import AVFoundation

extension ViewController {
    // MARK: - View Setup
    func setupView() {
        view.backgroundColor = .black
        view.addSubviews(cameraPreviewView, captureImageButton, capturedImageView, previousButton, nextButton)
        
        previewLayerLeadingConstraint =             capturedImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -(UIScreen.main.bounds.width))
        
        NSLayoutConstraint.activate([
            cameraPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            captureImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            captureImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            captureImageButton.widthAnchor.constraint(equalToConstant: 50),
            captureImageButton.heightAnchor.constraint(equalToConstant: 50),
            
            capturedImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            capturedImageView.topAnchor.constraint(equalTo: view.topAnchor),
            previewLayerLeadingConstraint,
            capturedImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            previousButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            previousButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        
        captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        
        previousButton.addTarget(self, action: #selector(previous(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
    }
    
    func updateConstraint() {
        previewLayerLeadingConstraint.constant = nextButton.isSelected ? -UIScreen.main.bounds.width + 120 : UIScreen.main.bounds.width - 120
        view.layoutIfNeeded()
    }
    
    // MARK: - Permissions
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
          case .authorized:
            return
          case .denied:
            abort()
          case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
              if(!authorized){
                abort()
              }
            })
          case .restricted:
            abort()
          @unknown default:
            fatalError()
        }
    }
}
