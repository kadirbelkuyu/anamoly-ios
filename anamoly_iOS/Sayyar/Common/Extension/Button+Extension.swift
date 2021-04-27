//
//  Button+Extension.swift
//  Burdy
//
//  Created by PCQ183 on 29/07/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setLocalise() {
        let title = self.titleLabel?.text
        if (title != nil) {
            self.setTitle(NSLocalizedString(title!, comment: title!), for: .normal)
        //   self.setTitle(NSLocalizedString(title!, comment: title!), for: .selected)
        }
    }
    
    var isDisableWithAlpha : Bool {
        get {
            return true
        }
        set {
            if newValue == true {
                self.isEnabled = false
                self.alpha = 0.5
            }else{
                self.isEnabled = true
                self.alpha = 1.0
            }
        }
        
    }
    
}

class LocalizableButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        let title = self.titleLabel?.text
        if (title != nil) {
            self.setTitle(NSLocalizedString(title!, comment: title!), for: .normal)
        }
        self.backgroundColor = SettingList.button_color
        self.setTitleColor(SettingList.button_text_color, for: .normal)
        self.adjustsImageWhenHighlighted    = false
        self.adjustsImageWhenDisabled       = false
    }
    
}

class LocalizableButtonTwo: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        let title = self.titleLabel?.text
        if (title != nil) {
            self.setTitle(NSLocalizedString(title!, comment: title!), for: .normal)
        }
        self.backgroundColor = SettingList.second_button_color
        self.setTitleColor(SettingList.second_button_text_color, for: .normal)
        self.adjustsImageWhenHighlighted    = false
        self.adjustsImageWhenDisabled       = false
    }
    
}

class LocalizeButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        let title = self.titleLabel?.text
        if (title != nil) {
            self.setTitle(NSLocalizedString(title!, comment: title!), for: .normal)
        }
    }
}
