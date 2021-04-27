//
//  CouponCodeModel.swift
//  Sayyar
//
//  Created by Atri Patel on 02/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponCodeModel: NSObject {
    
    var max_discount_amount : String!   = ""
    var discount_type       : String!   = ""
    var min_order_amount    : String!   = ""
    var description_en      : String!   = ""
    var modified_by         : String!   = ""
    var coupon_id           : String!   = ""
    var description_nl      : String!   = ""
    var coupon_type         : String!   = ""
    var users               : String!   = ""
    var validity_start      : String!   = ""
    var discount            : String!   = ""
    var multi_usage         : String!   = ""
    var modified_at         : String!   = ""
    var created_by          : String!   = ""
    var description_ar      : String!   = ""
    var created_at          : String!   = ""
    var maximum_usages      : String!   = ""
    var draft               : String!   = ""
    var coupon_code         : String!   = ""
    var validity_end        : String!   = ""
    
    init(aDict : JSON) {
    
        max_discount_amount = aDict["max_discount_amount"].stringValue
        discount_type       = aDict["discount_type"].stringValue
        min_order_amount    = aDict["min_order_amount"].stringValue
        description_en      = aDict["description_en"].stringValue
        modified_by         = aDict["modified_by"].stringValue
        coupon_id           = aDict["coupon_id"].stringValue
        description_nl      = aDict["description_nl"].stringValue
        coupon_type         = aDict["coupon_type"].stringValue
        users               = aDict["users"].stringValue
        validity_start      = aDict["validity_start"].stringValue
        discount            = aDict["discount"].stringValue
        multi_usage         = aDict["multi_usage"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        created_by          = aDict["created_by"].stringValue
        description_ar      = aDict["description_ar"].stringValue
        created_at          = aDict["created_at"].stringValue
        maximum_usages      = aDict["maximum_usages"].stringValue
        draft               = aDict["draft"].stringValue
        coupon_code         = aDict["coupon_code"].stringValue
        validity_end        = aDict["validity_end"].stringValue
    
    }

}
