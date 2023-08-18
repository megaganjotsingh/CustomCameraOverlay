//
//  Looader.swift
//  BugIdentifierInsectId
//
//  Created by apple on 11/08/23.
//

import Foundation
import UIKit.UIView

class LoaderView {
    static let shared = LoaderView()
    
    private init() { }
    
    private let backgroundColor: UIColor = UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
    
    private let fade = 0.1
    
    private lazy var backgroundView: UIView = {
        var view = UIView()
        let screen: CGRect = UIScreen.main.bounds
        view.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        view.alpha = 0.0
        view.backgroundColor = backgroundColor.withAlphaComponent(0.5)
        return view
    }()

    private lazy var indicator: UIView = {
        var view = UIView()
        let screen: CGRect = UIScreen.main.bounds
        var side = screen.width / 4
        var x = (screen.width / 2) - (side / 2)
        var y = (screen.height / 2) - (side / 2)
        view.frame = CGRect(x: x, y: y, width: side, height: side)
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 10
        view.alpha = 0.0
        view.tag = 1
        let image = UIImage(named: "loader.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: side / 4, y: side / 4, width: side / 2, height: side / 2)
        view.addSubview(imageView)
        return view
    }()

    private var animation: CABasicAnimation = {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = 2.0
        rotateAnimation.repeatCount = Float.infinity
        return rotateAnimation
    }()

    func start() {
        if let window: UIWindow = UIApplication.shared.window {
            var found: Bool = false
            for subview in window.subviews {
                if subview.tag == 1 {
                    found = true
                }
            }
            if !found {
                for subview in indicator.subviews {
                    subview.layer.add(animation, forKey: nil)
                }
                window.addSubview(backgroundView)
                window.addSubview(indicator)
                UIView.animate(withDuration: fade, animations: {
                    self.backgroundView.alpha = 1
                    self.indicator.alpha = 1.0
                })
            }
        }
    }

    func stop () {
        UIView.animate(withDuration: fade, animations: {
            self.indicator.alpha = 0.0
        }, completion: { (value: Bool) in
            self.backgroundView.removeFromSuperview()
            self.indicator.removeFromSuperview()
            for subview in self.indicator.subviews {
                subview.layer.removeAllAnimations()
            }
        })
    }
}
