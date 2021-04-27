//
//  BaseResponse.swift
//  BaseProject
//
//  Created by MAC240 on 05/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Params:String {
    case status
    case success
    case message
    case data
    case errors
    case noInternetConnection
}

class BaseResponse {
    
    var status: Int = 0
    var success: Bool = false
    var message: String?
    var data: JSON?
    var errors: JSON?
    
//    API Response format:
//    {
//    success: true/false,
//    message: “Success or failure request response”,
//    data: “This key include all the data related to request, like user data, access token data”
//    meta: “Meta attributes of request, like pagination and other metadata”,
//    errors: “Error array, this will list all the errors in array related to response and validation.”
//    }

    
    init(response:DataResponse<Any>) {
        
//        guard let response = response else { return  }
        
//        if (response[Params.noInternetConnection.rawValue] as? Bool) != nil {
//            status = InternetConnectionErrorCode.offline.rawValue
//            return
//        }

        let jsonResult: JSON = JSON(response.result.value!)
        
        self.status = jsonResult["code"].intValue
        self.success = jsonResult["responce"].boolValue
        self.message = jsonResult["message"].stringValue
        
        if !jsonResult["data"].isEmpty {
            self.data = jsonResult["data"]
        }
        
        if !jsonResult["errors"].isEmpty {
            self.errors = jsonResult["errors"]
        }

    }
}
