//
//  OTPViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class OTPViewController: BaseViewController {
    
    @IBOutlet private weak var navigationTitleLabel         : UILabel!
    @IBOutlet private weak var verificationTitleLabel       : UILabel!
    @IBOutlet private weak var verificationDescriptionLabel : UILabel!
    @IBOutlet private weak var OTPView                      : VPMOTPView!
    @IBOutlet private weak var verifyButton                 : SpinnerButton!
    @IBOutlet private weak var resendButton                 : SpinnerButton!
    
    var emailAddress        : String    = ""
    var isForUpdateEmail    : Bool      = false
    private var enteredOtp  : String    = ""
    var userUpdateBlock     : ((User) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        verificationDescriptionLabel.text = "Please type the verification code sent to " + emailAddress
        
        //OTP View
        self.OTPView.otpFieldsCount                 = 6
        self.OTPView.otpFieldDefaultBorderColor     = ColorApp.ColorRGB(65,23,116,1)
        self.OTPView.otpFieldEnteredBorderColor     = ColorApp.ColorRGB(65,23,116,1)
        self.OTPView.otpFieldErrorBorderColor       = ColorApp.ColorRGB(65,23,116,1)
        self.OTPView.otpFieldBorderWidth            = 0.0
        self.OTPView.delegate                       = self
        self.OTPView.shouldAllowIntermediateEditing = true
        self.OTPView.otpFieldDisplayType            = .underlinedBottom
        self.OTPView.cursorColor                    = ColorApp.ColorRGB(65,23,116,1)
        self.OTPView.otpFieldSeparatorSpace         = 9.0
        self.OTPView.otpFieldSize                   = (ScreenWidth - 85) / 6    // 45 (5 * 9) + 60 (20 * 2)
        self.OTPView.initializeUI()
        self.OTPView.becomeFirstResponderWithTag()
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }

    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonVerify(_ sender: Any) {
        if enteredOtp.trimmedLength == 6 {
            isForUpdateEmail ? verifyUserEmailAPICall() : verifyEmailAPICall()
        } else {
            self.showAlert(withMessage: SText.Messages.minimumCharacterOTP)
        }
    }
    
    @IBAction private func didTapOnButtonResend(_ sender: Any) {
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

//MARK: - OTP View Delegate
extension OTPViewController : VPMOTPViewDelegate {

    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return enteredOtp == "123456"
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
    }

}

//MARK: - API Call -
extension OTPViewController {
    
    private func verifyEmailAPICall() {
        let param = [
                        SText.Parameter.user_email  : emailAddress,
                        SText.Parameter.otp         : enteredOtp
                    ] as [String : Any]
        verifyButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.verifyEmail(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.verifyButton.endLoading()
            if response.success, let data = response.data {
                let user = User.init(aDict: data)
                if user.is_email_verified == false {
                    let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
                    otpViewController.emailAddress = user.user_email
                    self.navigationController?.pushViewController(otpViewController, animated: true)
                } else {
                    SharedApplication.userManager?.login(user: user, flowNavigate: false)
                    let appIntroViewController = UIStoryboard.Introduction.get(AppIntroViewController.self)!
                    self.navigationController?.pushViewController(appIntroViewController, animated: true)
                }
            } else {
                let appIntroViewController = UIStoryboard.Introduction.get(AppIntroViewController.self)!
                appIntroViewController.statusCode   = response.status
                if let data = response.data {
                    appIntroViewController.emailID      = data["user_email"].stringValue.trimmed
                    appIntroViewController.waitingNo    = data["req_queue"].intValue
                }
                self.navigationController?.pushViewController(appIntroViewController, animated: true)
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let `self` = self else {return}
            self.verifyButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func verifyUserEmailAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.user_email  : emailAddress,
                        SText.Parameter.otp         : enteredOtp
                    ] as [String : Any]
        verifyButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.verifyUserEmail(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.verifyButton.endLoading()
            if response.success, let data = response.data {
                let user = User.init(aDict: data)
                if user.is_email_verified == false {
                    let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
                    otpViewController.emailAddress = user.user_email
                    self.navigationController?.pushViewController(otpViewController, animated: true)
                } else {
                    SUtill.showSuccessMessage(message: response.message ?? "")
                    self.navigationController?.popViewController(animated: true)
                    self.userUpdateBlock?(user)
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
            self.verifyButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension OTPViewController {
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text           = "OTP"
        verificationTitleLabel.text         = "Verifieringskod"
        verificationDescriptionLabel.text   = "Strax hos dig " + emailAddress
        verifyButton.setTitle("Godkänn", for: .normal)
        resendButton.setTitle("Skicka om", for: .normal)
        verifyButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        resendButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}
