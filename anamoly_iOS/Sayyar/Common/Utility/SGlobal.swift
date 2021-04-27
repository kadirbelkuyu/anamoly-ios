//
//  SGlobal.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SGlobal {
    
    static let global: SGlobal = SGlobal()
    
    /// Global navigation controller for application level
    var navigationController : UINavigationController?

    
    /// User object for application level
//    var user        : UserModel.User?
    var deviceToken : String = ""

}
