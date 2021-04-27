//
//  SText.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SText: NSObject {
    
    struct Button {
        static var OK       = "OK".localized
        static var YES      = "YES".localized
        static var NO       = "NO".localized
        static var CANCEL   = "Cancel".localized
        static var LOGOUT   = "LOGOUT".localized
        static var DELETE   = "Delete".localized
    }
    
    struct Label {
        static var logout   = "LOGOUT".localized
        static var cancel   = "Cancel".localized
        static var Delete   = "Delete".localized
    }
    
    struct Parameter {
        //a
        static let add_on_house_no              = "add_on_house_no"
        static let android_token                = "android_token"
        static let area                         = "area"
        
        //b
        static let barcode                      = "barcode"
        
        //c
        static let c_password                   = "c_password"
        static let cart_id                      = "cart_id"
        static let category_id                  = "category_id"
        static let city                         = "city"
        static let coupon_code                  = "coupon_code"
        
        //d
        static let delivery_date                = "delivery_date"
        static let delivery_time                = "delivery_time"
        static let device                       = "device"
        
        //f
        static let fullname                     = "fullname"
        
        //G
        static let general_emails               = "general_emails"
        static let general_notifications        = "general_notifications"
        
        
        //h
        static let house_no                     = "house_no"
        
        //i
        static let ids                          = "ids"
        static let image                        = "image"
        static let is_company                   = "is_company"
        static let is_express                   = "is_express"
        static let ios_token                    = "ios_token"
        
        //l
        static let latitude                     = "latitude"
        static let longitude                    = "longitude"
        
        //
        static let message                      = "message"
        
        //n
        static let n_password                   = "n_password"
        static let no_of_adults                 = "no_of_adults"
        static let no_of_cats                   = "no_of_cats"
        static let no_of_child                  = "no_of_child"
        static let no_of_dogs                   = "no_of_dogs"
        
        //o
        static let order_emails                 = "order_emails"
        static let order_id                     = "order_id"
        static let order_note                   = "order_note"
        static let order_notifications          = "order_notifications"
        static let otp                          = "otp"
        
        //p
        static let paid_by                      = "paid_by"
        static let phone                        = "phone"
        static let player_id                    = "player_id"
        static let postal_code                  = "postal_code"
        static let product_group_id             = "product_group_id"
        static let product_id                   = "product_id"
        
        //q
        static let qty                          = "qty"
        
        //r
        static let r_password                   = "r_password"
        
        //s
        static let search                       = "search"
        static let street_name                  = "street_name"
        static let sub_category_id              = "sub_category_id"
        static let suggestion                   = "suggestion"
        
        //t
        static let tab_ref                      = "tab_ref"
        
        //u
        static let user_company_id              = "user_company_id"
        static let user_company_name            = "user_company_name"
        static let user_firstname               = "user_firstname"
        static let user_id                      = "user_id"
        static let user_image                   = "user_image"
        static let user_lastname                = "user_lastname"
        static let user_email                   = "user_email"
        static let user_password                = "user_password"
        static let user_phone                   = "user_phone"
    }
    
    struct UserDefaults {
        
        static let SessionToken                 = "SessionToken"
        static let AppLanguage                  = "AppLanguage"
        static let PlayerID                     = "PlayerID"
        
    }
    
    struct Messages {
        //A
        static var askLogout    = "Are you sure you want to logout?".localized
        static var askCartClean = "Are you sure you want delete all your items from cart?".localized
        static var askReOrder:String {
            return  appLanguage == .Dutch ? "Din gamla produkt går bort från kundvagnen och är redo när du ombeställer." : "If you re order your product than old cart data is cleared and re order data will added."
        }
        
        //B
        static var blankAdOn                            = "Please enter your adon number.".localized
        static var blankArea                            = "Please enter your area.".localized
        static var blankCart                            = "Your cart is already blank.".localized
        static var blankCompanyIDNumber                 = "Please enter your company id number.".localized
        static var blankCompanyName                     = "Please enter your company name.".localized
        static var blankConfirmNewPassword              = "Please enter your confirm new password".localized
        static var blankCurrentPassword                 = "Please enter your curent password.".localized
        static var blankCouponCode                      = "Please enter your coupon code.".localized
        static var blankEmailID                         = "Please enter your email address.".localized
        static var blankFirstName                       = "Please enter your first name.".localized
        static var blankFullName                        = "Please enter your full name.".localized
        static var blankHouseNo                         = "Please enter your house number.".localized
        static var blanklastName                        = "Please enter your last name.".localized
        static var blnakMessage                         = "Please enter your messaage.".localized
        static var blankNewPassword                     = "Please enter your new password.".localized
        static var blankPassword                        = "Please enter your password.".localized
        static var blankPincode                         = "Please enter your postal code.".localized
        static var blankPhoneNo                         = "Please enter your phone number.".localized
        static var blankPostalCode                      = "Please enter your postal code.".localized
        static var blankProductName                     = "Please enter your suggest missing product name.".localized
        static var blankStreet                          = "Please enter your street.".localized
        
        //E
        static var expressCartTitle                     = "Attention!\nThe products with EXPRESS icon are immediately available!".localized
        static var expressCartDescription               = "You have chosen EXPRESS delivery, unfortunately not all products you have chosen can be delivered with EXPRESS delivery! Please double check your order and remove non-Express products from your cart!".localized
        
        //M
        static var minimumCharacterConfirmNewPassword   = "Please enter minimum 6 characters confirm new password.".localized
        static var minimumCharacterCurrentPassword      = "Please enter minimum 6 characters current password.".localized
        static var minimumCharacterNewPassword          = "Please enter minimum 6 characters new password.".localized
        static var minimumCharacterPassword             = "Please enter minimum 6 characters password.".localized
        static var minimumCharacterOTP                  = "Please enter minimum 6 characters otp.".localized
        static var minimumCharacterPostalCode           = "Please enter minimum 6 characters postal code.".localized
        
        //N
        static var noInternet                           = "You need an active data connection to use this application, please check your internet setting and try again.".localized
        static var notSamePassword                      = "Your new password should not same as your curent password.".localized
        static var noValidation                         = "You have not changed anything.".localized
        
        //S
        static var samePassword                         = "Your new password and confirm new password should be same.".localized
        
        //V
        static var validEmailID                         = "Please enter valid email address.".localized
        static var validPassword                        = "Your password should have minimum 8 characters, 1 uppercase, 1 lowercase, 1 digit and 1 special characters.".localized
        static var validPostalCode                      = "Please enter valid postal code.".localized
        static var validPincodeAndHouseNo               = "Please enter valid postal code and house number.".localized
        
    }

}
