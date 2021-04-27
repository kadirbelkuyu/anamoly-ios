//
//  NotificationListModel.swift
//  Sayyar
//
//  Created by Atri Patel on 16/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationListModel: NSObject {

    var noti_id     : Int!      = 0
    var user_id     : Int!      = 0
    var title_ar    : String!   = ""
    var title_de    : String!   = ""
    var title_en    : String!   = ""
    var title_nl    : String!   = ""
    var title_tr    : String!   = ""
    var message_ar  : String!   = ""
    var message_de  : String!   = ""
    var message_en  : String!   = ""
    var message_nl  : String!   = ""
    var message_tr  : String!   = ""
    var type        : String!   = ""
    var type_id     : Int!      = 0
    var object_json : String!   = ""
    var created_at  : String!   = ""
    var modified_at : String!   = ""
    var created_by  : Int!      = 0
    var modified_by : Int!      = 0
    var draft       : Int!      = 0
    
    init(aDict : JSON) {
    
        noti_id     = aDict["noti_id"].intValue
        user_id     = aDict["user_id"].intValue
        title_ar    = aDict["title_ar"].stringValue
        title_de    = aDict["title_de"].stringValue
        title_en    = aDict["title_en"].stringValue
        title_nl    = aDict["title_nl"].stringValue
        title_tr    = aDict["title_tr"].stringValue
        message_ar  = aDict["message_ar"].stringValue
        message_de  = aDict["message_de"].stringValue
        message_en  = aDict["message_en"].stringValue
        message_nl  = aDict["message_nl"].stringValue
        message_tr  = aDict["message_tr"].stringValue
        title_en    = aDict["title_en"].stringValue
        message_en  = aDict["message_en"].stringValue
        type        = aDict["type"].stringValue
        type_id     = aDict["type_id"].intValue
        object_json = aDict["object_json"].stringValue
        created_at  = aDict["created_at"].stringValue
        modified_at = aDict["modified_at"].stringValue
        created_by  = aDict["created_by"].intValue
        modified_by = aDict["modified_by"].intValue
        draft       = aDict["draft"].intValue

    }
    
}
