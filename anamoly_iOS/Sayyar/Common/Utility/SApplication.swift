//
//  SApplication.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD
import IQKeyboardManagerSwift
import OneSignal

final class SApplication {
    
    enum AuthenticationState : Int {
       ///Successfull logedin valid user
       case authenticated
       ///Not login user, app will be used as guest
       case guest
       ///Registration mail link is not tapped
       case notActivated
       ///Blocked existing user from backend
       case blocked
    }
    
    enum Environment {
        
        ///Used at time of development
        case development
        
        ///Used when development finished and Testing starts
        case staging
        
        ///Used at time of deployment
        case production
    }
    
    /// Determine environment of application.
    ///
    /// Values will be one of the *development*, *staging* or *production*
    private(set) static var environment: Environment?
    
    class var authenticationState: AuthenticationState {
        if UserDefault.contains(key: Key.userKey) {
            return .authenticated
        }
        return .guest
    }
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class var name: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    class var version: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    class var buildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    class var rootViewController: UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
    
    class var isRegisteredForRemoteNotifications: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    static var termsConditionsUrl = "https://www.google.com/"
    static var privacyPolicyUrl   = "https://www.google.com/"
    static var googleMapsAPIKey   = ""
    static var awsBucketName      = ""
    static var awsSecretKey       = ""
    static var awsAccessKey       = ""
    
    //MARK:- Application initial methods
    class func prepareApplication() {
        //Set environment
        
        //App Language

        appLanguage = appLanguage.getAppLanguage(SDefaultManager.getAppLanguage() ?? "")
        Bundle.setLanguage(appLanguage.language)
        APIManager.shared.setHeader()
        
        #if DEVELOPER
        Application.environment = .development
        #elseif SANDBOX
        Application.environment = .development
        #else
        Application.environment = .production
        #endif
        
        SharedApplication.userManager = UserManager.init()
        SharedApplication.navigateFlow()
//        self.prepareUser()
//        self.prepareInitialStoryboard()
        self.prepareIQKeyboard()
        self.prepareSVProgressHUD()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            Application.shared.window?.overrideUserInterfaceStyle = .light
        }
        
        let center  = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    /// This function start location service
    private class func prepareLocationService() {
        
    }
    
    /// This function create user object from userdefaults
//    private class func prepareUser() {
//        if let userData = UserDefault[Key.userKey] as! Data? {
//            do {
//                Global.user =  try JSONDecoder().decode(UserModel.User.self, from: userData)
//                Web.set(authorizeToken: Global.user!.token?.stringValue ?? "")
//                //Call application level webservices
//                //Global.getMasterData()
//            } catch {
//                plog("Serialization issue")
//            }
//        }
//    }
    
    private class func prepareLanguage() {
        
    }
    
    private class func prepareForOffline() {
        
    }
    
    /// This function set root storyboard from condition
    class func prepareInitialStoryboard() {
        if Application.authenticationState == .authenticated {
            Application.shared.window?.rootViewController = UIStoryboard.Authentication.instantiateInitialViewController()
        } else {
            Application.shared.window?.rootViewController = UIStoryboard.Authentication.instantiateInitialViewController()
        }
    }
    
    /// This method is used to initialize all third party key
    private class func prepareIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .black
    }
    
    private class func prepareSVProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    /// It displays alert for logout
//    class func prepareUserForLogout() {
//        let alert = UIAlertController(title: Text.Messages.askLogout, message:nil , preferredStyle: .alert)
//
//        let actionLogout = UIAlertAction(title: Text.Label.logout, style: .destructive, handler: { (ACTION :UIAlertAction!)in
//
//            //call webservice here
//            Global.user!.logout()
//            Application.prepareInitialStoryboard()
//        })
//
//        let actionCancel = UIAlertAction(title: Text.Label.cancel, style: .cancel, handler: nil)
//
//        alert.addAction(actionLogout)
//        alert.addAction(actionCancel)
//        if let popoverController = alert.popoverPresentationController {
//            let view = Application.rootViewController.view!
//            popoverController.sourceView = view
//            popoverController.sourceRect =  CGRect(x: view.bounds.midX , y: view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//        Application.rootViewController.present(alert, animated: true, completion: nil)
//    }
    
    //MARK:- Push notification methods
    /// It is used to call APNS register method
    class func registerForPushNotification() {
        
    }
    
    /// It is used to call APNS unregister method
    class func unRegisterForPushNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}
