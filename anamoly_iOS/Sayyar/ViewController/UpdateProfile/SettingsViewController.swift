//
//  SettingsViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 05/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var navigationTitleLabel             : UILabel!
    @IBOutlet private weak var appSettingsTitleLabel            : UILabel!
    @IBOutlet private weak var appSettingsDescriptionLabel      : UILabel!
    @IBOutlet private weak var generalPushNotificationsLabel    : UILabel!
    @IBOutlet private weak var generalPushNotificationsSwitch   : UISwitch!
    @IBOutlet private weak var pushNotificationOnOrdersLabel    : UILabel!
    @IBOutlet private weak var pushNotificationOnOrdersSwitch   : UISwitch!
    @IBOutlet private weak var generalEmailsLabel               : UILabel!
    @IBOutlet private weak var generalEmailsSwitch              : UISwitch!
    @IBOutlet private weak var emailsOnOrdersLabel              : UILabel!
    @IBOutlet private weak var emailsOnOrdersSwitch             : UISwitch!
    @IBOutlet private weak var saveAndContinueButton            : SpinnerButton!
    
    var statusCode  : Int       = 0
    var emailID     : String    = ""
    var waitingNo   : Int       = 0
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        if let setting = AppUser?.settings {
            generalPushNotificationsSwitch.setOn(setting.general_notifications, animated: false)
            pushNotificationOnOrdersSwitch.setOn(setting.order_notifications, animated: false)
            generalEmailsSwitch.setOn(setting.general_emails, animated: false)
            emailsOnOrdersSwitch.setOn(setting.order_emails, animated: false)
        }
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonSaveAndContinue(_ sender: Any) {
        updateNameAPICall()
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

//MARK: - API Call -
extension SettingsViewController {
    
    private func updateNameAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id                 : user.user_id ?? 0,
                        SText.Parameter.general_notifications   : generalPushNotificationsSwitch.isOn ? 1 : 0,
                        SText.Parameter.order_notifications     : pushNotificationOnOrdersSwitch.isOn ? 1 : 0,
                        SText.Parameter.general_emails          : generalEmailsSwitch.isOn ? 1 : 0,
                        SText.Parameter.order_emails            : emailsOnOrdersSwitch.isOn ? 1 : 0
                    ] as [String : Any]
        
        saveAndContinueButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.updateSetting(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            self.saveAndContinueButton.endLoading()
            if let data = response.data, response.success {
                if let settings = user.settings {
                    settings.general_notifications = data["general_notifications"].intValue == 1 ? true : false
                    settings.order_notifications   = data["order_notifications"].intValue == 1 ? true : false
                    settings.general_emails        = data["general_emails"].intValue == 1 ? true : false
                    settings.order_emails          = data["order_emails"].intValue == 1 ? true : false
                    Application.shared.userManager?.login(user: user, flowNavigate: false)
                    SharedApplication.userManager?.login(user: user, flowNavigate: false)
                    SUtill.showSuccessMessage(message: response.message ?? "")
                    self.navigationManage()
                } else {
                    self.navigationManage()
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            self.saveAndContinueButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension SettingsViewController {
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text           = "Inställningar"
        appSettingsTitleLabel.text          = "App inställningar"
        appSettingsDescriptionLabel.text    = "Hantera notiser och epost inställningar"
        generalPushNotificationsLabel.text  = "Allmänna push-notiser"
        pushNotificationOnOrdersLabel.text  = "Push-notiser av order"
        generalEmailsLabel.text             = "Allmänna e-postadresser"
        emailsOnOrdersLabel.text            = "E-postadresser på order"
        saveAndContinueButton.setTitle("Spara och fortsätt", for: .normal)
        saveAndContinueButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    private func navigationManage() {
        if statusCode == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            if statusCode == 108, emailID.trimmedLength > 0 {
                let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
                otpViewController.emailAddress = emailID.trimmed
                self.navigationController?.pushViewController(otpViewController, animated: true)
            } else if statusCode == 106, waitingNo > 0 {
                let waitingListOneViewController = UIStoryboard.Introduction.get(WaitingListOneViewController.self)!
                waitingListOneViewController.waitingListNo = waitingNo
                let navigationViewController = UINavigationController(rootViewController: waitingListOneViewController)
                navigationViewController.modalPresentationStyle = .overFullScreen
                navigationViewController.isNavigationBarHidden  = true
                navigationViewController.navigationBar.isHidden = true
                self.navigationController?.present(navigationViewController, animated: true, completion: nil)
            } else if statusCode == 105 {
                let noDeliveryViewController = UIStoryboard.Introduction.get(NoDeliveryViewController.self)!
                noDeliveryViewController.modalPresentationStyle = .overFullScreen
                self.present(noDeliveryViewController, animated: true, completion: nil)
            } else {
                Application.shared.window?.rootViewController = UIStoryboard.Main.instantiateInitialViewController()
            }
        }
    }
    
}
