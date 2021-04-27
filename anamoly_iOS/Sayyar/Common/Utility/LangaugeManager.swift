//
//  LangaugeManager.swift
//  mel3qa
//
//  Created by way web solutation on 02/03/19.
//  Copyright © 2019 com. All rights reserved.
//
import UIKit
private var kBundleKey: UInt8 = 0

class BundleEx: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleKey) {
            return (bundle as! Bundle).localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

private var kBundleUIKitKey: UInt8 = 0

class BundleUIKitEx: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleUIKitKey) {
            return (bundle as! Bundle).localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    static let once: Void = {
        object_setClass(Bundle.main, type(of: BundleEx()))
        object_setClass(Bundle(identifier:"com.apple.UIKit"), type(of: BundleUIKitEx()))
    }()
    class func isLanguageRTL(_ languageCode: String?) -> Bool {
        return (languageCode != nil && Locale.characterDirection(forLanguage: languageCode!) == .rightToLeft)
    }
    class func isRTL()->Bool{
        return UserDefaults.standard.bool(forKey: "isLanguageRTL");
    }
    class func getLanguageId()->String {
        if(isRTL()){
            return "2"
        }
        else{
            return "1"
        }
    }
    class func getLanguageName()->String {
        if(isRTL()){
            return "عربى"
        }
        else{
            return "English"
        }
    }
    class func setLanguage(_ language: String?) {
        Bundle.once
        let isLanguageRTL = Bundle.isLanguageRTL(language);
        if (isLanguageRTL) {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "isLanguageRTL")
        UserDefaults.standard.synchronize()
        
        let value = (language != nil ? Bundle.init(path: (Bundle.main.path(forResource: language, ofType: "lproj"))!) : nil)
        objc_setAssociatedObject(Bundle.main, &kBundleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if let uiKitBundle = Bundle(identifier: "com.apple.UIKit") {
            var valueUIKit: Bundle? = nil
            if let lang = language,
                let path = uiKitBundle.path(forResource: lang, ofType: "lproj") {
                valueUIKit = Bundle(path: path)
            }
            objc_setAssociatedObject(uiKitBundle, &kBundleUIKitKey, valueUIKit, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}
