//
//  SConstant.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import Foundation

typealias Application   = SApplication
typealias Key           = SKey

let Global: SGlobal     = SGlobal.global
let UserDefault         = UserDefaults.standard

let ScreenSize          = UIScreen.main.bounds.size
let ScreenHeight        = UIScreen.main.bounds.size.height
let ScreenWidth         = UIScreen.main.bounds.size.width
let SafeAreaTop         = Application.shared.window!.safeAreaInsets.top
let SafeAreaBottom      = Application.shared.window!.safeAreaInsets.bottom


let One_Signal_App_ID   = "5c7254e8-5255-47a2-b45f-9b11c93daecc"
let Google_Map_Key      = "AIzaSyBF6gfSFKxQGf1aRW-ZyO1htevZVOETQIA"
let Google_Location_Key = ""
let Google_Key          = "AIzaSyBF6gfSFKxQGf1aRW-ZyO1htevZVOETQIA"

let Settings_URL_Prefix         = BaseURL + "/uploads/app/"
let Product_URL_Prefix          = BaseURL + "/uploads/products/"
let Product_URL_Prefix_Small    = BaseURL + "/uploads/products/crop/small/"
let Banner_URL_Prefix           = BaseURL + "/uploads/banners/"
let Category_URL_Prefix         = BaseURL + "/uploads/categories/"
let Category_URL_Prefix_Small   = BaseURL + "/uploads/categories/crop/small/"
let Profile_URL_Prefix          = BaseURL + "/uploads/profile/"

let Product_Placeholder = UIImage(named: "productPlaceholder")!

let SharedApplication   = UIApplication.shared.delegate as! AppDelegate
var AppName             : String {return Bundle.main.infoDictionary!["CFBundleName"] as! String}
var AppDisplayName      : String {return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String}
var AppVersion          : String {return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String}
var buildVersion        : String {return Bundle.main.infoDictionary!["CFBundleVersion"] as! String}

var SettingList         = SettingListModel()
var appLanguage         : AppLanguage           = .English
var FeatureListArray    : [CategoryListModel]   = []
var SelectedFeatureCategory : CategoryListModel?
var DutchDateIdentifier = "nl"

var DeviceToken         : String = ""
var PlayerID            : String = ""
