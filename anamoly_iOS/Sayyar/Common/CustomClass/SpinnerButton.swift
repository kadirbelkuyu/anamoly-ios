//
//  SpinnerButton.swift
//  Sayyar
//
//  Created by Atri Patel on 02/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SSSpinnerButton

class SpinnerButton: SSSpinnerButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let title = self.titleLabel?.text
        if (title != nil) {
            self.setTitle(NSLocalizedString(title!, comment: title!), for: .normal)
        }
        self.backgroundColor = SettingList.button_color
        self.setTitleColor(SettingList.button_text_color, for: .normal)
        self.adjustsImageWhenHighlighted    = false
        self.adjustsImageWhenDisabled       = false
    }
    
    func startLoading(){
        self.startAnimate(spinnerType: .lineSpinFade, spinnercolor: .white, spinnerSize: 20, complete: nil)
        self.isUserInteractionEnabled = false
    }
    
    func endLoading(){
        self.stopAnimate { [weak self] () in
            guard let `self` = self else {return}
            self.isUserInteractionEnabled = true
        }
    }
    
}
