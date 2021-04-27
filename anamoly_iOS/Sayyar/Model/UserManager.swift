//
//  UserManager.swift
//  Faith Streaming
//
//  Created by Atri Patel on 19/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

extension AppDelegate {
    
    func navigateFlow() {
        switch self.userManager?.authenticationState ?? .signedIn {
        case .signedIn:
            if let navigationController = UIStoryboard.Main.instantiateInitialViewController() as? UINavigationController {
                globalNavigationController = navigationController
            }
            Application.shared.window?.rootViewController = UIStoryboard.Main.instantiateInitialViewController()
        case .signedOut:
            Application.shared.window?.rootViewController = UIStoryboard.Authentication.instantiateInitialViewController()
        }
    }
    
}

var AppUser: User? {
    return SharedApplication.userManager?.user
}

var AppUserId: Int {
    return AppUser?.user_id ?? 0
}

class UserManager {
    
    // This is the enum of login status objects
    enum AuthenticationState {
        case signedIn
        case signedOut
    }
    
    var authenticationState: AuthenticationState = .signedOut
    var user: User?
    var userId: String?
    
    var authToken: String{
        switch self.authenticationState {
        case .signedIn:
            return self.user?.ios_token ?? ""
        case .signedOut:
            return "" //Environment.sharedKey()
        }
    }
    
    init() {
        if let userID = UserDefaultsData.getString(for: .userId){
            if userID != ""{
                self.login(userId: userID)
                return
            }
        }
        self.logout()
    }
    
    
    // To manage login in appliction using userId
    func login(userId: String){
        self.authenticationState = .signedIn
        UserDefaultsData.store(string: userId, for: .userId)
        
        if let json = UserDefaultsData.getString(for: .userModelJSON){
            let userJSON = JSON.init(parseJSON: json)
            let user = User.init(aDict: userJSON)
            if "\(user.user_id ?? 0)" == userId {
                self.user = user
                self.userId = userId
            }
        }
    }
    
    // To manage login in appliction using user model
    func login(user: User?, flowNavigate : Bool = true){
        guard let user = user else {
            self.logout()
            return
        }
        self.user = user
        self.authenticationState = .signedIn
        UserDefaultsData.store(string: "\(user.user_id ?? 0)", for: .userId)
        UserDefaultsData.store(string: user.user_email ?? "", for: .email)
        UserDefaultsData.store(string: user.ios_token ?? "", for: .token)
        UserDefaultsData.store(string: user.userJson, for: .userModelJSON)
        if flowNavigate {
            SharedApplication.navigateFlow()
        }
    }
    
    func logout(){
        self.user = nil
        self.authenticationState = .signedOut
        UserDefaultsData.delete(for: .userId)
        UserDefaultsData.delete(for: .token)
        UserDefaultsData.delete(for: .email)
        UserDefaultsData.delete(for: .userModelJSON)
        SharedApplication.navigateFlow()
    }
    
    func logoutUser() {
        self.user = nil
        self.authenticationState = .signedOut
        UserDefaultsData.delete(for: .userId)
        UserDefaultsData.delete(for: .token)
        UserDefaultsData.delete(for: .email)
        UserDefaultsData.delete(for: .userModelJSON)
    }
    
}

// MARK: - UserDefaultsData
class UserDefaultsData{
    
    enum Key: String {
        case userId = "KUSERID"
        case token = "KUSERTOKEN"
        case email = "KUSEREMAIL"
        case userModelJSON = "KUSERMODELJSON"
        case searchHistroy = "KSEARCHHISTORY"
    }
    
    class func store(string: String,for key: Key){
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }
    class func getString(for key: Key) -> String?{
        return UserDefaults.standard.value(forKey: key.rawValue) as? String
    }
    class func delete(for key: Key){
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
}
