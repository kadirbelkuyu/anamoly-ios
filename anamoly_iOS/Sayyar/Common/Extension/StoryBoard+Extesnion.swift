//
//  StoryBoard+Extesnion.swift
//  Burdy
//
//  Created by PCQ183 on 29/07/19.
//  Copyright © 2019 PCQ183. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static var Authentication: UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: nil)
    }
    
    static var Cart: UIStoryboard {
        return UIStoryboard(name: "Cart", bundle: nil)
    }
    
    static var Home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    
    static var Introduction: UIStoryboard {
        return UIStoryboard(name: "Introduction", bundle: nil)
    }
    
    static var Main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var Order: UIStoryboard {
        return UIStoryboard(name: "Order", bundle: nil)
    }
    
    static var Profile: UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
    
    static var Search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }
    
    static var UpdateProfile: UIStoryboard {
        return UIStoryboard(name: "UpdateProfile", bundle: nil)
    }
    
    /// Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.get(ProfileViewController.self) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    public func get<T:UIViewController>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        
        guard let viewController = instantiateViewController(withIdentifier: storyboardID) as? T else {
            return nil
        }
        
        return viewController
    }
    
}
