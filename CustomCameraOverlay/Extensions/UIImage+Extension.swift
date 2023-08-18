//
//  UIImage+Extension.swift
//  CustomCameraOverlay
//
//  Created by Admin on 14/08/23.
//

import UIKit.UIImage

extension UIImage {
    
    func writeToPhotoAlbum() {
        
        UIImageWriteToSavedPhotosAlbum(
            self,
            self,
            nil,
            nil
        )
    }
}
