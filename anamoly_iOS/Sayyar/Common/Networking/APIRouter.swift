//
//  APIRouter.swift
//  BaseProject
//
//  Created by MAC240 on 04/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import Foundation
import Alamofire


protocol Routable {
    var path       : String { get }
    var method     : HTTPMethod { get }
    var parameters : Parameters? { get }
}


enum APIRouter: Routable {
    
    //Address
    case updateAddress(Parameters)
    case validateAddress(Parameters)
    
    //Authentication
    case login(Parameters)
    case register(Parameters)
    case verifyEmail(Parameters)
    case updateName(Parameters)
    case updateEmail(Parameters)
    case updatePhoneNo(Parameters)
    case updateFamily(Parameters)
    case changePassword(Parameters)
    case updateSetting(Parameters)
    case updateProfilePhoto(Parameters)
    case forgotPasswrd(Parameters)
    case verifyUserEmail(Parameters)
    case playerID(Parameters)
    
    //Category
    case categoriesListAPI(Parameters)
    
    //Coupon
    case couponValidate(Parameters)
    case couponList(Parameters)
    
    //Home
    case homeList(Parameters)
    
    //Order
    case orderList(Parameters)
    case orderSend(Parameters)
    
    //product
    case productHome(Parameters)
    case productsList(Parameters)
    case productDetail(Parameters)
    case productSearch(Parameters)
    case productSuggest(Parameters)
    case productTabs(Parameters)
    case productTabsData(Parameters)
    case productBarcodeScan(Parameters)
    
    //Time Slot
    case timeSlots(Parameters)
    
    //Cart
    case cartList(Parameters)
    case cartDelete(Parameters)
    case cartClean(Parameters)
    case cartAdd(Parameters)
    case cartMinus(Parameters)
    case cartReOder(Parameters)
    
    //Search
    case searchList(Parameters)
    
    //Contact
    case sendContact(Parameters)
    
    //Setting
    case settingList(Parameters)
    case notificationList(Parameters)
    
}

extension APIRouter {
    
    var path : String {
        switch self {
        case .updateAddress         : return Environment.APIBasePath() + "/address/update"
        case .validateAddress       : return Environment.APIBasePath() + "/address/validate"
            
        case .login                 : return Environment.APIBasePath() + "/user/login"
        case .register              : return Environment.APIBasePath() + "/user/register"
        case .verifyEmail           : return Environment.APIBasePath() + "/user/verifyemail"
        case .updateName            : return Environment.APIBasePath() + "/user/update_name"
        case .updateEmail           : return Environment.APIBasePath() + "/user/update_email"
        case .updatePhoneNo         : return Environment.APIBasePath() + "/user/update_phone"
        case .updateFamily          : return Environment.APIBasePath() + "/user/setfamily"
        case .changePassword        : return Environment.APIBasePath() + "/user/changepassword"
        case .updateSetting         : return Environment.APIBasePath() + "/user/updatesettings"
        case .updateProfilePhoto    : return Environment.APIBasePath() + "/user/photo"
        case .forgotPasswrd         : return Environment.APIBasePath() + "/user/forgotpassword"
        case .verifyUserEmail       : return Environment.APIBasePath() + "/user/verify_update_email"
        case .playerID              : return Environment.APIBasePath() + "/user/playerid"
            
        case .categoriesListAPI     : return Environment.APIBasePath() + "/categories/list"
            
        case .couponValidate        : return Environment.APIBasePath() + "/coupon/validate"
        case .couponList            : return Environment.APIBasePath() + "/coupon/list"
            
        case .homeList              : return Environment.APIBasePath() + "/home/list"

        case .orderList             : return Environment.APIBasePath() + "/order/list"
        case .orderSend             : return Environment.APIBasePath() + "/order/send"
            
        case .productHome           : return Environment.APIBasePath() + "/products/home"
        case .productsList          : return Environment.APIBasePath() + "/products/list"
        case .productDetail         : return Environment.APIBasePath() + "/products/details"
        case .productSearch         : return Environment.APIBasePath() + "/products/search"
        case .productSuggest        : return Environment.APIBasePath() + "/products/suggest"
        case .productTabs           : return Environment.APIBasePath() + "/products/tabs"
        case .productTabsData       : return Environment.APIBasePath() + "/products/tabdata"
        case .productBarcodeScan    : return Environment.APIBasePath() + "/products/barcode"
        
        case .timeSlots             : return Environment.APIBasePath() + "/timeslots/list"
            
        case .cartList              : return Environment.APIBasePath() + "/cart/list"
        case .cartDelete            : return Environment.APIBasePath() + "/cart/delete"
        case .cartClean             : return Environment.APIBasePath() + "/cart/clean"
        case .cartAdd               : return Environment.APIBasePath() + "/cart/add"
        case .cartMinus             : return Environment.APIBasePath() + "/cart/minus"
        case .cartReOder            : return Environment.APIBasePath() + "/cart/reorder"
            
        case .searchList            : return Environment.APIBasePath() + "/search/list"
            
        case .sendContact           : return Environment.APIBasePath() + "/contact/send"
            
        case .settingList           : return Environment.APIBasePath() + "/settings/list"
        case .notificationList      : return Environment.APIBasePath() + "/notifications/list"
        }
    }
    
}

extension APIRouter {
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
}

extension APIRouter {
    
    var parameters: Parameters? {
        switch self {
        case .login(let param), .register(let param), .verifyEmail(let param), .productHome(let param), .categoriesListAPI(let param), .productsList(let param), .productDetail(let param), .updateName(let param), .updateEmail(let param), .updatePhoneNo(let param), .updateAddress(let param), .updateFamily(let param), .changePassword(let param), .orderList(let param), .updateSetting(let param), .timeSlots(let param), .updateProfilePhoto(let param), .forgotPasswrd(let param), .couponValidate(let param), .couponList(let param), .cartList(let param), .cartDelete(let param), .cartClean(let param), .cartAdd(let param), .cartMinus(let param), .cartReOder(let param), .searchList(let param), .productSearch(let param), .productSuggest(let param), .verifyUserEmail(let param), .sendContact(let param), .settingList(let param), .validateAddress(let param), .productTabs(let param), .productTabsData(let param), .orderSend(let param), .productBarcodeScan(let param), .  notificationList(let param), .playerID(let param), .homeList(let param):
            return param
        }
    }
    
}
