//
//  CheckoutViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 10/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController {

    @IBOutlet private weak var navigationTitleLabel : UILabel!
    @IBOutlet private weak var addressTitleLabel    : UILabel!
    @IBOutlet private weak var deliveryAddressLabel : UILabel!
    @IBOutlet private weak var doYouHaveCouponLabel : UILabel!
    @IBOutlet private weak var amountTitleLabel     : UILabel!
    @IBOutlet private weak var amountLabel          : UILabel!
    @IBOutlet private weak var howToPayTitleLabel   : UILabel!
    @IBOutlet private weak var payBacgroundView     : UIView!
    @IBOutlet private weak var idealView            : UIView!
    @IBOutlet private weak var idealLabel           : UILabel!
    @IBOutlet private weak var cashOnDeliveryView   : UIView!
    @IBOutlet private weak var cashOnDeliveryLabel  : UILabel!
    @IBOutlet private weak var continueButton       : SpinnerButton!
    
    var deliveryTimeSlotSelected    : DeliveryTimeSlot?
    var selectedCouponCodeModel     : CouponCodeModel?
    var couponCodeString            : String    = ""
    var totalCartAmount             : String    = ""
    var isExpressDelivery           : Bool      = false
    private var isCOD               : Bool      = false
    var selectedAddresses           : Addresses?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
        
        if let user = AppUser {
            setUser(user: user)
        }
        
        amountLabel.text            = totalCartAmount
        idealView.isHidden          = SettingList.enable_ideal_payment ? false : true
        cashOnDeliveryView.isHidden = SettingList.enable_code_payment ? false : true
        
        if idealView.isHidden == true {
            setPayment(isCOD: true)
        }
        if cashOnDeliveryView.isHidden == true {
            setPayment(isCOD: false)
        }
    }
    
    //MARK: - Action Methods -
    @IBAction func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapOnButtonDeliveryAddress(_ sender: Any) {
        let addressViewController = UIStoryboard.UpdateProfile.get(AddressViewController.self)!
        addressViewController.modalPresentationStyle = .overFullScreen
        addressViewController.modalTransitionStyle = .crossDissolve
        addressViewController.isForUpdateAddress = false
        addressViewController.selectedAddresses = selectedAddresses
        addressViewController.deliveryAddressUpdateBlock = { [weak self] (addresses) in
            guard let `self` = self else {return}
            self.selectedAddresses = addresses
            self.setAddresses(addresses: addresses)
        }
        self.present(addressViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapOnButtonCouponCode(_ sender: Any) {
        let couponCodeViewController = UIStoryboard.Cart.get(CouponCodeViewController.self)!
        couponCodeViewController.modalPresentationStyle = .overFullScreen
        couponCodeViewController.modalTransitionStyle = .crossDissolve
        couponCodeViewController.couponApplyBlock = { [weak self] (selectedCouponCodeModel) in
            guard let `self` = self else {return}
            self.selectedCouponCodeModel = selectedCouponCodeModel
            self.couponCodeString = selectedCouponCodeModel.coupon_code ?? ""
        }
        self.present(couponCodeViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapOnButtonIdeal(_ sender: Any) {
        setPayment(isCOD: false)
    }
    
    @IBAction func didTapOnButtonCashOnDelivery(_ sender: Any) {
        setPayment(isCOD: true)
    }
    
    @IBAction func didTapOnButtonContinue(_ sender: Any) {
        orderSendAPICall()
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

//MARK: - Helper Methods -
extension CheckoutViewController {
    
    private func setUser(user : User) {
        if user.addresses.count > 0 {
            deliveryAddressLabel.text   = user.addresses[0].fullAddress
        }
    }
    
    private func setAddresses(addresses : Addresses) {
        deliveryAddressLabel.text   = addresses.fullAddress
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text   = "Till betalning"
        addressTitleLabel.text      = "Adress"
        doYouHaveCouponLabel.text   = "Har du kupong?"
        amountTitleLabel.text       = "Summa"
        howToPayTitleLabel.text     = "Hur vill du betala?"
        cashOnDeliveryLabel.text    = "Betala vid dörren"
        continueButton.setTitle("Fortsätt", for: .normal)
        continueButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    private func setPayment(isCOD : Bool) {
        if isCOD {
            UIView.animate(withDuration: 0.5, animations: { [weak self] () in
                guard let `self` = self else {return}
                self.payBacgroundView.center.y = self.cashOnDeliveryView.center.y
                self.idealView.backgroundColor = .white
                self.cashOnDeliveryView.backgroundColor = .clear
                self.idealLabel.textColor = .darkGray
                self.cashOnDeliveryLabel.textColor = .white
                self.isCOD = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { [weak self] () in
                guard let `self` = self else {return}
                self.payBacgroundView.center.y = self.idealView.center.y
                self.idealView.backgroundColor = .clear
                self.cashOnDeliveryView.backgroundColor = .white
                self.idealLabel.textColor = .white
                self.cashOnDeliveryLabel.textColor = .darkGray
                self.isCOD = false
            })
        }
        payBacgroundView.backgroundColor = SettingList.header_color
    }
    
    func successWithOderID(url : URL) {
        if url.absoluteString.containsIgnoringCase(find: "anamoly://success") {
            print(url)
            if (url.lastPathComponent).trimmedLength > 0 {
                orderListAPICall(orderID: Int(url.lastPathComponent as String) ?? 0)
            }
        } else if url.absoluteString.containsIgnoringCase(find: "anamoly://failed") {
            self.navigationController?.popToRootViewController(animated: true)
            SUtill.showErrorToastMessage(title: appLanguage == .Dutch ? "Niet Gelukt!" : "Did not succeed!", message: appLanguage == .Dutch ? "Probeer het opnieuw." : "Please try again.")
        }
    }
    
}

//MARK: - API Call -
extension CheckoutViewController {
    
    private func orderSendAPICall() {
        guard let user = AppUser else {return}
        guard AppUser?.addresses.count ?? 0 > 0, let address = AppUser?.addresses[0] else {return}
        guard let deliveryTimeSlot = deliveryTimeSlotSelected else {return}
        var time : String = ""
//        if appLanguage == .Dutch {
            if let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime, identifier: appLanguage.language),
                let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime, identifier: appLanguage.language) {
                time = DateApp.string(fromDate: fromDate, withFormat: .time, identifier: appLanguage.language) + " - " + DateApp.string(fromDate: toDate, withFormat: .time, identifier: appLanguage.language)
            }
//        } else {
//            if let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime),
//                let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime) {
//                time = DateApp.string(fromDate: fromDate, withFormat: .time) + " - " + DateApp.string(fromDate: toDate, withFormat: .time)
//            }
//        }
        
        let param = [
                        SText.Parameter.user_id         : user.user_id ?? 0,
                        SText.Parameter.delivery_date   : deliveryTimeSlot.date ?? "",
                        SText.Parameter.delivery_time   : time,
                        SText.Parameter.postal_code     : address.postal_code ?? "",
                        SText.Parameter.house_no        : address.house_no ?? "",
                        SText.Parameter.add_on_house_no : address.add_on_house_no ?? "",
                        SText.Parameter.street_name     : address.street_name ?? "",
                        SText.Parameter.city            : address.city ?? "",
                        SText.Parameter.area            : address.area ?? "",
                        SText.Parameter.latitude        : address.latitude ?? "",
                        SText.Parameter.longitude       : address.longitude ?? "",
                        SText.Parameter.coupon_code     : couponCodeString,
                        SText.Parameter.order_note      : "",
                        SText.Parameter.paid_by         : isCOD ? "cod" : "ideal",
                        SText.Parameter.is_express      : isExpressDelivery ? "1" : "0"
                    ] as [String : Any]
        
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.orderSend(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                if self.isCOD == true {
                    let orderCompletionViewController = UIStoryboard.Cart.get(OrderCompletionViewController.self)!
                    orderCompletionViewController.myOrderDetail = MyOrderDetail.init(aDict: data)
                    self.navigationController?.pushViewController(orderCompletionViewController, animated: true)
                } else {
//                    let appInstructionViewController = UIStoryboard.Profile.get(AppInstructionViewController.self)!
//                    appInstructionViewController.navigationTitle = "iDeal Payment"
//                    appInstructionViewController.loadURL = URL(string: data["responseURL"].stringValue)
//                    self.navigationController?.pushViewController(appInstructionViewController, animated: true)
                    if let url = URL(string: data["responseURL"].stringValue) {
                        UIApplication.shared.open(url)
                    }
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func orderListAPICall(orderID : Int) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.order_id    : orderID
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.orderList(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                let orderCompletionViewController = UIStoryboard.Cart.get(OrderCompletionViewController.self)!
                orderCompletionViewController.myOrderDetail = MyOrderDetail.init(aDict: data)
                self.navigationController?.pushViewController(orderCompletionViewController, animated: true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
