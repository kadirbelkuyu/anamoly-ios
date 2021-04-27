//
//  AddressViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 02/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class AddressViewController: BaseViewController {

    @IBOutlet private weak var presentingView       : UIView!
    
    @IBOutlet private weak var deliveryAddressLabel : UILabel!
    @IBOutlet private weak var pincodeLabel         : UILabel!
    @IBOutlet private weak var houseNoLabel         : UILabel!
    @IBOutlet private weak var houseAdOnLabel       : UILabel!
    @IBOutlet private weak var areaLabel            : UILabel!
    @IBOutlet private weak var streetLabel          : UILabel!

    @IBOutlet private weak var pincodeTextField     : UITextField!
    @IBOutlet private weak var houseNoTextField     : UITextField!
    @IBOutlet private weak var houseAdOnTextField   : UITextField!
    @IBOutlet private weak var areaTextField        : UITextField!
    @IBOutlet private weak var streetTextField      : UITextField!
    @IBOutlet private weak var changeAddressButton  : SpinnerButton!
    
    private var isAnyChangeInData   : Bool = false
    var userUpdatedBlock            : (() -> ())?
    var isForUpdateAddress          : Bool = false
    var deliveryAddressUpdateBlock  : ((Addresses) -> ())?
    var selectedAddresses           : Addresses?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        presentingView.topRoundCorner(radius: 10)
        
        ///User
        if let address = selectedAddresses {
            pincodeTextField.text   = address.postal_code.uppercased()
            houseNoTextField.text   = address.house_no
            houseAdOnTextField.text = address.add_on_house_no
            areaTextField.text      = address.city
            streetTextField.text    = address.street_name
        } else if AppUser?.addresses.count ?? 0 > 0, let address = AppUser?.addresses[0] {
            pincodeTextField.text   = address.postal_code.uppercased()
            houseNoTextField.text   = address.house_no
            houseAdOnTextField.text = address.add_on_house_no
            areaTextField.text      = address.city
            streetTextField.text    = address.street_name
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
            if isForUpdateAddress {
                updateAddressAPICall()
            } else {
                validateAddressAPICall()
            }
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
extension AddressViewController {
    
    private func updateAddressAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id         : user.user_id ?? 0,
                        SText.Parameter.postal_code     : pincodeTextField.text?.trimmed ?? "",
                        SText.Parameter.house_no        : houseNoTextField.text?.trimmed ?? "",
                        SText.Parameter.add_on_house_no : houseAdOnTextField.text?.trimmed ?? "",
                        SText.Parameter.area            : areaTextField.text?.trimmed ?? "",
                        SText.Parameter.street_name     : streetTextField.text?.trimmed ?? "",
                        SText.Parameter.latitude        : "",
                        SText.Parameter.longitude       : ""
                    ] as [String : Any]
        changeAddressButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.updateAddress(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            self.changeAddressButton.endLoading()
            if let data = response.data, response.success, response.status == 200 {
                if user.addresses.count > 0, let address = user.addresses.first {
                    address.postal_code     = data["postal_code"].stringValue
                    address.house_no        = data["house_no"].stringValue
                    address.add_on_house_no = data["add_on_house_no"].stringValue
                    address.area            = data["area"].stringValue
                    address.city            = data["city"].stringValue
                    address.street_name     = data["street_name"].stringValue
                    Application.shared.userManager?.login(user: user, flowNavigate: false)
                    SharedApplication.userManager?.login(user: user, flowNavigate: false)
                    self.userUpdatedBlock?()
                    SUtill.showSuccessMessage(message: response.message ?? "")
                    self.dismissViewController()
                } else {
                    self.dismissViewController()
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            self.changeAddressButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func validateAddressAPICall() {
        let param = [
                        SText.Parameter.postal_code : pincodeTextField.text?.trimmed ?? "",
                        SText.Parameter.house_no    : houseNoTextField.text?.trimmed ?? ""
                    ] as [String : Any]
        changeAddressButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.validateAddress(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.changeAddressButton.endLoading()
            if let data = response.data, response.success, response.status == 200 {
                let addresses = Addresses.init(aDict: data)
                addresses.add_on_house_no = self.houseAdOnTextField.text?.trimmed
                self.deliveryAddressUpdateBlock?(addresses)
                self.dismissViewController()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
            }, onFailure: { [weak self] (apiErrorResponse) in
                guard let `self` = self else {return}
                self.changeAddressButton.endLoading()
                self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension AddressViewController {
    
    private func isValid() -> Bool {
        
        if (pincodeTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.self.pincodeTextField.placeholder = "00000"
                self.pincodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankPincode, withActions: okButton)
            return false
        }
        
        if (pincodeTextField.text?.trimmedLength ?? 0 < 5) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.self.pincodeTextField.placeholder = "00000"
                self.pincodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.minimumCharacterPostalCode, withActions: okButton)
            return false
        }
        
        if (pincodeTextField.text?.trimmed.isValidPincode == false) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.self.pincodeTextField.placeholder = "00000"
                self.pincodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.validPostalCode, withActions: okButton)
            return false
        }
        
        if (houseNoTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.houseNoTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankHouseNo, withActions: okButton)
            return false
        }
        
//
        
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
    
//    private func isValidForAPI() {
//        if pincodeTextField.text?.trimmedLength ?? 0 > 0 && houseNoTextField.text?.trimmedLength ?? 0 > 0 {
//            validateAddressAPICall()
//        }
//    }
    
    private func prepareDutchLanguage() {
        deliveryAddressLabel.text       = "Adress"
        pincodeLabel.text               = "Postnummer"
        houseNoLabel.text               = "Husnummer"
        houseAdOnLabel.text             = "Adon No."
        areaLabel.text                  = "Stad"
        streetLabel.text                = "Gata"
        
        pincodeTextField.placeholder    = "Postnummer"
        houseNoTextField.placeholder    = "Husnummer"
        houseAdOnTextField.placeholder  = "Adon No."
        areaTextField.placeholder       = "Stad"
        streetTextField.placeholder     = "Gata"
        changeAddressButton.setTitle("Byt adress", for: .normal)
        changeAddressButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - TextField Delegate
extension AddressViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case pincodeTextField:
            pincodeTextField.placeholder = NSLocalizedString("Postal Code", comment: "Postal Code")
            houseNoTextField.becomeFirstResponder()
        case houseNoTextField:
            houseAdOnTextField.becomeFirstResponder()
        case houseAdOnTextField:
            houseAdOnTextField.resignFirstResponder()
            if isValid() {
                updateAddressAPICall()
            }
        default: break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isAnyChangeInData = true
        
        if textField == pincodeTextField {
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
//        case houseNoTextField, houseAdOnTextField:
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
        if textField == pincodeTextField {
            self.self.pincodeTextField.placeholder = "00000"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pincodeTextField {
            pincodeTextField.placeholder = NSLocalizedString("Postal Code", comment: "Postal Code")
        }
//        isValidForAPI()
    }
    
}
