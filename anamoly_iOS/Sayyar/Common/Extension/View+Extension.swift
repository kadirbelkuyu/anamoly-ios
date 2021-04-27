//
//  View+Extension.swift
//  Burdy
//
//  Created by PCQ183 on 01/08/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var fixRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var roundBottomRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var roundTopRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }

}

extension UIView {
    
    //MARK: - Top Round Croner
    func topRoundCorner(radius: CGFloat) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //MARK: - Bottom Round Croner
    func bottomRoundCorner(radius: CGFloat) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    //MARK: - Drop Shadow
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true){
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
    }
    
    //MARK: - Page Master
    func fitToSelf(childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["childView": childView]
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat : "H:|[childView]|",
                options          : [],
                metrics          : nil,
                views            : bindings
        ))
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat : "V:|[childView]|",
                options          : [],
                metrics          : nil,
                views            : bindings
        ))
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
    enum GradientOrientation {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        case topBottom
        case bottomTop
        var startPoint : CGPoint {
            return points.startPoint
        }
        var endPoint : CGPoint {
            return points.endPoint
        }
        var points : GradientPoints {
            get {
                switch(self) {
                case .topRightBottomLeft:
                    return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
                case .topLeftBottomRight:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
                case .horizontal:
                    return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
                case .vertical:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
                case .topBottom:
                    return (CGPoint(x: 0.5, y: 0.6), CGPoint(x: 0.5,y: 1.0))
                case .bottomTop:
                    return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5,y: 0.4))
                }
            }
        }
    }
    
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
    
}

class NavigationColorView : UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = SettingList.header_color
    }
    
}

class LightBackgroundView : UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = SettingList.header_color.withAlphaComponent(0.25)
    }
    
}
