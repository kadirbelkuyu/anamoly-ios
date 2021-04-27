//
//  SettingListModel.swift
//  Sayyar
//
//  Created by Atri Patel on 29/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingListModel: NSObject {
    
    var app_contact                 : String!   = ""
    var app_email                   : String!   = ""
    var app_whatsapp                : String!   = ""
    var button_color                : UIColor!  = .clear
    var button_text_color           : UIColor!  = .clear
    var copyright                   : String!   = ""
    var currency                    : String!   = ""
    var currency_symbol             : String!   = ""
    var decorative_text_one         : String!   = ""
    var decorative_text_two         : String!   = ""
    var default_text_color          : UIColor!  = .clear
    var enable_code_payment         : Bool!     = false
    var enable_ideal_payment        : Bool!     = false
    var express_delivery_charge     : Double!   = 0
    var express_delivery_time       : Double!   = 0
    var gateway_charges             : Double!   = 0
    var header_color                : UIColor!  = .clear
    var header_logo                 : URL!      = URL(string: "")
    var header_text_color           : UIColor!  = .clear
    var info_box_bg                 : UIColor!  = .clear
    var login_top_image             : URL!      = URL(string: "")
    var name                        : String!   = ""
    var second_button_color         : UIColor!  = .clear
    var second_button_text_color    : UIColor!  = .clear
    var stock_alert                 : Double!   = 0
    var website                     : URL!      = URL(string: "")

    override init() {
    }
    
    init(aDict : JSON) {
        app_contact                 = aDict["app_contact"].stringValue
        app_email                   = aDict["app_email"].stringValue
        app_whatsapp                = aDict["app_whatsapp"].stringValue
        button_color                = UIColor.init(hexString:  aDict["button_color"].stringValue)
        button_text_color           = UIColor.init(hexString:  aDict["button_text_color"].stringValue)
        copyright                   = aDict["copyright"].stringValue
        currency                    = aDict["currency"].stringValue
        currency_symbol             = aDict["currency_symbol"].stringValue
        decorative_text_one         = aDict["decorative_text_one"].stringValue
        decorative_text_two         = aDict["decorative_text_two"].stringValue
        default_text_color          = UIColor.init(hexString:  aDict["default_text_color"].stringValue)
        enable_code_payment         = aDict["enable_code_payment"].stringValue.lowercased() == "yes" ? true : false
        enable_ideal_payment        = aDict["enable_ideal_payment"].stringValue.lowercased() == "yes" ? true : false
        express_delivery_charge     = aDict["express_delivery_charge"].doubleValue
        express_delivery_time       = aDict["express_delivery_time"].doubleValue
        gateway_charges             = aDict["gateway_charges"].doubleValue
        header_color                = UIColor.init(hexString:  aDict["header_color"].stringValue)
        header_logo                 = URL(string: Settings_URL_Prefix + aDict["header_logo"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        header_text_color           = UIColor.init(hexString:  aDict["header_text_color"].stringValue)
        info_box_bg                 = UIColor.init(hexString:  aDict["info_box_bg"].stringValue)
        login_top_image             = URL(string: Settings_URL_Prefix + aDict["login_top_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        name                        = aDict["name"].stringValue
        second_button_color         = UIColor.init(hexString:  aDict["second_button_color"].stringValue)
        second_button_text_color    = UIColor.init(hexString:  aDict["second_button_text_color"].stringValue)
        stock_alert                 = aDict["stock_alert"].doubleValue
        website                     = URL(string: aDict["website"].stringValue)
    }
    
}
