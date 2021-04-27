//
//  Int+Extension.swift
//  Burdy
//
//  Created by Atri Patel on 13/09/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import UIKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
