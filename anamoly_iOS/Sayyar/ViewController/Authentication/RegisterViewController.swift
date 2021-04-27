//
//  RegisterViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 03/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var backgroundImageView              : UIImageView!
    @IBOutlet private weak var emailAddressTextField            : UITextField!
    @IBOutlet private weak var enterPasswordTextField           : UITextField!
    @IBOutlet private weak var mobileNumberTextField            : UITextField!
    @IBOutlet private weak var postalCodeTextField              : UITextField!
    @IBOutlet private weak var houseNoTextField                 : UITextField!
    @IBOutlet private weak var adonNoTextField                  : UITextField!
    @IBOutlet private weak var iAmCompanyButton                 : UIButton!
    @IBOutlet private weak var firstNameTextField               : UITextField!
    @IBOutlet private weak var lastNameTextField                : UITextField!
    @IBOutlet private weak var companyNameTextField             : UITextField!
    @IBOutlet private weak var companyIDNumberTextField         : UITextField!
    @IBOutlet private weak var companyDetailHeightConstraint    : NSLayoutConstraint!
    @IBOutlet private weak var registerButton                   : SpinnerButton!
    @IBOutlet private weak var privacyPolicyButton              : UIButton!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Company Detail Hide
        self.setCompanyDetailHeight(isHide: true, withAnimation: false)
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        //TextField Left Image Set
        SUtill.leftImageTextField(textField: self.emailAddressTextField, image: UIImage(named: "email")!)
        SUtill.leftImageTextField(textField: self.enterPasswordTextField, image: UIImage(named: "key")!)
        SUtill.leftImageTextField(textField: self.mobileNumberTextField, image: UIImage(named: "mobile")!)
        SUtill.leftImageTextField(textField: self.postalCodeTextField, image: UIImage(named: "postalCode")!)
        SUtill.leftImageTextField(textField: self.firstNameTextField, image: UIImage(named: "userNameLogo")!)
        SUtill.leftImageTextField(textField: self.companyNameTextField, image: UIImage(named: "company")!)
        SUtill.leftImageTextField(textField: self.companyIDNumberTextField, image: UIImage(named: "companyID")!)
        
        backgroundImageView.sd_setImage(with: SettingList.login_top_image, placeholderImage: nil)
        SUtill.settingListAPICall { [weak self] () in
            guard let `self` = self else { return }
            self.backgroundImageView.sd_setImage(with: SettingList.login_top_image, placeholderImage: nil)
        }
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
        
//        emailAddressTextField.text      = "atri211@mailinator.com"
//        enterPasswordTextField.text     = "Test@123"
//        mobileNumberTextField.text      = "9409290473"
//        postalCodeTextField.text        = "6545CA"
//        houseNoTextField.text           = "29"
//        adonNoTextField.text            = "123"
//        firstNameTextField.text         = "Atri"
//        lastNameTextField.text          = "Patel"
//        companyNameTextField.text       = "Test Company"
//        companyIDNumberTextField.text   = "1045"
    }
    
    //MARK: - Action Methods
    @IBAction private func didTapOnButtonback(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.enterPasswordTextField.isSecureTextEntry = !self.enterPasswordTextField.isSecureTextEntry
    }
    
    @IBAction private func didTapOnButtonIAmCompany(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.setCompanyDetailHeight(isHide: !sender.isSelected)
        if sender.isSelected == false {
            self.companyNameTextField.text = ""
            self.companyIDNumberTextField.text = ""
        }
    }
    
    @IBAction private func didTapOnButtonRegister(_ sender: Any) {
        if isValid() {
            registerAPICall()
        }
    }
    
    @IBAction private func didTapOnButtonPrivacyPolicy(_ sender: Any) {
        self.view.endEditing(true)
        let introductionViewController = UIStoryboard.Authentication.get(IntroductionViewController.self)!
        self.navigationController?.pushViewController(introductionViewController, animated: true)
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

//MARK: - Helper Methods
extension RegisterViewController {
    
    private func setCompanyDetailHeight(isHide : Bool, withAnimation : Bool = true) {
        self.companyDetailHeightConstraint.constant = (isHide == true) ? 0 : 130
        if (withAnimation == true) {
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    private func isValid() -> Bool {
        //Email
        if (emailAddressTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.emailAddressTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankEmailID, withActions: okButton)
            return false
        }
        if (emailAddressTextField.text?.trimmed.isValidEmail == false) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.emailAddressTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.validEmailID, withActions: okButton)
            return false
        }
        
        //Password
        if (enterPasswordTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.enterPasswordTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankPassword, withActions: okButton)
            return false
        }
//        if (enterPasswordTextField.text?.trimmedLength ?? 0 < 6) {
//            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
//                self.enterPasswordTextField.becomeFirstResponder()
//            }
//            self.showAlert(withMessage: SText.Messages.minimumCharacterPassword, withActions: okButton)
//            return false
//        }
//        if (enterPasswordTextField.text?.trimmed.isValidPassword == false) {
//            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
//                self.enterPasswordTextField.becomeFirstResponder()
//            }
//            self.showAlert(withMessage: SText.Messages.validPassword, withActions: okButton)
//            return false
//        }
        
        //Mobile Number
        if (mobileNumberTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.mobileNumberTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankPhoneNo, withActions: okButton)
            return false
        }
        
        //First Name
        if (firstNameTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.firstNameTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankFirstName, withActions: okButton)
            return false
        }
        
        //Last Name
        if (lastNameTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.lastNameTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blanklastName, withActions: okButton)
            return false
        }
        
        //Postal Code
        if (postalCodeTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.postalCodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankPostalCode, withActions: okButton)
            return false
        }
        if (postalCodeTextField.text?.trimmedLength ?? 0 < 5) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.postalCodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.minimumCharacterPostalCode, withActions: okButton)
            return false
        }
        
        if (postalCodeTextField.text?.trimmed.isValidPincode == false) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.postalCodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.validPostalCode, withActions: okButton)
            return false
        }
        
        //House No
        if (houseNoTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.houseNoTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankHouseNo, withActions: okButton)
            return false
        }
        
        if iAmCompanyButton.isSelected {
            //Company Name
            if (companyNameTextField.text?.trimmedLength == 0) {
                let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                    self.companyNameTextField.becomeFirstResponder()
                }
                self.showAlert(withMessage: SText.Messages.blankCompanyName, withActions: okButton)
                return false
            }
            
            //Company ID Number
            if (companyIDNumberTextField.text?.trimmedLength == 0) {
                let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                    self.companyIDNumberTextField.becomeFirstResponder()
                }
                self.showAlert(withMessage: SText.Messages.blankCompanyIDNumber, withActions: okButton)
                return false
            }
        }
        
        self.view.endEditing(true)
        return true
    }
    
    private func prepareDutchLanguage() {
        emailAddressTextField.placeholder       = "Ange e-postadress"
        enterPasswordTextField.placeholder      = "Ange lösenord"
        mobileNumberTextField.placeholder       = "Mobilnummer"
        postalCodeTextField.placeholder         = "Postnummer"
        houseNoTextField.placeholder            = "Husnummer"
        adonNoTextField.placeholder             = "Adon No."
        iAmCompanyButton.setTitle("Företagskund", for: .normal)
        firstNameTextField.placeholder          = "Förnamn"
        lastNameTextField.placeholder           = "Efternamn"
        companyNameTextField.placeholder        = "Företagets namn"
        companyIDNumberTextField.placeholder    = "Organisationsnummer"
        registerButton.setTitle("Registrera", for: .normal)
        privacyPolicyButton.setTitle("Integritetspolicy", for: .normal)
        iAmCompanyButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 35, bottom: 0, right: 0)
        iAmCompanyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        registerButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - TextField Delegate
extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailAddressTextField:
            self.enterPasswordTextField.becomeFirstResponder()
        case self.enterPasswordTextField:
            self.mobileNumberTextField.becomeFirstResponder()
        case self.mobileNumberTextField:
            self.firstNameTextField.becomeFirstResponder()
        case self.firstNameTextField:
            self.lastNameTextField.becomeFirstResponder()
        case self.lastNameTextField:
            postalCodeTextField.placeholder = "00000"
            self.postalCodeTextField.becomeFirstResponder()
        case self.postalCodeTextField:
            postalCodeTextField.placeholder = appLanguage == .Dutch ? "Postnummer" : "Postal Code"
            self.houseNoTextField.becomeFirstResponder()
        case self.houseNoTextField:
            self.adonNoTextField.becomeFirstResponder()
        case self.adonNoTextField:
            if (self.iAmCompanyButton.isSelected == false) {
                self.adonNoTextField.resignFirstResponder()
                if isValid() {
                    registerAPICall()
                }
            } else {
                self.companyNameTextField.becomeFirstResponder()
            }
        case companyNameTextField:
            self.companyIDNumberTextField.becomeFirstResponder()
        case self.companyIDNumberTextField:
            self.companyIDNumberTextField.resignFirstResponder()
            
            if isValid() {
                registerAPICall()
            }
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == postalCodeTextField {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if updatedText.trimmedLength > 5 {
                    return false
                }
            }
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
            return false
        }
//        switch textField {
//        case firstNameTextField, lastNameTextField:
//            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted) == nil
//            if !replacementStringIsLegal {
//                return false
//            }
//        case houseNoTextField, adonNoTextField, mobileNumberTextField:
//            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"0123456789").inverted) == nil
//            if !replacementStringIsLegal {
//                return false
//            }
//            return true
//        default: break
//        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == postalCodeTextField {
            postalCodeTextField.placeholder = "00000"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == postalCodeTextField {
            postalCodeTextField.placeholder = appLanguage == .Dutch ? "Postnummer" : "Postal Code"
        }
    }
    
}

//MARK: - API Call -
extension RegisterViewController {
    
    private func registerAPICall() {
        let param : [String  : Any] = [
                        SText.Parameter.user_email          : emailAddressTextField.text?.trimmed ?? "",
                        SText.Parameter.user_password       : enterPasswordTextField.text?.trimmed ?? "",
                        SText.Parameter.user_phone          : mobileNumberTextField.text?.trimmed ?? "",
                        SText.Parameter.postal_code         : postalCodeTextField.text?.trimmed ?? "",
                        SText.Parameter.house_no            : houseNoTextField.text?.trimmed ?? "",
                        SText.Parameter.add_on_house_no     : adonNoTextField.text?.trimmed ?? "",
                        SText.Parameter.ios_token           : DeviceToken,
                        SText.Parameter.android_token       : "",
                        SText.Parameter.is_company          : "\(iAmCompanyButton.isSelected)",
                        SText.Parameter.user_firstname      : firstNameTextField.text?.trimmed ?? "",
                        SText.Parameter.user_lastname       : lastNameTextField.text?.trimmed ?? "",
                        SText.Parameter.user_company_name   : companyNameTextField.text?.trimmed ?? "",
                        SText.Parameter.user_company_id     : companyIDNumberTextField.text?.trimmed ?? ""
                    ]
        registerButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.register(param), arrImages: [], onSuccess: { (response) in
            self.registerButton.endLoading()
            if response.success, let data = response.data {
                let user = User.init(aDict: data)
                SharedApplication.userManager?.login(user: user, flowNavigate: false)
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
        }, onFailure: { (apiErrorResponse) in
            self.registerButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
