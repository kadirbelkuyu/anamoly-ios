//
//  Environment.swift
//  BaseProject
//
//  Created by MAC240 on 04/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import Foundation

//let BaseURL = "https://dev.anamoly.se" // Sandbox
let BaseURL = "https://admin.anamoly.se" //Production


enum Server {
    case developement
    case staging
    case production
}

class Environment {
    //Add Target conditions here and set defualt server here based on Target.
//    #if BASEPROJECT_PRODUCTION
//        static let server:Server    =   .production
//    #elseif BASEPROJECT_STAGING
//        static let server:Server    =   .staging
//    #else
//        static let server:Server    =   .developement
//    #endif
    
    static let server:Server    =   .developement
    
    // To print the log set true.
    static let debug:Bool       =   true
    
    class func APIBasePath() -> String {
        switch self.server {
            case .developement:
                return BaseURL + "/index.php/rest"
            case .staging:
                return BaseURL + "/index.php/rest"
            case .production:
                return BaseURL + "/index.php/rest"
        }
    }
    
}


