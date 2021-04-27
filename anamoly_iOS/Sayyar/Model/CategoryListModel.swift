//
//  CategoryListModel.swift
//  Sayyar
//
//  Created by Atri Patel on 20/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryListModel: NSObject {

    var category_id     : Int!              = 0
    var cat_name_ar     : String!           = ""
    var cat_name_de     : String!           = ""
    var cat_name_en     : String!           = ""
    var cat_name_nl     : String!           = ""
    var cat_name_tr     : String!           = ""
    var cat_image       : URL!              = URL(string: "")
    var cat_image_small : URL!              = URL(string: "")
    var cat_banner      : String!           = ""
    var cat_sort_order  : String!           = ""
    var created_at      : String!           = ""
    var modified_at     : String!           = ""
    var created_by      : Int!              = 0
    var modified_by     : Int!              = 0
    var draft           : Int!              = 0
    var subcategories   : [Subcategories]   = []
    var is_featured     : Bool!             = false
    var status          : String!           = ""
    var isSelected      : Bool!             = false
    
    init(aDict : JSON) {
        
        category_id     = aDict["category_id"].intValue
        cat_name_ar     = aDict["cat_name_ar"].stringValue
        cat_name_de     = aDict["cat_name_de"].stringValue
        cat_name_en     = aDict["cat_name_en"].stringValue
        cat_name_nl     = aDict["cat_name_nl"].stringValue
        cat_name_tr     = aDict["cat_name_tr"].stringValue
        cat_image       = URL(string: Category_URL_Prefix + aDict["cat_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        cat_image_small = URL(string: Category_URL_Prefix_Small + aDict["cat_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        cat_banner      = aDict["cat_banner"].stringValue
        cat_sort_order  = aDict["cat_sort_order"].stringValue
        created_at      = aDict["created_at"].stringValue
        modified_at     = aDict["modified_at"].stringValue
        created_by      = aDict["created_by"].intValue
        modified_by     = aDict["modified_by"].intValue
        draft           = aDict["draft"].intValue
        is_featured     = aDict["is_featured"].stringValue == "1"
        status          = aDict["status"].stringValue
        for object in aDict["subcategories"].arrayValue {
            subcategories.append(Subcategories.init(aDict: object))
        }
    }
        
}

class Subcategories: NSObject {
    
    var sub_category_id     : Int!      = 0
    var category_id         : Int!      = 0
    var sub_cat_name_ar     : String!   = ""
    var sub_cat_name_de     : String!   = ""
    var sub_cat_name_en     : String!   = ""
    var sub_cat_name_nl     : String!   = ""
    var sub_cat_name_tr     : String!   = ""
    var sub_cat_image       : URL!      = URL(string: "")
    var cat_image_small     : URL!      = URL(string: "")
    var sub_cat_banner      : String!   = ""
    var sub_cat_sort_order  : Int!      = 0
    var created_at          : String!   = ""
    var modified_at         : String!   = ""
    var created_by          : Int!      = 0
    var modified_by         : Int!      = 0
    var draft               : Int!      = 0
    var cat_name_ar     : String!           = ""
    var cat_name_de     : String!           = ""
    var cat_name_en     : String!           = ""
    var cat_name_nl     : String!           = ""
    var cat_name_tr     : String!           = ""
    var isSelected          : Bool!     = false
    
    
    init(aDict : JSON) {
    
        sub_category_id     = aDict["sub_category_id"].intValue
        category_id         = aDict["category_id"].intValue
        sub_cat_name_ar     = aDict["sub_cat_name_ar"].stringValue
        sub_cat_name_de     = aDict["sub_cat_name_de"].stringValue
        sub_cat_name_en     = aDict["sub_cat_name_en"].stringValue
        sub_cat_name_nl     = aDict["sub_cat_name_nl"].stringValue
        sub_cat_name_tr     = aDict["sub_cat_name_tr"].stringValue
        sub_cat_image       = URL(string: Category_URL_Prefix + aDict["sub_cat_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        cat_image_small     = URL(string: Category_URL_Prefix_Small + aDict["cat_image"].stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        sub_cat_banner      = aDict["sub_cat_banner"].stringValue
        sub_cat_sort_order  = aDict["sub_cat_sort_order"].intValue
        created_at          = aDict["created_at"].stringValue
        modified_at         = aDict["modified_at"].stringValue
        created_by          = aDict["created_by"].intValue
        modified_by         = aDict["modified_by"].intValue
        draft               = aDict["draft"].intValue
        cat_name_ar     = aDict["cat_name_ar"].stringValue
        cat_name_de     = aDict["cat_name_de"].stringValue
        cat_name_en     = aDict["cat_name_en"].stringValue
        cat_name_nl     = aDict["cat_name_nl"].stringValue
        cat_name_tr     = aDict["cat_name_tr"].stringValue

    }
    
}
