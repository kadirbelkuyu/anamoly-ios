//
//  LoginViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 04/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var backgroundImageView      : UIImageView!
    @IBOutlet private weak var titleDescriptionLabel    : UILabel!
    @IBOutlet private weak var emailAddresstextField    : UITextField!
    @IBOutlet private weak var enterPasswordTextField   : UITextField!
    @IBOutlet private weak var loginButton              : SpinnerButton!
    @IBOutlet private weak var forgotPasswordButton     : UIButton!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
        
//        emailAddresstextField.text = "waywebsolution@gmail.com"
//        enterPasswordTextField.text = "terminal"
        backgroundImageView.sd_setImage(with: SettingList.login_top_image, placeholderImage: nil)
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        SUtill.leftImageTextField(textField: self.emailAddresstextField, image: UIImage(named: "email")!)
        SUtill.leftImageTextField(textField: self.enterPasswordTextField, image: UIImage(named: "key")!)
        
        titleDescriptionLabel.attributedText = SUtill.getNSAttributedString(fontModel: [
                                                                                            FontModel.init(font: UIFont.Tejawal.Bold(20),
                                                                                                           color: ColorApp.ColorRGB(65,23,116,1),
                                                                                                           text: NSLocalizedString("Ordered from us", comment: "Ordered from us")),
                                                                                            FontModel.init(font: UIFont.Tejawal.Bold(20),
                                                                                                           color: ColorApp.ColorRGB(189,136,49,1),
                                                                                                           text: " " + NSLocalizedString("Delivered to your home", comment: "Delivered to your home"))
                                                                                        ])
        //if appLanguage == .Dutch {
        //    prepareDutchLanguage()
        //}
        emailAddresstextField.placeholder = NSLocalizedString("Email Address", comment: "")
        enterPasswordTextField.placeholder = NSLocalizedString("Enter Password", comment: "")
        
        backgroundImageView.sd_setImage(with: SettingList.login_top_image, placeholderImage: nil)
        SUtill.settingListAPICall { [weak self] () in
            guard let `self` = self else { return }
            self.backgroundImageView.sd_setImage(with: SettingList.login_top_image, placeholderImage: nil)
        }
        forgotPasswordButton.setTitleColor(SettingList.button_color, for: .normal)
        forgotPasswordButton.backgroundColor = .clear
    }
    
    //MARK: - Action Methods
    @IBAction private func didTapOnButtonback(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonLogin(_ sender: Any) {
        self.view.endEditing(true)
        if validateData() {
            self.loginAPICall()
        }
    }
    
    @IBAction private func didTapOnButtonForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let forgotPasswordViewController = UIStoryboard.Authentication.get(ForgotPasswordViewController.self)!
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - TextField Delegate -
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailAddresstextField:
            self.enterPasswordTextField.becomeFirstResponder()
        case self.enterPasswordTextField:
            self.enterPasswordTextField.resignFirstResponder()
            if validateData() {
                self.loginAPICall()
            }
        default:
            break
        }
        return true
    }
    
}

//MARK: - API Call -
extension LoginViewController {
    
    private func loginAPICall() {
        let param = [
                        SText.Parameter.user_email      : emailAddresstextField.text ?? "",
                        SText.Parameter.user_password   : enterPasswordTextField.text ?? ""
                    ] as [String : Any]
        loginButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.login(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.loginButton.endLoading()
            if response.success, let data = response.data {
                let user = User.init(aDict: data)
                if user.is_email_verified == false {
                    let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
                    otpViewController.emailAddress = user.user_email
                    self.navigationController?.pushViewController(otpViewController, animated: true)
                } else {
                    SharedApplication.userManager?.login(user: user)
                }
            } else {
                if response.status == 108, let data = response.data, data["user_email"].stringValue.trimmedLength > 0 {
                    let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
                    otpViewController.emailAddress = data["user_email"].stringValue.trimmed
                    self.navigationController?.pushViewController(otpViewController, animated: true)
                } else if response.status == 106, let data = response.data {
                    let waitingListOneViewController = UIStoryboard.Introduction.get(WaitingListOneViewController.self)!
                    waitingListOneViewController.waitingListNo = data["req_queue"].intValue
                    let navigationViewController = UINavigationController(rootViewController: waitingListOneViewController)
                    navigationViewController.modalPresentationStyle = .overFullScreen
                    navigationViewController.isNavigationBarHidden  = true
                    navigationViewController.navigationBar.isHidden = true
                    self.navigationController?.present(navigationViewController, animated: true, completion: nil)
                } else if response.status == 105 {
                    let noDeliveryViewController = UIStoryboard.Introduction.get(NoDeliveryViewController.self)!
                    noDeliveryViewController.modalPresentationStyle = .overFullScreen
                    self.present(noDeliveryViewController, animated: true, completion: nil)
                } else {
                    self.showAlert(withMessage: response.message ?? "")
                }
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let `self` = self else {return}
            self.loginButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension LoginViewController {
    
    private func validateData() -> Bool {
        if (emailAddresstextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.emailAddresstextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankEmailID, withActions: okButton)
            return false
        }
        if (emailAddresstextField.text?.trimmed.isValidEmail == false) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.emailAddresstextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.validEmailID, withActions: okButton)
            return false
        }
        if (enterPasswordTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.enterPasswordTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankPassword, withActions: okButton)
            return false
        }
        return true
    }
    /*
    private func prepareDutchLanguage() {
        titleDescriptionLabel.attributedText = SUtill.getNSAttributedString(fontModel: [
                                                                                            FontModel.init(font: UIFont.Tejawal.Bold(20),
                                                                                                           color: ColorApp.ColorRGB(65,23,116,1),
                                                                                                           text: "Order har skickats iväg till dig"),
                                                                                            FontModel.init(font: UIFont.Tejawal.Bold(20),
                                                                                                           color: ColorApp.ColorRGB(189,136,49,1),
                                                                                                           text: " Din order är levererad")
                                                                                        ])
        emailAddresstextField.placeholder = "Ange e-postadress"
        enterPasswordTextField.placeholder = "Ange lösenord"
        loginButton.setTitle("Logga in", for: .normal)
        forgotPasswordButton.setTitle("Glömt lösenord?", for: .normal)
        loginButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        forgotPasswordButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 20)
    }
    */
}
