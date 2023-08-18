//
//  PhotoCapture.swift
//  CustomCameraOverlay
//
//  Created by Admin on 13/08/23.
//

import Foundation
import AVFoundation
import UIKit

protocol PhotoCapture: AVCapturePhotoCaptureDelegate where Self: UIViewController  {

    var captureSession: AVCaptureSession? { get set }
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer? { get set }
    var photoOutput: AVCapturePhotoOutput? { get set }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    )
}

extension PhotoCapture {

    func capturePhoto() {

        let photosettings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: photosettings, delegate: self)
    }

    func prepareForPhotoCapture(onView: UIView?, cameraPosition: AVCaptureDevice.Position = .unspecified) {
        
        DispatchQueue.global().async {
            self.intilizePhotoCapture(onView, cameraPosition: cameraPosition)
        }
    }

    func startSession() {

        DispatchQueue.global().sync {
            captureSession?.startRunning()
        }
    }

    func stopSession() {
        
        DispatchQueue.global().async {
            self.captureSession?.stopRunning()
        }
    }
}

extension PhotoCapture {

    func processPhoto( photo: AVCapturePhoto) -> UIImage? {

        if let imageData = photo.fileDataRepresentation() {
            return UIImage(data: imageData)
        }
        return nil
    }
}

extension PhotoCapture {

    fileprivate func intilizePhotoCapture(_ onView: UIView?, cameraPosition: AVCaptureDevice.Position) {

        captureSession = AVCaptureSession()
        photoOutput = AVCapturePhotoOutput()
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        cameraPreviewLayer!.videoGravity = .resizeAspectFill

        setupDevice(cameraPosition: cameraPosition)
        setupPreview(onView)
        startSession()
    }

    private func setupDevice(cameraPosition: AVCaptureDevice.Position) {

        if let camera = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: cameraPosition
        ).devices.first {
            setupInputOutput(camera: camera)
        } else {
            print("Failed to Find Camera")
        }
    }

    private func setupInputOutput(camera: AVCaptureDevice) {

        do
        {
            let captureDeviceInput = try AVCaptureDeviceInput(device: camera)
            captureSession?.sessionPreset = AVCaptureSession.Preset.photo
            captureSession?.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
                completionHandler: nil
            )
            if let output = photoOutput {
                captureSession?.addOutput(output)
            }
        }
        catch
        {
            print(error)
        }
    }

    private func setupPreview(_ onView: UIView?) {

        guard let previewLayer = cameraPreviewLayer else { return }
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.setupPreview(onView)
            }
            return
        }

        if let view = onView {
            view.layer.addSublayer(previewLayer)
            cameraPreviewLayer?.frame = view.frame
        } else {
            view.layer.addSublayer(previewLayer)
            cameraPreviewLayer?.frame = view.frame
        }
    }
}
