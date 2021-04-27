//
//  HomeProduct.swift
//  Sayyar
//
//  Created by Prem Parmar on 13/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeProduct: NSObject {

    var tag_name_nl : String    = ""
    var tag_name_en : String    = ""
    var tag_name_ar : String    = ""
    var banners     : [Banner]  = []
    var product     : [Product] = []
    
    init(aDict : JSON) {
        
        tag_name_nl = aDict["tag_name_nl"].stringValue
        tag_name_en = aDict["tag_name_en"].stringValue
        tag_name_ar = aDict["tag_name_ar"].stringValue
        for object in aDict["banners"].arrayValue {
            banners.append(Banner.init(aDict: object))
        }
        for object in aDict["products"].arrayValue {
            if object["products"].arrayValue.count > 0 || object["items"].arrayValue.count > 0 {
                product.append(Product.init(aDict: object))
            }
        }
        
    }
    
}

class Banner : NSObject {
    
    var tag_ids         : Int       = 0
    var modified_at     : String    = ""
    var sub_cat_ids     : String    = ""
    var modified_by     : Int       = 0
    var banner_image    : URL!      = URL(string: "")
    var banner_id       : Int       = 0
    var banner_title_en : String    = ""
    var created_at      : String    = ""
    var banner_title_nl : String    = ""
    var banner_title_ar : String    = ""
    var created_by      : Int       = 0
    var draft           : Int       = 0
    
