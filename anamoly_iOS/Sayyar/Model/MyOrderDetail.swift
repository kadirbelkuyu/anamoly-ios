//
//  MyOrderDetail.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyOrderDetail: NSObject {

    var order_id            : Int!                  = 0
    var order_no            : Int!                  = 0
    var order_date          : String!               = ""
    var user_id             : Int!                  = 0
    var delivery_date       : String!               = ""
    var delivery_time       : String!               = ""
    var delivery_time_end   : String!               = ""
    var coupon_code         : String!               = ""
    var discount            : Double!               = 0
    var discount_type       : Double!               = 0
    var discount_amount     : Double!               = 0
    var order_amount        : Double!               = 0
    var net_amount          : Double!               = 0
    var paid_amount         : Double!               = 0
    var paid_by             : String!               = ""
    var payment_ref         : String!               = ""
    var payment_log         : String!               = ""
    var paid_date           : String!               = ""
    var delivery_amount     : Double!               = 0
    var user_address_id     : Int!                  = 0
    var order_note          : String!               = ""
    var status              : String!               = ""
    var vehicle_id          : Int!                  = 0
    var created_at          : String!               = ""
    var modified_at         : String!               = ""
    var created_by          : String!               = ""
    var modified_by         : String!               = ""
    var draft               : String!               = ""
    var house_no            : String!               = ""
    var add_on_house_no     : String!               = ""
    var postal_code         : String!               = ""
    var street_name         : String!               = ""
    var area                : String!               = ""
    var city                : String!               = ""
    var latitude            : String!               = ""
    var longitude           : String!               = ""
    var user_firstname      : String!               = ""
    var user_lastname       : String!               = ""
    var user_phone          : String!               = ""
    var user_email          : String!               = ""
    var user_company_name   : String!               = ""
    var user_company_id     : Int!                  = 0
    var android_token       : String!               = ""
    var ios_token           : String!               = ""
    var vehicle_no          : String!               = ""
    var vehicle_type        : String!               = ""
    var driver_name         : String!               = ""
    var driver_phone        : String!               = ""
    var gateway_charges     : Double!               = 0
    var items               : [MyOrderDetailItem]   = []
    
    var boy_phone           : String!               = ""
    var is_express          : Bool!                 = false
    var boy_name            : String!               = ""
    var boy_photo           : String!               = ""
    var boy_email           : String!               = ""
    var delivery_boy_id     : Int!                  = 0
    
    init(aDict : JSON) {
        
        order_id            = aDict["order_id"].intValue
        order_no            = aDict["order_no"].intValue
        order_date          = aDict["order_date"].stringValue
        user_id             = aDict["user_id"].intValue
        delivery_date       = aDict["delivery_date"].stringValue
        delivery_time       = aDict["delivery_time"].stringValue
        delivery_time_end   = aDict["delivery_time_end"].stringValue
        coupon_code         = aDict["coupon_code"].stringValue
        discount            = aDict["discount"].doubleValue
        discount_type       = aDict["discount_type"].doubleValue
        discount_amount     = aDict["discount_amount"].doubleValue
        order_amount        = aDict["order_amount"].doubleValue
        net_amount          = aDict["net_amount"].doubleValue
        paid_amount         = aDict["paid_amount"].doubleValue
        paid_by             = aDict["paid_by"].stringValue
        payment_ref         = aDict["payment_ref"].stringValue
        payment_log         = aDict["payment_log"].stringValue
        paid_date           = aDict["paid_date"].stringValue
        delivery_amount     = aDict["delivery_amount"].doubleValue
        user_address_id     = aDict["user_address_id"].intValue
        order_note          = aDict["order_note"].stringValue
        status              = aDict["status"].stringValue
        vehicle_id          = aDict["vehicle_id"].intValue
        created_at          = aDict["created_at"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        created_by          = aDict["created_by"].stringValue
        modified_by         = aDict["modified_by"].stringValue
        draft               = aDict["draft"].stringValue
        house_no            = aDict["house_no"].stringValue
        add_on_house_no     = aDict["add_on_house_no"].stringValue
        postal_code         = aDict["postal_code"].stringValue
        street_name         = aDict["street_name"].stringValue
        area                = aDict["area"].stringValue
        city                = aDict["city"].stringValue
        latitude            = aDict["latitude"].stringValue
        longitude           = aDict["longitude"].stringValue
        user_firstname      = aDict["user_firstname"].stringValue
        user_lastname       = aDict["user_lastname"].stringValue
        user_phone          = aDict["user_phone"].stringValue
        user_email          = aDict["user_email"].stringValue
        user_company_name   = aDict["user_company_name"].stringValue
        user_company_id     = aDict["user_company_id"].intValue
        android_token       = aDict["android_token"].stringValue
        ios_token           = aDict["ios_token"].stringValue
        vehicle_no          = aDict["vehicle_no"].stringValue
        vehicle_type        = aDict["vehicle_type"].stringValue
        driver_name         = aDict["driver_name"].stringValue
        driver_phone        = aDict["driver_phone"].stringValue
        gateway_charges     = aDict["gateway_charges"].doubleValue
        for obejct in aDict["items"].arrayValue {
            items.append(MyOrderDetailItem.init(aDict: obejct))
        }
        
        boy_phone           = aDict["boy_phone"].stringValue
        is_express          = aDict["is_express"].intValue == 1 ? true : false
        boy_name            = aDict["boy_name"].stringValue
        boy_photo           = aDict["boy_photo"].stringValue
        boy_email           = aDict["boy_email"].stringValue
        delivery_boy_id     = aDict["delivery_boy_id"].intValue
    }
    
}

