//
//  ViewController+Extension.swift
//  Imperfecto
//
//  Created by Atri Patel on 08/11/19.
//  Copyright © 2019 PCQ184. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withMessage message: String?, title : String = SettingList.name, preferredStyle: UIAlertController.Style = .alert, withActions actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
