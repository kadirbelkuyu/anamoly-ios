//
//  ContactUsViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import MessageUI
import KMPlaceholderTextView

class ContactUsViewController: BaseViewController {

    @IBOutlet private weak var navigationTitleLabel     : UILabel!
    @IBOutlet private weak var howMayIHelpYouLabel      : UILabel!
    @IBOutlet private weak var feelFeeToContactUsLabel  : UILabel!
    @IBOutlet private weak var fullNameTextField        : UITextField!
    @IBOutlet private weak var phoneNoTextField         : UITextField!
    @IBOutlet private weak var messageTextView          : KMPlaceholderTextView!
    @IBOutlet private weak var sendButton               : SpinnerButton!
    @IBOutlet private weak var quickContactLabel        : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        messageTextView.tintColor = .black
        messageTextView.placeholder = NSLocalizedString("Write your message here…", comment: "Write your message here…")
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnbuttonSend(_ sender : UIButton) {
        if isValid() {
            sendContactAPICall()
        }
    }
    
    @IBAction private func didTapOnButtonCall(_ sender: Any) {
        callPhoneNumber(phoneNo: SettingList.app_contact)
    }
    
    @IBAction private func didTapOnButtonEmail(_ sender: Any) {
        callEmail(mailTo: SettingList.app_email, body: "")
    }
    
    @IBAction private func didTapOnButtonWhatsapp(_ sender: Any) {
        let phoneNumber = SettingList.app_contact ?? ""
        let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
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
extension ContactUsViewController {
    
    private func sendContactAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.fullname    : fullNameTextField.text?.trimmed ?? "",
                        SText.Parameter.phone       : phoneNoTextField.text?.trimmed ?? "",
                        SText.Parameter.message     : messageTextView.text.trimmed
                    ] as [String : Any]
        sendButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.sendContact(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.sendButton.startLoading()
            if response.success {
                SUtill.showSuccessMessage(message: response.message ?? "")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.sendButton.startLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK : Helper Methods -
extension ContactUsViewController {
    
    private func isValid() -> Bool {
        if fullNameTextField.text?.trimmedLength ?? 0 == 0 {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
                self.fullNameTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankFullName, withActions: okButton)
            return false
        }
        
        if phoneNoTextField.text?.trimmedLength ?? 0 == 0 {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
                self.phoneNoTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankPhoneNo, withActions: okButton)
            return false
        }
        
        if messageTextView.text.trimmedLength == 0 {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
                self.messageTextView.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blnakMessage, withActions: okButton)
            return false
        }
        return true
    }
    
}

//MARK: - TextField Delegate -
extension ContactUsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            phoneNoTextField.becomeFirstResponder()
        case phoneNoTextField:
            messageTextView.becomeFirstResponder()
        default: break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case fullNameTextField:
            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted) == nil
            if !replacementStringIsLegal {
                return false
            }
        case phoneNoTextField:
            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:"0123456789").inverted) == nil
            if !replacementStringIsLegal {
                return false
            }
        default: break
        }
        return true
    }
    
}

//MARK: - Helper Methods -
extension ContactUsViewController {
    
    private func callEmail(mailTo : String, body : String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailTo])
            mail.setMessageBody("<p>\(body)</p>", isHTML: true)
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    private func callPhoneNumber(phoneNo : String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNo)"), UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
            // show failure alert
        }
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text       = "Kontakta oss"
        howMayIHelpYouLabel.text        = "Hur kan jag hjälpa dig?"
        feelFeeToContactUsLabel.text    = "Du kan alltid kontakta oss för support"
        fullNameTextField.placeholder   = "Fullständig namn"
        phoneNoTextField.placeholder    = "Telefonnummer"
        messageTextView.placeholder     = "Skriv ditt meddelande här..."
        sendButton.setTitle("Skicka", for: .normal)
        sendButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        quickContactLabel.text          = "Snabb kontakt"
    }
    
}

//MARK: - Mail Delegate
extension ContactUsViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
