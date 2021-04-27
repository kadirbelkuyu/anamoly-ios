//
//  SUtill.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftMessages

class SUtill: NSObject {
    
    class func getNSAttributedString(fontModel : [FontModel]) -> NSMutableAttributedString {
        let combinationMessage = NSMutableAttributedString()
        for fontModelObject in fontModel {
            let attributedStyle = [ NSAttributedString.Key.font: fontModelObject.font,  NSAttributedString.Key.foregroundColor: fontModelObject.color]
            let stringText = NSMutableAttributedString(string: fontModelObject.text, attributes: attributedStyle)
            combinationMessage.append(stringText)
        }
        return combinationMessage
    }
    
    class func getSuperAttributedScriptForPrice(price : String, fontSize : CGFloat) -> NSMutableAttributedString {
        let font        : UIFont = UIFont.Tejawal.Medium(fontSize)
        let fontSuper   : UIFont = UIFont.Tejawal.Medium(fontSize - 5)
        let attributedString   : NSMutableAttributedString = NSMutableAttributedString(string: price, attributes: [.font:font])
        attributedString.setAttributes([.font:fontSuper,.baselineOffset: fontSize > 15 ? 6 : 4 ], range: NSRange(location : price.count - 2, length : 2))
        return attributedString
    }
    
    class func leftImageTextField(textField : UITextField, image : UIImage) {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let imageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        imageView.image = image
        view.addSubview(imageView)
        textField.leftView = view
        textField.leftViewMode = .always
    }
    
    class func showProgressHUD() {
        SVProgressHUD.show()
    }
    
    class func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
    
    class func userLogout(_ viewController : UIViewController) {
        let logoutButton = UIAlertAction(title: SText.Button.LOGOUT, style: .destructive) { (action) in
            SharedApplication.userManager?.logout()
        }
        let cancelButton = UIAlertAction(title: SText.Button.CANCEL, style: .cancel, handler: nil)
        viewController.showAlert(withMessage: SText.Messages.askLogout, withActions: cancelButton, logoutButton)
    }
    
    class func showSuccessMessage(message : String) {
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: appLanguage == .Dutch ? "Succes" : "Success", body: message)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(view: success)
    }
    
    class func showErrorToastMessage(title : String, message : String) {
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.error)
        success.configureDropShadow()
        success.configureContent(title: title, body: message)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(view: success)
    }
    
    class func settingListAPICall(successBlock : @escaping(() -> ())) {
        let param = [:] as [String:Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.settingList(param), arrImages: [], onSuccess: { (response) in
            if let data = response.data, response.success {
                SettingList = SettingListModel.init(aDict: data)
                successBlock()
            }
        }, onFailure: { (apiErrorResponse) in
        })
    }
    
    class func playerIDAPICall(playerID : String, deviceID : String) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.player_id   : playerID,
                        SText.Parameter.device      : deviceID
                    ] as [String:Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.playerID(param), arrImages: [], onSuccess: { (response) in
            print(response)
        }, onFailure: { (apiErrorResponse) in
            print(apiErrorResponse)
        })
    }

}
