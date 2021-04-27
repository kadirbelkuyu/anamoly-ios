//
//  SEnum.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

enum OrderStatus {
    
    case Pending
    case Confirmed
    case OutForDelivery
    case Delivered
    case Declined
    case Canceled
    case Unpaid
    case Paid
    case None
    
    var Title : String {
        switch self {
        case .Pending:
            return "Pending"
        case .Confirmed:
            return "Confirmed"
        case .OutForDelivery:
            return "Out for Delivery"
        case .Delivered:
            return "Delivered"
        case .Declined:
            return "Declined"
        case .Canceled:
            return "Canceled"
        case .Unpaid:
            return "Un Paid"
        case .Paid:
            return "Paid"
        case .None:
            return ""
        }
    }
    
    var DutchTitle : String {
        switch self {
        case .Pending:
            return "In afwachting"
        case .Confirmed:
            return "Bevestigd"
        case .OutForDelivery:
            return "Onderweg voor bezorging"
        case .Delivered:
            return "Geleverd"
        case .Declined:
            return "Geweigerd"
        case .Canceled:
            return "Geannuleerd"
        case .Unpaid:
            return "Onbetaald"
        case .Paid:
            return "Betaald"
        case .None:
            return ""
        }
    }
    
    var Color : UIColor {
        switch self {
        case .Pending:
            return .gray
        case .Confirmed:
            return ColorApp.ColorRGB(134,162,104,1)
        case .OutForDelivery:
            return ColorApp.ColorRGB(134,162,104,1)
        case .Delivered:
            return ColorApp.ColorRGB(134,162,104,1)
        case .Declined:
            return .red
        case .Canceled:
            return .red
        case .Unpaid:
            return .red
        case .Paid:
            return ColorApp.ColorRGB(134,162,104,1)
        case .None:
            return .clear
        }
    }
    
    var ID : Int {
        switch self {
        case .Pending:
            return 0
        case .Confirmed:
            return 1
        case .OutForDelivery:
            return 2
        case .Delivered:
            return 3
        case .Declined:
            return 4
        case .Canceled:
            return 5
        case .Unpaid:
            return 6
        case .Paid:
            return 7
        case .None:
            return -1
        }
    }
    
    func getOrderStatus(id : Int) -> OrderStatus {
        switch id {
        case 0:
            return .Pending
        case 1:
            return .Confirmed
        case 2:
            return .OutForDelivery
        case 3:
            return .Delivered
        case 4:
            return .Declined
        case 5:
            return .Canceled
        case 6:
            return .Unpaid
        case 7:
            return .Paid
        default:
            return .None
        }
    }
    
}

enum AppLanguage {
    
    case Dutch
    case English
    case Turkish
    case Swedish
    case Arabic
    
    var language : String {
        switch self {
        case .Dutch     : return "nl"
        case .English   : return "en"
        case .Turkish   : return "tr"
        case .Swedish   : return "sv"
        case .Arabic    : return "ar"
        }
    }
    
    var APIHeaderTitle : String {
        switch self {
        case .Dutch     : return "dutch"
        case .English   : return "english"
        case .Turkish   : return "turkish"
        case .Swedish   : return "dutch"
        case .Arabic    : return "arabic"
        }
    }
    
    func getAppLanguage(_ value : String) -> AppLanguage {
        switch value {
        case "nl"   : return .Dutch
        case "en"   : return .English
        case "tr"   : return .Turkish
        case "sv"   : return .Swedish
        case "ar"   : return .Arabic
        default     : return .English
        }
    }
    
}

enum NotificationType {
    
    case Order
    case Offer
    case Discount
    case Product
    case OrderOutOfDelivery
    
    var Title : String {
        switch self {
        case .Order:
            return "ORDER"
        case .Offer:
            return "OFFER"
        case .Discount:
            return "DISCOUNT"
        case .Product:
            return "PRODUCT"
        case .OrderOutOfDelivery:
            return "ORDER OUT OF DELIVERY"
        }
    }
    
}
