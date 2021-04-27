//
//  String+Extension.swift
//  Burdy
//
//  Created by PCQ183 on 29/07/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var isMobile : Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        if texttest1.evaluate(with: self){
            return true
        }
        return false
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    
    var isValidEmail : Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if  emailTest.evaluate(with: self){
            return true
        }
        return false
    }
    
    var isValidPanCardNumber : Bool {
        let panCardRegEx = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
        let panCardTest = NSPredicate(format:"SELF MATCHES %@", panCardRegEx)
        if  panCardTest.evaluate(with: self){
            return true
        }
        return false
    }
    
    var isValidPassword : Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
        return passwordTest.evaluate(with: self)
    }
    
    var isValidPincode : Bool {
        //let pincodeTest = NSPredicate(format: "SELF MATCHES %@", "^[0-9]{4}[a-zA-Z]{2}$")
        //return pincodeTest.evaluate(with: self)
        return true
    }
    
    /// Returns trim string
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    
    /// Returns length of string
    var length: Int{
        return self.count
    }
    
    /// Returns length of string after trim it
    var trimmedLength: Int{
        return self.trimmed.length
    }
    
    //Renove White Space from String
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    func dateFromCustomString(withFormat format:String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
    
    func isValidForUrl() -> Bool{
        
        if(self.hasPrefix("http") || self.hasPrefix("https")){
            return true
        }
        return false
    }
    
    func safelyLimitedTo(length n: Int)->String {
        let c = self
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    
    var phoneFormatted: String {
        //"(###) ###-####"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if (index.isMultiple(of: 2) == false) {
                output = " "
            }
            output.append(c)
        }
        return output
    }
    
    var normalFormatted: String {
        return self.digits
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var aadharCardFormatted: String {
        //"0000 0000 0000"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if index == 4 {
                output = "\(output) "
            } else if index == 8 {
                output = "\(output) "
            }
            output.append(c)
        }
        return output
    }
    
    var creditDebitCardNumberFormatted: String {
        //"0000 0000 0000 0000"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if index == 4 {
                output = "\(output) "
            } else if index == 8 {
                output = "\(output) "
            } else if index == 12 {
                output = "\(output) "
            }
            output.append(c)
        }
        return output
    }
    
    var creditDebitCardExpireyTimeFormatted: String {
        //"MM/YY"
        let input = self.normalFormatted
        var output = ""
        input.enumerated().forEach { index, c in
            if index == 2 {
                output = "\(output)/"
            }
            output.append(c)
        }
        return output
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
}

