//
//  ActionButton.swift
//  CustomCameraOverlay
//
//  Created by apple on 13/08/23.
//

import UIKit

class ActionButton: UIButton {
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 1 : 0.3
        }
    }
}
