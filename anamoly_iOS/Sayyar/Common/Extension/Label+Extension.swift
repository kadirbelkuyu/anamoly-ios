//
//  Label+Extension.swift
//  Burdy
//
//  Created by PCQ183 on 29/07/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
        
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    func getLabelWidth() -> CGFloat {
        var rect: CGRect = self.frame //get frame of label
        rect.size = (self.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: self.font.fontName , size: self.font.pointSize)!]))!
        return rect.width
    }
    
    func getLabelHeight() -> CGFloat {
        var rect: CGRect = self.frame //get frame of label
        rect.size = (self.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: self.font.fontName , size: self.font.pointSize)!]))!
        return rect.height
    }
    func setLocalise(){
        self.text = NSLocalizedString(self.text ?? "", comment: self.text ?? "")
    }
}
class LocalizableLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.text = NSLocalizedString(self.text ?? "", comment: self.text ?? "")
    }
    
}
