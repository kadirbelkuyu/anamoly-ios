//
//  EmailViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 02/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class EmailViewController: BaseViewController {

    @IBOutlet private weak var presentingView   : UIView!
    @IBOutlet private weak var emailIDLabel     : UILabel!
    @IBOutlet private weak var emailTextField   : UITextField!
    @IBOutlet private weak var saveButton       : SpinnerButton!
    
    private var isAnyChangeInData   : Bool = false
    var userUpdatedBlock            : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        presentingView.topRoundCorner(radius: 10)
        
        ///User
        if let user = AppUser {
            emailTextField.text = user.user_email
        }
        
        ///Animation
        let translate = CGAffineTransform(translationX: 0, y: ScreenHeight)
        self.presentingView.transform =  translate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.presentingView.transform =  CGAffineTransform.identity
            })
        }
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonDismiss(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func didTapOnButtonSave(_ sender: Any) {
        if isValid() {
            updateEmailAPICall()
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
extension EmailViewController {
    
    private func updateEmailAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.user_email  : emailTextField.text?.trimmed ?? ""
                    ] as [String : Any]
        saveButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.updateEmail(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.saveButton.endLoading()
            if let data = response.data, response.success {
                let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
                otpViewController.emailAddress = data["user_email"].stringValue
                otpViewController.isForUpdateEmail = true
                otpViewController.userUpdateBlock = { [weak self] (user) in
                    guard let `self` = self else {return}
                    Application.shared.userManager?.login(user: user, flowNavigate: false)
                    SharedApplication.userManager?.login(user: user, flowNavigate: false)
                    self.userUpdatedBlock?()
                    SUtill.showSuccessMessage(message: response.message ?? "")
                    self.dismissViewController()
                }
                self.navigationController?.pushViewController(otpViewController, animated: true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            self.saveButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension EmailViewController {
    
    private func isValid() -> Bool {
        if (emailTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.emailTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankEmailID, withActions: okButton)
            return false
        }
        
        if (emailTextField.text?.trimmed.isValidEmail == false) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.emailTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.validEmailID, withActions: okButton)
            return false
        }
        
        if isAnyChangeInData == false {
            self.showAlert(withMessage: SText.Messages.noValidation)
            return false
        }
        self.view.endEditing(true)
        return true
    }
    
    private func dismissViewController() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func prepareDutchLanguage() {
        emailIDLabel.text           = "Ange e-postadress"
        emailTextField.placeholder  = "Ange e-postadress"
        saveButton.setTitle("Spara", for: .normal)
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - TextField Delegate
extension EmailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if isValid() {
            updateEmailAPICall()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isAnyChangeInData = true
        return true
    }
    
}
