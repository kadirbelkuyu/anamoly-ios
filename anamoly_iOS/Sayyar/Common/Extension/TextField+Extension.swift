//
//  TextField+Extension.swift
//  Burdy
//
//  Created by Atri Patel on 23/08/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import UIKit

private var bottomLineColorAssociatedKey : UIColor = .black

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var LeftPadding: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var RightPadding: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    @IBInspectable var bottomLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &bottomLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &bottomLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var bottomLineWidth: CGFloat {
        get {
            return self.bottomLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addBottomBorderWithColor(color: self.bottomLineColor, width: newValue)
            }
        }
    }
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottomBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,width : self.frame.size.width,height: width)
        self.layer.addSublayer(border)
    }
    
    func removePreviouslyAddedLayer(name : String) {
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach {
                if $0.name == name {
                    $0.removeFromSuperlayer()
                }
            }
        }
    }
    func setLocalise(){
        self.placeholder = NSLocalizedString(self.placeholder ?? "", comment: self.placeholder ?? "")
    }
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    //Max Length
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
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
}

@IBDesignable
class ImageTextField: UITextField {

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let textRect = super.leftViewRect(forBounds: bounds)
        return textRect
    }

    @IBInspectable var LeftImage: UIImage? {
        didSet {
            if let image = LeftImage {
                leftViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                leftView = imageView
            }
        }
    }
    
    @IBInspectable var RightImage: UIImage? {
        didSet {
            if let image = RightImage {
                rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
                rightView = imageView
            }
        }
    }

}
class LocalizeTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.placeholder = NSLocalizedString(self.placeholder ?? "", comment: self.placeholder ?? "")
    }
}
