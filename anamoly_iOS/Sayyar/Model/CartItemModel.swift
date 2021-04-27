//
//  CartItemModel.swift
//  Sayyar
//
//  Created by Atri Patel on 21/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartItemProducts : NSObject {
    
    var effected_price  : Double!           = 0
    var cartItemModel   : [CartItemModel]   = []
    
    init(aDict : JSON) {
        
        effected_price = aDict["effected_price"].doubleValue
        for object in aDict["items"].arrayValue {
            cartItemModel.append(CartItemModel.init(aDict: object))
        }
    }
    
}

class CartItemModel: NSObject {
    
    var cart_id             : Int!      = 0
    var created_at          : String!   = ""
    var created_by          : String!   = ""
    var discount            : Int!      = 0
    var discount_type       : String!   = ""
    var draft               : Int!      = 0
    var effected_price      : Double!   = 0
    var in_stock            : Int!      = 0
    var is_new              : String!   = ""
    var modified_at         : String!   = ""
    var modified_by         : String!   = ""
    var number_of_products  : String!   = ""
    var offer_discount      : String!   = ""
    var offer_type          : String!   = ""
    var price               : Double!   = 0
    var price_note          : String!   = ""
    var price_vat_exclude   : Double!   = 0
    var product_discount_id : String!   = ""
    var product_id          : Int!      = 0
    var product_image       : URL!      = URL(string: "")
    var product_image_small : URL!      = URL(string: "")
    var product_name_ar     : String!   = ""
    var product_name_en     : String!   = ""
    var product_name_nl     : String!   = ""
    var product_offer_id    : String!   = ""
    var qty                 : Int!      = 0
    var unit                : String!   = ""
    var unit_ar             : String!   = ""
    var unit_en             : String!   = ""
    var unit_value          : Int!      = 0
    var user_id             : Int!      = 0
    var vat                 : Int!      = 0
    
    init(aDict : JSON) {
        
        cart_id             = aDict["cart_id"].intValue
        created_at          = aDict["created_at"].stringValue
        created_by          = aDict["created_by"].stringValue
        discount            = aDict["discount"].intValue
        discount_type       = aDict["discount_type"].stringValue
        draft               = aDict["draft"].intValue
        effected_price      = aDict["effected_price"].doubleValue
        in_stock            = aDict["in_stock"].intValue
        is_new              = aDict["is_new"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        modified_by         = aDict["modified_by"].stringValue
        number_of_products  = aDict["number_of_products"].stringValue
        offer_discount      = aDict["offer_discount"].stringValue
        offer_type          = aDict["offer_type"].stringValue
        price               = aDict["price"].doubleValue
        price_note          = aDict["price_note"].stringValue
        price_vat_exclude   = aDict["price_vat_exclude"].doubleValue
        product_discount_id = aDict["product_discount_id"].stringValue
        product_id          = aDict["product_id"].intValue
        product_image       = URL(string: Product_URL_Prefix + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_image_small = URL(string: Product_URL_Prefix_Small + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_name_ar     = aDict["product_name_ar"].stringValue
        product_name_en     = aDict["product_name_en"].stringValue
        product_name_nl     = aDict["product_name_nl"].stringValue
        product_offer_id    = aDict["product_offer_id"].stringValue
        qty                 = aDict["qty"].intValue
        unit                = aDict["unit"].stringValue
        unit_ar             = aDict["unit_ar"].stringValue
        unit_en             = aDict["unit_en"].stringValue
        unit_value          = aDict["unit_value"].intValue
        user_id             = aDict["user_id"].intValue
        vat                 = aDict["vat"].intValue
        
    }
    
}
