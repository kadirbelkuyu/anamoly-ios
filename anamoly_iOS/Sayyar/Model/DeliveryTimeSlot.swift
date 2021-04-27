//
//  DeliveryTimeSlot.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class DeliveryTimeSlot: NSObject {

    var date        : String!   = ""
    var from_time   : String!   = ""
    var to_time     : String!   = ""
    var isSelected  : Bool!     = false
    
    init(aDict : JSON) {
        date        = aDict["date"].stringValue
        from_time   = aDict["from_time"].stringValue
        to_time     = aDict["to_time"].stringValue
    }
    
}
