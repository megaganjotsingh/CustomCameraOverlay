//
//  ResizeImageHelper.swift
//  CustomCameraOverlay
//
//  Created by apple on 12/08/23.
//

import UIKit

extension UIImage {
    
    public enum Error: Swift.Error {
        
        case cgImageCreationFailed
        case imageResizingFailed
    }
    
    public func resized(maxPixels: Int) throws -> UIImage {
        
        let maxPixels = CGFloat(maxPixels)
        let pixelCount = self.size.width * self.size.height
        if pixelCount > maxPixels {
            let sizeRatio = sqrt(maxPixels / pixelCount)
            let newWidth = self.size.width * sizeRatio
            let newHeight = self.size.height * sizeRatio
            let newSize = CGSize(width: newWidth,
                                 height: newHeight)
            return try self.resizeWithUIKit(to: newSize)
        }
        return self
    }
    
    private func resizeWithUIKit(to newSize: CGSize) throws -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize,
                                               true,
                                               1.0)
        self.draw(in: .init(origin: .zero,
                            size: newSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        else { throw Error.imageResizingFailed }
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
