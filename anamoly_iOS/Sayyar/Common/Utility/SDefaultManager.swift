//
//  SDefaultManager.swift
//  Sayyar
//
//  Created by Atri Patel on 07/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SDefaultManager: NSObject {

    class func setAppLanguage(_ language: String) -> Void {
        UserDefaults.standard.setValue(language, forKey: SText.UserDefaults.AppLanguage)
        UserDefaults.standard.synchronize()
    }
    
    class func getAppLanguage() -> String? {
        return UserDefaults.standard.string(forKey: SText.UserDefaults.AppLanguage)
    }
    
    class func setPlayerID(playerID: String) -> Void {
        UserDefaults.standard.set(playerID, forKey: SText.UserDefaults.PlayerID)
        UserDefaults.standard.synchronize()
    }
    
    class func getPlayerID() -> String {
        return UserDefaults.standard.string(forKey: SText.UserDefaults.PlayerID) ?? ""
    }
    
}
