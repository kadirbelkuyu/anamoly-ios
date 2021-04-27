//
//  UserDefaults+Extension.swift
//  Imperfecto
//
//  Created by PCQ184 on 12/11/19.
//  Copyright © 2019 PCQ184. All rights reserved.
//

import Foundation

extension UserDefaults {
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key) as Any?
        }
        set {
            set(newValue, forKey: key)
            synchronize()
        }
    }
    
    public static func contains(key: String) -> Bool {
        return self.standard.contains(key: key)
    }
    
    public func contains(key: String) -> Bool {
        return self.dictionaryRepresentation().keys.contains(key)
    }
    
    public func reset() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            let ingnoreKeys: [String] = []//Application scope keys
            if ingnoreKeys.contains(key) {
                continue
            }
            UserDefaults.standard.removeObject(forKey: key)
        }
        synchronize()
    }
}
