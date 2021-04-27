//
//  CouponCodeViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 10/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class CouponCodeViewController: BaseViewController {
    
    @IBOutlet private weak var presentingView       : UIView!
    @IBOutlet private weak var navigationTitleLabel: UILabel!
    @IBOutlet private weak var couponCodeTextField  : UITextField!
    @IBOutlet private weak var verifyAndApplyButton : SpinnerButton!
    
    var couponApplyBlock : ((CouponCodeModel) -> ())?

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
    
    @IBAction private func didTapOnButtonVerifyAndApply(_ sender: Any) {
        if isValid() {
            couponValidateAPICall()
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
extension CouponCodeViewController {
    
    private func couponValidateAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.coupon_code : couponCodeTextField.text?.trimmed ?? ""
                    ] as [String : Any]
        verifyAndApplyButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.couponValidate(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.verifyAndApplyButton.endLoading()
            if let data = response.data, response.success {
                self.couponApplyBlock?(CouponCodeModel.init(aDict: data))
                let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { [weak self] (status) in
                    guard let `self` = self else {return}
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
                        guard let `self` = self else {return}
                        self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
                    }) { [weak self] (status) in
                        guard let `self` = self else {return}
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                self.showAlert(withMessage: response.message ?? "", withActions: okButton)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            self.verifyAndApplyButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension CouponCodeViewController {
    
    private func isValid() -> Bool {
        if couponCodeTextField.text?.trimmedLength ?? 0 == 0 {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { [weak self] (action) in
                guard let `self` = self else {return}
                self.couponCodeTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankCouponCode, withActions: okButton)
            return false
        }
        
        return true
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text       = "Kupong kod"
        couponCodeTextField.placeholder = "Skriv kupong koden här"
        verifyAndApplyButton.setTitle("Spara", for: .normal)
        verifyAndApplyButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - TextField Delegate
extension CouponCodeViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if isValid() {
            couponValidateAPICall()
        }
        return true
    }
    
}