    init(aDict : JSON) {
        
        tag_ids         = aDict["tag_ids"].intValue
        modified_at     = aDict["modified_at"].stringValue
        sub_cat_ids     = aDict["sub_cat_ids"].stringValue
        modified_by     = aDict["modified_by"].intValue
        banner_image    = URL(string: Banner_URL_Prefix + aDict["banner_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        banner_id       = aDict["banner_id"].intValue
        banner_title_en = aDict["banner_title_en"].stringValue
        created_at      = aDict["created_at"].stringValue
        banner_title_nl = aDict["banner_title_nl"].stringValue
        banner_title_ar = aDict["banner_title_ar"].stringValue
        created_by      = aDict["created_by"].intValue
        draft           = aDict["draft"].intValue
        
        
    }
    
}

class Product : NSObject {
    
    var sub_cat_name_ar     : String!       = ""
    var sub_cat_name_de     : String!       = ""
    var sub_cat_name_en     : String!       = ""
    var sub_cat_name_nl     : String!       = ""
    var sub_cat_name_tr     : String!       = ""
    var category_id         : Int!          = 0
    var sub_category_id     : Int!          = 0
    var product_group_id    : Int!          = 0
    var group_name_ar       : String!       = ""
    var group_name_de       : String!       = ""
    var group_name_en       : String!       = ""
    var group_name_nl       : String!       = ""
    var group_name_tr       : String!       = ""
    var created_at          : Int!          = 0
    var modified_at         : Int!          = 0
    var created_by          : Int!          = 0
    var modified_by         : String!       = ""
    var draft               : String!       = ""
    var cat_name_ar         : String!       = ""
    var cat_name_de         : String!       = ""
    var cat_name_en         : String!       = ""
    var cat_name_nl         : String!       = ""
    var cat_name_tr         : String!       = ""
    var products            : [Products]    = []
    var isSelected          : Bool!         = false
    var effected_price      : Double!       = 0
    
    init(aDict : JSON) {
        
        sub_cat_name_ar     = aDict["sub_cat_name_ar"].stringValue
        sub_cat_name_de     = aDict["sub_cat_name_de"].stringValue
        sub_cat_name_en     = aDict["sub_cat_name_en"].stringValue
        sub_cat_name_nl     = aDict["sub_cat_name_nl"].stringValue
        sub_cat_name_tr     = aDict["sub_cat_name_tr"].stringValue
        category_id         = aDict["category_id"].intValue
        sub_category_id     = aDict["sub_category_id"].intValue
        product_group_id    = aDict["product_group_id"].intValue
        group_name_ar       = aDict["group_name_ar"].stringValue
        group_name_de       = aDict["group_name_de"].stringValue
        group_name_en       = aDict["group_name_en"].stringValue
        group_name_nl       = aDict["group_name_nl"].stringValue
        group_name_tr       = aDict["group_name_tr"].stringValue
        created_at          = aDict["created_at"].intValue
        modified_at         = aDict["modified_at"].intValue
        created_by          = aDict["created_by"].intValue
        modified_by         = aDict["modified_by"].stringValue
        draft               = aDict["draft"].stringValue
        cat_name_ar         = aDict["cat_name_ar"].stringValue
        cat_name_de         = aDict["cat_name_de"].stringValue
        cat_name_en         = aDict["cat_name_en"].stringValue
        cat_name_nl         = aDict["cat_name_nl"].stringValue
        cat_name_tr         = aDict["cat_name_tr"].stringValue
        effected_price      = aDict["effected_price"].doubleValue
        for obejct in aDict["products"].arrayValue {
            products.append(Products.init(aDict: obejct))
        }
        for obejct in aDict["items"].arrayValue {
            products.append(Products.init(aDict: obejct))
        }
        
    }
    
}

class Products : NSObject {
    
    var category_id         : Int           = 0
    var unit                : String        = ""
    var created_at          : String        = ""
    var price_note          : String        = ""
    var discount_type       : String        = ""
    var modified_by         : Int           = 0
    var product_tags        : String        = ""
    var in_stock            : Int           = 0
    var is_new              : Int           = 0
    var sub_category_id     : Int           = 0
    var qty                 : Int!          = 0
    var product_group_id    : Int           = 0
    var created_by          : String        = ""
    var price               : Double        = 0
    var discount            : Int           = 0
    var product_desc_ar     : String!       = ""
    var product_desc_de     : String!       = ""
    var product_desc_en     : String!       = ""
    var product_desc_nl     : String!       = ""
    var product_desc_tr     : String!       = ""
    var draft               : Int           = 0
    var product_image       : URL!          = URL(string: "")
    var product_image_small : URL!          = URL(string: "")
    var product_extra_ar    : String!       = ""
    var product_extra_de    : String!       = ""
    var product_extra_en    : String!       = ""
    var product_extra_nl    : String!       = ""
    var product_extra_tr    : String!       = ""
    var product_name_ar     : String!       = ""
    var product_name_de     : String!       = ""
    var product_name_en     : String!       = ""
    var product_name_nl     : String!       = ""
    var product_name_tr     : String!       = ""
    var group_name_ar       : String!       = ""
    var group_name_de       : String!       = ""
    var group_name_en       : String!       = ""
    var group_name_nl       : String!       = ""
    var group_name_tr       : String!       = ""
    var unit_value          : Int           = 0
    var product_ingredients : Int           = 0
    var group_id            : Int           = 0
    var product_id          : Int           = 0
    var modified_at         : String        = ""
    var level               : Int           = 0
    
    var product_barcode     : String!       = ""
    var offer_type          : String!       = ""
    var unit_ar             : String!       = ""
    var unit_de             : String!       = ""
    var unit_en             : String!       = ""
    var unit_tr             : String!       = ""
    var price_vat_exclude   : Double!       = 0
    var product_offer_id    : Int!          = 0
    var product_discount_id : Int!          = 0
    var cart_qty            : Int!          = 0
    var number_of_products  : Int!          = 0
    var is_express          : Bool!         = false
    var offer_discount      : Double!       = 0
    var vat                 : Int!          = 0
    var effected_price      : Double!       = 0
    var user_id             : Int!          = 0
    var cart_id             : Int!          = 0
    
    var ingredients         : [Ingredients] = []
    var images              : [Images]      = []
    var isCartOpen          : Bool!         = false
    
    init(aDict : JSON) {
        
        category_id         = aDict["category_id"].intValue
        unit                = aDict["unit"].stringValue
        product_name_nl     = aDict["product_name_nl"].stringValue
        created_at          = aDict["created_at"].stringValue
        price_note          = aDict["price_note"].stringValue
        discount_type       = aDict["discount_type"].stringValue
        modified_by         = aDict["modified_by"].intValue
        product_tags        = aDict["product_tags"].stringValue
        in_stock            = aDict["in_stock"].intValue
        is_new              = aDict["is_new"].intValue
        sub_category_id     = aDict["sub_category_id"].intValue
        qty                 = aDict["qty"].intValue
        group_name_nl       = aDict["group_name_nl"].stringValue
        product_group_id    = aDict["product_group_id"].intValue
        created_by          = aDict["created_by"].stringValue
        price               = aDict["price"].doubleValue
        discount            = aDict["discount"].intValue
        product_desc_ar     = aDict["product_desc_ar"].stringValue
        product_desc_de     = aDict["product_desc_de"].stringValue
        product_desc_en     = aDict["product_desc_en"].stringValue
        product_desc_nl     = aDict["product_desc_nl"].stringValue
        product_desc_tr     = aDict["product_desc_tr"].stringValue
        draft               = aDict["draft"].intValue
        product_image       = URL(string: Product_URL_Prefix + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_image_small = URL(string: Product_URL_Prefix_Small + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_extra_ar    = aDict["product_extra_ar"].stringValue
        product_name_ar     = aDict["product_name_ar"].stringValue
        product_name_de     = aDict["product_name_de"].stringValue
        product_name_en     = aDict["product_name_en"].stringValue
        product_name_nl     = aDict["product_name_nl"].stringValue
        product_name_tr     = aDict["product_name_tr"].stringValue
        product_desc_ar     = aDict["product_desc_ar"].stringValue
        group_name_ar       = aDict["group_name_ar"].stringValue
        group_name_de       = aDict["group_name_de"].stringValue
        group_name_en       = aDict["group_name_en"].stringValue
        group_name_nl       = aDict["group_name_nl"].stringValue
        group_name_tr       = aDict["group_name_tr"].stringValue
        unit_value          = aDict["unit_value"].intValue
        product_ingredients = aDict["product_ingredients"].intValue
        product_extra_nl    = aDict["product_extra_nl"].stringValue
        group_name_ar       = aDict["group_name_ar"].stringValue
        product_extra_ar    = aDict["product_extra_ar"].stringValue
        product_extra_de    = aDict["product_extra_de"].stringValue
        product_extra_en    = aDict["product_extra_en"].stringValue
        product_extra_nl    = aDict["product_extra_nl"].stringValue
        product_extra_tr    = aDict["product_extra_tr"].stringValue
        group_id            = aDict["group_id"].intValue
        product_id          = aDict["product_id"].intValue
        product_name_ar     = aDict["product_name_ar"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        level               = aDict["level"].intValue
        
        product_barcode     = aDict["product_barcode"].stringValue
        offer_type          = aDict["offer_type"].stringValue
        unit_ar             = aDict["unit_ar"].stringValue
        price_vat_exclude   = aDict["price_vat_exclude"].doubleValue
        product_offer_id    = aDict["product_offer_id"].intValue
        product_discount_id = aDict["product_discount_id"].intValue
        cart_qty            = aDict["cart_qty"].intValue
        number_of_products  = aDict["number_of_products"].intValue
        is_express          = aDict["is_express"].intValue == 1 ? true : false
        offer_discount      = aDict["offer_discount"].doubleValue
        vat                 = aDict["vat"].intValue
        unit_ar             = aDict["unit_ar"].stringValue
        unit_de             = aDict["unit_de"].stringValue
        unit_en             = aDict["unit_en"].stringValue
        unit_tr             = aDict["unit_tr"].stringValue
        effected_price      = aDict["effected_price"].doubleValue
        user_id             = aDict["user_id"].intValue
        cart_id             = aDict["cart_id"].intValue
        
        for object in aDict["ingredients"].arrayValue {
            ingredients.append(Ingredients.init(aDict: object))
        }
        for object in aDict["images"].arrayValue {
            images.append(Images.init(aDict: object))
        }
        
    }
    
}

class Ingredients : NSObject {
    
    var ingredient_id       : Int!      = 0
    var ingredient_name_en  : String!   = ""
    var ingredient_name_ar  : String!   = ""
    var ingredient_name_nl  : String!   = ""
    var ingredient_icon     : String!   = ""
    var ingredient_colour   : String!   = ""
    var created_at          : String!   = ""
    var modified_at         : String!   = ""
    var created_by          : Int!      = 0
    var modified_by         : Int!      = 0
    var draft               : Int!      = 0
    
    init(aDict : JSON) {
        
        ingredient_id      = aDict["ingredient_id"].intValue
        ingredient_name_en = aDict["ingredient_name_en"].stringValue
        ingredient_name_ar = aDict["ingredient_name_ar"].stringValue
        ingredient_name_nl = aDict["ingredient_name_nl"].stringValue
        ingredient_icon    = aDict["ingredient_icon"].stringValue
        ingredient_colour  = aDict["ingredient_colour"].stringValue
        created_at         = aDict["created_at"].stringValue
        modified_at        = aDict["modified_at"].stringValue
        created_by         = aDict["created_by"].intValue
        modified_by        = aDict["modified_by"].intValue
        draft              = aDict["draft"].intValue
    }
    
}

class Images : NSObject {
    
    var product_image_id    : Int!      = 0
    var product_id          : Int!      = 0
    var product_image       : URL!      = URL(string: "")
    var product_image_small : URL!      = URL(string: "")
    var sort_order          : Int!      = 0
    var created_at          : String!   = ""
    var modified_at         : String!   = ""
    var created_by          : Int!      = 0
    var modified_by         : Int!      = 0
    var draft               : Int!      = 0
    
    init(aDict : JSON) {
    
        product_image_id    = aDict["product_image_id"].intValue
        product_id          = aDict["product_id"].intValue
        product_image       = URL(string: Product_URL_Prefix + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        product_image_small = URL(string: Product_URL_Prefix_Small + aDict["product_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        sort_order          = aDict["sort_order"].intValue
        created_at          = aDict["created_at"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        created_by          = aDict["created_by"].intValue
        modified_by         = aDict["modified_by"].intValue
        draft               = aDict["draft"].intValue
        
    }
    
}
