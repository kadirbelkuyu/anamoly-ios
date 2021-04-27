//
//  ShareApplicationViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class ShareApplicationViewController: BaseViewController {

    @IBOutlet private weak var navigationTitleLabel                 : UILabel!
    @IBOutlet private weak var shareAppWithFriendLabel              : UILabel!
    @IBOutlet private weak var shareAppWithFriendDescriptionlabel   : UILabel!
    @IBOutlet private weak var discountCodeLabel                    : UILabel!
    @IBOutlet private weak var discountLabel                        : UILabel!
    @IBOutlet private weak var facebookButton                       : UIButton!
    @IBOutlet private weak var whatsappButon                        : UIButton!
    @IBOutlet private weak var emailButton                          : UIButton!
    @IBOutlet private weak var termsAndConditionApplyLabel          : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        couponListAPICall()
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonFacebook(_ sender: Any) {
    }
    
    @IBAction private func didTapOnButtonWhatsapp(_ sender: Any) {
    }
    
    @IBAction private func didTapOnButtonEmail(_ sender: Any) {
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
extension ShareApplicationViewController {
    
    private func couponListAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.couponList(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                print(data)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension ShareApplicationViewController {
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text               = "Dela app"
        shareAppWithFriendLabel.text            = "Dela appen med dina vänner."
        shareAppWithFriendDescriptionlabel.text = "Här kan varje användare dela den här appen via Facebook, WhatsApp eller e-post och kan få rabattkod om vänner registrerar sig. Både vännen och användaren kommer att få denna rabattkod."
        facebookButton.setTitle("Facebook", for: .normal)
        whatsappButon.setTitle("WhatsApp", for: .normal)
        emailButton.setTitle("E-mail", for: .normal)
        facebookButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        whatsappButon.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        emailButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        termsAndConditionApplyLabel.text        = "*Godkänn villkor"
    }
    
}
