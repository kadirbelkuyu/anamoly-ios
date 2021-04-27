//
//  ForgotPasswordViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 04/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var navigationTitleLabel             : UILabel!
    @IBOutlet private weak var forgotPasswordTitleLabel         : UILabel!
    @IBOutlet private weak var forgotPasswordDescriptionLabel   : UILabel!
    @IBOutlet private weak var emailAddressTextField            : UITextField!
    @IBOutlet private weak var sendButton                       : SpinnerButton!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - PrepareView -
    private func prepareView() {
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods
    @IBAction func didTapOnButtonBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapOnButtonSend(_ sender: Any) {
        if isValid() {
            forgotPasswrdAPICall()
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

//MARK: - TextField Delegate
extension ForgotPasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailAddressTextField:
            self.emailAddressTextField.resignFirstResponder()
            if isValid() {
                forgotPasswrdAPICall()
            }
        default:
            break
        }
        return true
    }
    
}

//MARK: - API Call -
extension ForgotPasswordViewController {
    
    private func forgotPasswrdAPICall() {
        let param = [
                        SText.Parameter.user_email : emailAddressTextField.text?.trimmed ?? ""
                    ]
        sendButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.forgotPasswrd(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.sendButton.endLoading()
            if response.success {
                SUtill.showSuccessMessage(message: response.message ?? "")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.sendButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension ForgotPasswordViewController {

    private func isValid() -> Bool {
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
        
        self.view.endEditing(true)
        return true
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text              = "Behöver du hjälp?"
        forgotPasswordTitleLabel.text          = "Glömt lösenord?"
        forgotPasswordDescriptionLabel.text    = "Vi kommer nu att skicka en länk till din epost för att bekräfta ditt lösenord."
        emailAddressTextField.placeholder      = "Din e-postadress"
        sendButton.setTitle("Skicka", for: .normal)
        sendButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}
