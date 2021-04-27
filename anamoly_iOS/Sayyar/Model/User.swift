//
//  User.swift
//  Faith Streaming
//
//  Created by Atri Patel on 18/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class User {
    
    var ios_token           : String!       = ""
    var user_image          : URL!          = URL(string: "")
    var req_queue           : Int!          = 0
    var created_at          : String!       = ""
    var user_company_name   : String!       = ""
    var user_firstname      : String!       = ""
    var modified_at         : String!       = ""
    var user_email          : String!       = ""
    var user_lastname       : String!       = ""
    var modified_by         : Int!          = 0
    var user_phone          : String!       = ""
    var android_token       : String!       = ""
    var created_by          : Int!          = 0
    var is_email_verified   : Bool!         = false
    var draft               : String!       = ""
    var verify_token        : String!       = ""
    var user_type_id        : Int!          = 0
    var is_mobile_verified  : Bool!         = false
    var user_company_id     : String!       = ""
    var user_id             : Int!          = 0
    var status              : Int!          = 0
    var family              : Family?
    var settings            : Settings?
    var addresses           : [Addresses]   = []
    var userJson            : String!       = ""
    
    init(aDict : JSON) {
    
        ios_token           = aDict["ios_token"].stringValue
        user_image          = URL(string: Profile_URL_Prefix + aDict["user_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        req_queue           = aDict["req_queue"].intValue
        created_at          = aDict["created_at"].stringValue
        user_company_name   = aDict["user_company_name"].stringValue
        user_firstname      = aDict["user_firstname"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        user_email          = aDict["user_email"].stringValue
        user_lastname       = aDict["user_lastname"].stringValue
        modified_by         = aDict["modified_by"].intValue
        user_phone          = aDict["user_phone"].stringValue
        android_token       = aDict["android_token"].stringValue
        created_by          = aDict["created_by"].intValue
        is_email_verified   = aDict["is_email_verified"].intValue == 1 ? true : false
        draft               = aDict["draft"].stringValue
        verify_token        = aDict["verify_token"].stringValue
        user_type_id        = aDict["user_type_id"].intValue
        is_mobile_verified  = aDict["is_mobile_verified"].intValue == 1 ? true : false
        user_company_id     = aDict["user_company_id"].stringValue
        user_id             = aDict["user_id"].intValue
        status              = aDict["status"].intValue
        family              = Family.init(aDict: aDict["family"])
        settings            = Settings.init(aDict: aDict["settings"])
        for object in aDict["addresses"].arrayValue {
            addresses.append(Addresses.init(aDict: object))
        }
        userJson            = aDict.rawString() ?? ""
    
    }

}

class Family : NSObject {
    
    var created_by      : Int!      = 0
    var no_of_cats      : Int!      = 0
    var user_family_id  : Int!      = 0
    var user_id         : Int!      = 0
    var modified_at     : String!   = ""
    var modified_by     : Int!      = 0
    var created_at      : String!   = ""
    var draft           : Int!      = 0
    var no_of_child     : Int!      = 0
    var no_of_dogs      : Int!      = 0
    var no_of_adults    : Int!      = 0
    
    init(aDict : JSON) {
    
        created_by      = aDict["created_by"].intValue
        no_of_cats      = aDict["no_of_cats"].intValue
        user_family_id  = aDict["user_family_id"].intValue
        user_id         = aDict["user_id"].intValue
        modified_at     = aDict["modified_at"].stringValue
        modified_by     = aDict["modified_by"].intValue
        created_at      = aDict["created_at"].stringValue
        draft           = aDict["draft"].intValue
        no_of_child     = aDict["no_of_child"].intValue
        no_of_dogs      = aDict["no_of_dogs"].intValue
        no_of_adults    = aDict["no_of_adults"].intValue
        
    }
    
}

class Settings : NSObject {
    
    var created_by              : Int!      = 0
    var user_id                 : Int!      = 0
    var user_setting_id         : Int!      = 0
    var modified_at             : String!   = ""
    var modified_by             : Int!      = 0
    var general_emails          : Bool!     = false
    var created_at              : String!   = ""
    var order_notifications     : Bool!     = false
    var order_emails            : Bool!     = false
    var draft                   : Int!      = 0
    var general_notifications   : Bool!     = false
    
    init(aDict : JSON) {
    
        created_by              = aDict["created_by"].intValue
        user_id                 = aDict["user_id"].intValue
        user_setting_id         = aDict["user_setting_id"].intValue
        modified_at             = aDict["modified_at"].stringValue
        modified_by             = aDict["modified_by"].intValue
        general_emails          = aDict["general_emails"].intValue == 1 ? true : false
        created_at              = aDict["created_at"].stringValue
        order_notifications     = aDict["order_notifications"].intValue == 1 ? true : false
        order_emails            = aDict["order_emails"].intValue == 1 ? true : false
        draft                   = aDict["draft"].intValue
        general_notifications   = aDict["general_notifications"].intValue == 1 ? true : false
    
    }
    
}

class Addresses : NSObject {
    
    var street_name     : String!   = ""
    var municipality    : String!   = ""
    var longitude       : String!   = ""
    var add_on_house_no : String!   = ""
    var modified_by     : String!   = ""
    var draft           : String!   = ""
    var created_by      : String!   = ""
    var area            : String!   = ""
    var user_id         : String!   = ""
    var latitude        : String!   = ""
    var postal_code     : String!   = ""
    var modified_at     : String!   = ""
    var city            : String!   = ""
    var created_at      : String!   = ""
    var is_active       : Bool!     = false
    var house_no        : String!   = ""
    var user_address_id : String!   = ""
    var fullAddress     : String {
        return "\(postal_code.uppercased()), \(house_no ?? ""), \(add_on_house_no ?? ""), \(city ?? ""), \(street_name ?? "")"
    }
    
    
    init(aDict : JSON) {
    
        street_name     = aDict["street_name"].stringValue
        municipality    = aDict["municipality"].stringValue
        longitude       = aDict["longitude"].stringValue
        add_on_house_no = aDict["add_on_house_no"].stringValue
        modified_by     = aDict["modified_by"].stringValue
        draft           = aDict["draft"].stringValue
        created_by      = aDict["created_by"].stringValue
        area            = aDict["area"].stringValue
        user_id         = aDict["user_id"].stringValue
        latitude        = aDict["latitude"].stringValue
        postal_code     = aDict["postal_code"].stringValue
        modified_at     = aDict["modified_at"].stringValue
        city            = aDict["city"].stringValue
        created_at      = aDict["created_at"].stringValue
        is_active       = aDict["is_active"].intValue == 1 ? true : false
        house_no        = aDict["house_no"].stringValue
        user_address_id = aDict["user_address_id"].stringValue
        
    }
    
    
    
}
