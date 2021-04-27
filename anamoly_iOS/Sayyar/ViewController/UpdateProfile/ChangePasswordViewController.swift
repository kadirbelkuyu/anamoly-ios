//
//  ChangePasswordViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet private weak var presentingView           : UIView!
    @IBOutlet private weak var changePasswordLabel      : UILabel!
    @IBOutlet private weak var newPasswordLabel         : UILabel!
    @IBOutlet private weak var confirmNewPasswordLabel  : UILabel!
    
    @IBOutlet private weak var oldTextField             : UITextField!
    @IBOutlet private weak var newTextField             : UITextField!
    @IBOutlet private weak var confirmTextField         : UITextField!
    @IBOutlet private weak var saveButton               : SpinnerButton!
    
    var userUpdatedBlock : (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        presentingView.topRoundCorner(radius: 10)
        
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
    @IBAction private func didTapOnButtonShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 0:
            oldTextField.isSecureTextEntry = !oldTextField.isSecureTextEntry
        case 1:
            newTextField.isSecureTextEntry = !newTextField.isSecureTextEntry
        case 2:
            confirmTextField.isSecureTextEntry = !confirmTextField.isSecureTextEntry
        default: break
        }
    }
    
    @IBAction private func didTapOnButtonSave(_ sender: Any) {
        if isValid() {
            updateNameAPICall()
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
extension ChangePasswordViewController {
    
    private func updateNameAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.c_password  : oldTextField.text?.trimmed ?? "",
                        SText.Parameter.n_password  : newTextField.text?.trimmed ?? "",
                        SText.Parameter.r_password  : confirmTextField.text?.trimmed ?? ""
                    ] as [String : Any]
        saveButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.changePassword(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            self.saveButton.endLoading()
            if response.success {
                self.userUpdatedBlock?()
                self.dismissViewController()
                SUtill.showSuccessMessage(message: response.message ?? "")
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
extension ChangePasswordViewController {
    
    private func isValid() -> Bool {
        ///Current
        if (oldTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.oldTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankCurrentPassword, withActions: okButton)
            return false
        }
        
        ///New
        if (newTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.newTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankNewPassword, withActions: okButton)
            return false
        }
        if (newTextField.text?.trimmedLength ?? 0 < 6) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.newTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.minimumCharacterNewPassword, withActions: okButton)
            return false
        }
        if (newTextField.text?.trimmed.isValidPassword == false) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.newTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.validPassword, withActions: okButton)
            return false
        }
        if (oldTextField.text?.trimmed == newTextField.text?.trimmed) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.newTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.notSamePassword, withActions: okButton)
            return false
        }
        
        ///Confirm
        if (confirmTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.confirmTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankConfirmNewPassword, withActions: okButton)
            return false
        }
        
        if (newTextField.text?.trimmed != confirmTextField.text?.trimmed) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.confirmTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.samePassword, withActions: okButton)
            return false
        }
        
        self.view.endEditing(true)
        return true
    }
    
    private func dismissViewController() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { (status) in
            SharedApplication.userManager?.logout()
        }
    }
    
    private func prepareDutchLanguage() {
        changePasswordLabel.text        = "Nuvarande lösenord"
        newPasswordLabel.text           = "Nytt lösenord"
        confirmNewPasswordLabel.text    = "Bekräfta lösenord"
        oldTextField.placeholder        = "Nuvarande lösenord"
        newTextField.placeholder        = "Nytt lösenord"
        confirmTextField.placeholder    = "Bekräfta lösenord"
        saveButton.setTitle("Spara", for: .normal)
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - TextField Delegate
extension ChangePasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case oldTextField:
            newTextField.becomeFirstResponder()
        case newTextField:
            confirmTextField.becomeFirstResponder()
        case confirmTextField:
            confirmTextField.resignFirstResponder()
            if isValid() {
                updateNameAPICall()
            }
        default: break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn:" ").inverted) == nil
        if replacementStringIsLegal {
            return false
        }
        return true
    }
    
}
