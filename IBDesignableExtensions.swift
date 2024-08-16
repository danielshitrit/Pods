//
//  ShadowViewButtonLabel.swift
//  CarWash2
//
//  Created by Mac User on 11/23/18.
//  Copyright © 2018 Mac User. All rights reserved.
//

import Foundation
import UIKit

class CircularView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
    }
}

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
    }
}

class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
    }
}


@IBDesignable
class IBDesignableView: UIView {
}

extension UIView {
    
    @IBInspectable
    var ibcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var maskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable
    var bottomMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable
    var topMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable
    var leftMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable
    var rightMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    func addBezierShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        
        //        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale =  UIScreen.main.scale
    }
    
    func addNormalShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3
    }
    
    @IBInspectable var addBezierShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addBezierShadowMethod()
            }
        }
    }
    
    @IBInspectable var addNormalShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addNormalShadowMethod()
            }
        }
    }
    
    
//    @IBInspectable var semanticFlipped: Bool {
//        get {
//            return !transform.isIdentity
//        }
//        set {
//            if newValue == true {
//                self.semanticFlipView()
//            }
//        }
//    }
//    
//    func semanticFlipView() {
//        self.transform = CGAffineTransform(scaleX: -1, y: 1)
//    }
    
    func addColorShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.4
        layer.shadowColor = backgroundColor?.cgColor
//        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
    }
    
    func addSmallColorShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
//        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
    }
    
    @IBInspectable var addColorShadow: Bool {
        get {
            return layer.shadowColor == backgroundColor?.cgColor
        }
        set {
            if newValue == true {
                self.addColorShadowMethod()
            }
        }
    }
    
    @IBInspectable var addSmallColorShadow: Bool {
        get {
            return layer.shadowColor == backgroundColor?.cgColor
        }
        set {
            if newValue == true {
                self.addSmallColorShadowMethod()
            }
        }
    }
}

extension UIImageView {
    @IBInspectable var alwaysTemplateRendering: Bool {
        get {
            guard let renderingMode = image?.renderingMode else { return false }
            return renderingMode == .alwaysTemplate
        }
        set {
            if newValue == true {
                image = image?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
}


extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
