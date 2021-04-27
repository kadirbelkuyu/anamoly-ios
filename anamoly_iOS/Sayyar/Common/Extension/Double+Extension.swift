//
//  Double+Extension.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var twoDigitsString : String {
        return String(format:"%.2f", self)
    }
    
}
