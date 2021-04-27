//
//  Font+Extension.swift
//  Burdy
//
//  Created by PCQ183 on 29/07/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import Foundation
import UIKit

struct FontModel {
    
    var font    : UIFont    = UIFont()
    var color   : UIColor   = .clear
    var text    : String    = ""
    
    init(font : UIFont, color : UIColor, text : String) {
        self.font   = font
        self.color  = color
        self.text   = text
    }
    
}

extension UIFont {
    
    class func applyFontWithSize(_ name:String ,_ size: CGFloat) -> UIFont {
        return UIFont(name: name, size: CGFloat(size))!
    }

    struct Tejawal {
        
        static let Black = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-Black", size: size)!
        }
        
        static let Bold = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-Bold", size: size)!
        }
        
        static let ExtraBold = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-ExtraBold", size: size)!
        }
        
        static let ExtraLight = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-ExtraLight", size: size)!
        }
        
        static let Light = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-Light", size: size)!
        }
        
        static let Medium = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-Medium", size: size)!
        }
        
        static let Regular = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Tajawal-Regular", size: size)!
        }
        
    }
   
    struct System {
        
        static let UltraLight = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.ultraLight)
        }
        
        static let Thin = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.thin)
        }
        
        static let Light = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
        }
        
        static let Regular = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
        }
        
        static let Medium = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
        }
        
        static let Semibold = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
        }
        
        static let Bold = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        }
        
        static let Heavy = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
        }
        
        static let Black = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.black)
        }
        
    }
    
}
