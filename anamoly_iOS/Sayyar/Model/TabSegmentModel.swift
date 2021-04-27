//
//  TabSegmentModel.swift
//  Sayyar
//
//  Created by Atri Patel on 30/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TabSegmentModel: NSObject {
    
    var tag_name_ar : String!   = ""
    var tag_name_de : String!   = ""
    var tag_name_en : String!   = ""
    var tag_name_nl : String!   = ""
    var tag_name_tr : String!   = ""
    var tag_ref     : Int       = 0
    var isSelected  : Bool!     = false
    
    init(aDict : JSON) {
        tag_name_ar = aDict["tag_name_ar"].stringValue
        tag_name_de = aDict["tag_name_de"].stringValue
        tag_name_en = aDict["tag_name_en"].stringValue
        tag_name_nl = aDict["tag_name_nl"].stringValue
        tag_name_tr = aDict["tag_name_tr"].stringValue
        tag_ref     = aDict["tag_ref"].intValue
    }

}
