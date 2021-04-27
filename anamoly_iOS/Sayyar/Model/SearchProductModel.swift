//
//  SearchProductModel.swift
//  Sayyar
//
//  Created by Atri Patel on 23/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchProductModel: NSObject {

    var s_type      : String!   = ""
    var s_type_id   : Int!      = 0
    var search_ar   : String!   = ""
    var search_de   : String!   = ""
    var search_en   : String!   = ""
    var search_nl   : String!   = ""
    var search_tr   : String!   = ""
    var searchText  : String!   = ""
    
    init(aDict : JSON, searchText : String) {
        s_type          = aDict["s_type"].stringValue
        s_type_id       = aDict["s_type_id"].intValue
        search_ar       = aDict["search_ar"].stringValue
        search_de       = aDict["search_de"].stringValue
        search_en       = aDict["search_en"].stringValue
        search_nl       = aDict["search_nl"].stringValue
        search_tr       = aDict["search_tr"].stringValue
        self.searchText = searchText
    }
    
}