class MyOrderDetailItem : NSObject {
    
    var order_item_id       : Int!      = 0
    var order_id            : Int!      = 0
    var product_id          : Int!      = 0
    var order_qty           : Int!      = 0
    var product_price       : Double!   = 0
    var vat                 : Double!   = 0
    var discount_id         : Int!      = 0
    var discount_amount     : Double!   = 0
    var discount            : Double!   = 0
    var discount_type       : String!   = ""
    var price               : Double!   = 0
    var product_image       : URL!      = URL(string: "")
    var product_image_small : URL!      = URL(string: "")
    var product_name_ar     : String!       = ""
    var product_name_de     : String!       = ""
    var product_name_en     : String!       = ""
    var product_name_nl     : String!       = ""
    var product_name_tr     : String!       = ""
    var unit                : String!   = ""
    var unit_value          : Int!      = 0
    
    var offer_discount      : Double!   = 0
    var offer_id            : Int!      = 0
    var picker_note         : String!   = ""
    var offer_type          : String!   = ""
    var offer_amount        : Double!   = 0
    var unit_ar             : String!   = ""
    var unit_de             : String!   = ""
    var unit_en             : String!   = ""
    var unit_tr             : String!   = ""
    var number_of_products  : Int!      = 0
    
    init(aDict : JSON) {
     
        order_item_id       = aDict["order_item_id"].intValue
        order_id            = aDict["order_id"].intValue
        product_id          = aDict["product_id"].intValue
        order_qty           = aDict["order_qty"].intValue
        product_price       = aDict["product_price"].doubleValue
        vat                 = aDict["vat"].doubleValue
        discount_id         = aDict["discount_id"].intValue
        discount_amount     = aDict["discount_amount"].doubleValue
        discount            = aDict["discount"].doubleValue
        discount_type       = aDict["discount_type"].stringValue
        price               = aDict["price"].doubleValue
        product_image       = URL(string: Product_URL_Prefix + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_image_small = URL(string: Product_URL_Prefix_Small + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_name_ar     = aDict["product_name_ar"].stringValue
        product_name_de     = aDict["product_name_de"].stringValue
        product_name_en     = aDict["product_name_en"].stringValue
        product_name_nl     = aDict["product_name_nl"].stringValue
        product_name_tr     = aDict["product_name_tr"].stringValue
        unit                = aDict["unit"].stringValue
        unit_value          = aDict["unit_value"].intValue
        
        offer_discount      = aDict["offer_discount"].doubleValue
        offer_id            = aDict["offer_id"].intValue
        picker_note         = aDict["picker_note"].stringValue
        offer_type          = aDict["offer_type"].stringValue
        offer_amount        = aDict["offer_amount"].doubleValue
        unit_ar             = aDict["unit_ar"].stringValue
        unit_de             = aDict["unit_de"].stringValue
        unit_en             = aDict["unit_en"].stringValue
        unit_tr             = aDict["unit_tr"].stringValue
        number_of_products  = aDict["number_of_products"].intValue
        
    }
    
}
