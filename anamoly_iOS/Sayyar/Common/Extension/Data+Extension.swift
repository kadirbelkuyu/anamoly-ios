//
//  Data+Extension.swift
//  Sayyar
//
//  Created by Atri Patel on 22/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

extension Data {
    
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    
}
