//
//  UIApplication+Helper.swift
//  CustomCameraOverlay
//
//  Created by apple on 12/08/23.
//

import UIKit

extension UIApplication {
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = scene.delegate as? SceneDelegate else { return nil }
        return sceneDelegate.window
    }
    
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
