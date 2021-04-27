//
//  CartViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController {
    
    @IBOutlet private weak var navigationTitleLabel             : UILabel!
    @IBOutlet private weak var deliveryTitleLabel               : UILabel!
    @IBOutlet private weak var deliveryTimeSlotLabel            : UILabel!
    @IBOutlet private weak var expressDeliveryLabel             : UILabel!
    @IBOutlet private weak var exressDeliveryView               : UIView!
    @IBOutlet private weak var cartItemTableView                : UITableView!
    @IBOutlet private weak var discountTitleLabel               : UILabel!
    @IBOutlet private weak var discountLabel                    : UILabel!
    @IBOutlet private weak var totalAmountTitleLabel            : UILabel!
    @IBOutlet private weak var totalAmountLabel                 : UILabel!
    @IBOutlet private weak var cartBottomViewHeightConstraint   : NSLayoutConstraint!
    @IBOutlet private weak var continueButton                   : SpinnerButton!
    
    private var deliveryTimeSlotSelected    : DeliveryTimeSlot?
    private var cartProductArray            : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartListAPICall()
        setDeliveryLabel()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        timeSlotsAPICall()
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonCartDelete(_ sender : UIButton) {
        if cartProductArray.count > 0 {
            let deleteButton = UIAlertAction(title: SText.Button.DELETE, style: .destructive) { [weak self] (action) in
                guard let `self` = self else {return}
                self.cartCleanAPICall()
            }
            let cancelButton = UIAlertAction(title: SText.Button.CANCEL, style: .cancel, handler: nil)
            self.showAlert(withMessage: SText.Messages.askCartClean, withActions: cancelButton, deleteButton)
        } else {
            self.showAlert(withMessage: SText.Messages.blankCart)
        }
    }
    
    @IBAction private func didTapOnButtonDeliveryTimeSlot(_ sender : UIButton) {
        let deliveryTimeSlotViewController = UIStoryboard.Cart.get(DeliveryTimeSlotViewController.self)!
        deliveryTimeSlotViewController.modalPresentationStyle = .overFullScreen
        deliveryTimeSlotViewController.modalTransitionStyle = .crossDissolve
        deliveryTimeSlotViewController.deliveryTimeSlotSelected = deliveryTimeSlotSelected
        deliveryTimeSlotViewController.deliveryTimeUpdatedBlock = { [weak self] (deliveryTimeSlot) in
            guard let `self` = self else {return}
            self.deliveryTimeSlotSelected = deliveryTimeSlot
//            if appLanguage == .Dutch {
                if let date = DateApp.date(fromString: deliveryTimeSlot.date, withFormat: .activityServerDate, identifier: appLanguage.language),
                    let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime, identifier: appLanguage.language),
                    let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime, identifier: appLanguage.language) {
                    self.deliveryTimeSlotLabel.text =  DateApp.string(fromDate: date, withFormat: .dayMonth, identifier: appLanguage.language) + ", " + DateApp.string(fromDate: fromDate, withFormat: .time, identifier: appLanguage.language) + " - " + DateApp.string(fromDate: toDate, withFormat: .time, identifier: appLanguage.language)
                }
//            } else {
//                if let date = DateApp.date(fromString: deliveryTimeSlot.date, withFormat: .activityServerDate),
//                    let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime),
//                    let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime) {
//                    self.deliveryTimeSlotLabel.text =  DateApp.string(fromDate: date, withFormat: .dayMonth) + ", " + DateApp.string(fromDate: fromDate, withFormat: .time) + " - " + DateApp.string(fromDate: toDate, withFormat: .time)
//                }
//            }
            
        }
        self.present(deliveryTimeSlotViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapOnButtonContinue(_ sender : UIButton) {
        if isExpressDeliveryProductInCart() == true && isNotExpressDeliveryProductInCart() == true {
            self.showAlert(withMessage: SText.Messages.expressCartDescription, title: SText.Messages.expressCartTitle)
            return
        }
        let checkoutViewController = UIStoryboard.Cart.get(CheckoutViewController.self)!
        checkoutViewController.totalCartAmount = totalAmountLabel.text ?? ""
        checkoutViewController.deliveryTimeSlotSelected = deliveryTimeSlotSelected
        checkoutViewController.isExpressDelivery = isExpressDeliveryProductInCart()
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
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

//MARK: - TableView DataSource, Delegate -
extension CartViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: CartTableViewCell.self)!
        cell.product = cartProductArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeDetailViewController = UIStoryboard.Home.get(HomeDetailViewController.self)!
        homeDetailViewController.products = cartProductArray[indexPath.section].products[indexPath.row]
        self.navigationController?.pushViewController(homeDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cartProductArray[indexPath.row].products.count * 100)
    }
    
    ///Edit Row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: appLanguage == .Dutch ? "Verwijderen" : "Delete") { [weak self] action, index in
            guard let `self` = self else {return}
            action.backgroundColor = ColorApp.ColorRGB(189,136,49,1)
            for object in self.cartProductArray[indexPath.row].products {
                self.cartDeleteAPICall(cartID: object.cart_id ?? 0)
            }
//            tableView.beginUpdates()
            self.cartProductArray.remove(at: indexPath.row)
//            tableView.endUpdates()
//            tableView.reloadData()
//            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.row), with: .fade)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.exressDeliveryView.isHidden = self.isExpressDeliveryProductInCart() ? false : true
            self.cartBottom(isShow: self.cartProductArray.count == 0 ? false : true)
        }
        return [deleteAction]
    }
    
}

//MARK: - API Call -
extension CartViewController {
    
    private func cartListAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0
                    ] as [String : Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartList(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            self.cartProductArray.removeAll()
            if let data = response.data, response.success {
                self.setAmountData(netAmount: data["net_paid_amount"].doubleValue, totalAmount: data["total_amount"].doubleValue)
                for object in data["products"].arrayValue {
                    self.cartProductArray.append(Product.init(aDict: object))
                }
                self.cartBottom(isShow: self.cartProductArray.count > 0 ? true : false)
                self.exressDeliveryView.isHidden = self.isExpressDeliveryProductInCart() ? false : true
                self.cartItemTableView.reloadData()
            } else {
                self.showAlert(withMessage: response.message ?? "")
                self.cartBottom(isShow: self.cartProductArray.count > 0 ? true : false)
                self.exressDeliveryView.isHidden = self.isExpressDeliveryProductInCart() ? false : true
                self.cartItemTableView.reloadData()
            }
            }, onFailure: { [weak self] (apiErrorResponse) in
                guard let  `self` = self else {return}
                self.showAlert(withMessage: apiErrorResponse.message)
                self.cartProductArray.removeAll()
                self.cartItemTableView.reloadData()
                self.cartBottom(isShow: false)
        })
    }
    
    private func cartDeleteAPICall(cartID : Int) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0,
                        SText.Parameter.cart_id : cartID
                    ] as [String : Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartDelete(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            if response.success, let data = response.data {
                SUtill.showSuccessMessage(message: response.message ?? "")
                self.setAmountData(netAmount: data["net_paid_amount"].doubleValue, totalAmount: data["total_amount"].doubleValue)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
            }, onFailure: { [weak self] (apiErrorResponse) in
                guard let  `self` = self else {return}
                self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func cartCleanAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0
                    ] as [String : Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartClean(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            if response.success, let data = response.data {
                SUtill.showSuccessMessage(message: response.message ?? "")
                self.setAmountData(netAmount: data["net_paid_amount"].doubleValue, totalAmount: data["total_amount"].doubleValue)
                self.cartProductArray.removeAll()
                self.cartItemTableView.reloadData()
                self.exressDeliveryView.isHidden = self.isExpressDeliveryProductInCart() ? false : true
                self.cartBottom(isShow: false)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
            }, onFailure: { [weak self] (apiErrorResponse) in
                guard let  `self` = self else {return}
                self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func timeSlotsAPICall() {
        guard AppUser?.addresses.count ?? 0 > 0, let addresses = AppUser?.addresses.first else {return}
        let param = [
                        SText.Parameter.postal_code : addresses.postal_code ?? ""
                    ] as [String : Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.timeSlots(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            if let data = response.data, response.success {
                for object in data.arrayValue {
                    let deliveryTimeSlot = DeliveryTimeSlot.init(aDict: object)
                    self.deliveryTimeSlotSelected = deliveryTimeSlot
//                    if appLanguage == .Dutch {
                        if let date = DateApp.date(fromString: deliveryTimeSlot.date, withFormat: .activityServerDate, identifier: appLanguage.language),
                            let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime, identifier: appLanguage.language),
                            let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime, identifier: appLanguage.language) {
                            self.deliveryTimeSlotLabel.text =  DateApp.string(fromDate: date, withFormat: .dayMonth, identifier: appLanguage.language) + ", " + DateApp.string(fromDate: fromDate, withFormat: .time, identifier: appLanguage.language) + " - " + DateApp.string(fromDate: toDate, withFormat: .time, identifier: appLanguage.language)
                        }
//                    } else {
//                        if let date = DateApp.date(fromString: deliveryTimeSlot.date, withFormat: .activityServerDate),
//                            let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime),
//                            let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime) {
//                            self.deliveryTimeSlotLabel.text =  DateApp.string(fromDate: date, withFormat: .dayMonth) + ", " + DateApp.string(fromDate: fromDate, withFormat: .time) + " - " + DateApp.string(fromDate: toDate, withFormat: .time)
//                        }
//                    }
                    break
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
            }, onFailure: { [weak self] (apiErrorResponse) in
                guard let  `self` = self else {return}
                self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    func cartAddAPICall(products : Products) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.product_id  : products.product_id,
                        SText.Parameter.qty         : 1,
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartAdd(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if response.success, let data = response.data {
                self.setAmountData(netAmount: data["net_paid_amount"].doubleValue, totalAmount: data["total_amount"].doubleValue)
                products.qty = products.qty + 1
                self.cartItemTableView.reloadData()
                self.exressDeliveryView.isHidden = self.isExpressDeliveryProductInCart() ? false : true
                self.cartBottom(isShow: self.cartProductArray.count == 0 ? false : true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    func cartMinusAPICall(products : Products) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.product_id  : products.product_id,
                        SText.Parameter.qty         : 1,
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartMinus(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if response.success, let data = response.data {
                self.setAmountData(netAmount: data["net_paid_amount"].doubleValue, totalAmount: data["total_amount"].doubleValue)
                products.qty = products.qty - 1
                if products.qty == 0 {
                    for object in self.cartProductArray {
                        if let _ = object.products.firstIndex(of: products) {
                            if let cartIndex = self.cartProductArray.firstIndex(of: object) {
                                self.cartProductArray.remove(at: cartIndex)
                            }
                        }
                    }
                }
                self.cartItemTableView.reloadData()
                self.exressDeliveryView.isHidden = self.isExpressDeliveryProductInCart() ? false : true
                self.cartBottom(isShow: self.cartProductArray.count == 0 ? false : true)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension CartViewController {
    
    private func setAmountData(netAmount: Double, totalAmount: Double) {
        discountLabel.attributedText    = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + "\((totalAmount - netAmount).twoDigitsString)", fontSize: 18)
        totalAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + (totalAmount - (totalAmount - netAmount)).twoDigitsString, fontSize: 18)
        if let seyyarTabbarViewController = self.parent?.parent as? SeyyarTabbarViewController {
            seyyarTabbarViewController.setCartAmountLabel(amount: totalAmount - (totalAmount - netAmount))
        }
    }
    
    private func cartBottom(isShow : Bool) {
        if isShow {
            if cartBottomViewHeightConstraint.constant == 0 {
                cartBottomViewHeightConstraint.constant = 211.5
            }
        } else {
            if cartBottomViewHeightConstraint.constant == 211.5 {
                cartBottomViewHeightConstraint.constant = 0
            }
        }
        UIView.animate(withDuration: 0.5) { [weak self] () in
            guard let `self` = self else {return}
            self.view.layoutIfNeeded()
        }
    }
    
    private func setDeliveryLabel() {
        var deliveryTime : String = ""
        if SettingList.express_delivery_time >= 60 {
            if SettingList.express_delivery_time == 60 {
                if appLanguage == .Dutch {
                    deliveryTime = "1 Timmar"
                } else {
                    deliveryTime = "1 Hour"
                }
            } else {
                let hour    : Int = Int(SettingList.express_delivery_time / 60)
                let minutes : Int = Int(SettingList.express_delivery_time.truncatingRemainder(dividingBy: 60))
                if hour == 1 && minutes == 1 {
                    if appLanguage == .Dutch {
                        deliveryTime = "\(hour) Timmar and \(minutes) Minut"
                    } else {
                        deliveryTime = "\(hour) Hour and \(minutes) Minute"
                    }
                } else if hour == 1 {
                    if appLanguage == .Dutch {
                        deliveryTime = "\(hour) Timmar and \(minutes) Minuter"
                    } else {
                        deliveryTime = "\(hour) Hour and \(minutes) Minutes"
                    }
                } else if minutes == 1 {
                    if appLanguage == .Dutch {
                        deliveryTime = "\(hour) Timmar and \(minutes) Minut"
                    } else {
                        deliveryTime = "\(hour) Hours and \(minutes) Minute"
                    }
                } else {
                    if appLanguage == .Dutch {
                        deliveryTime = "\(hour) Timmar and \(minutes) Minuter"
                    } else {
                        deliveryTime = "\(hour) Hours and \(minutes) Minutes"
                    }
                }
            }
        } else {
            if SettingList.express_delivery_time == 1 {
                if appLanguage == .Dutch {
                    deliveryTime = "\(SettingList.express_delivery_time ?? 0) Minut"
                } else {
                    deliveryTime = "\(SettingList.express_delivery_time ?? 0) Minute"
                }
            } else {
                if appLanguage == .Dutch {
                    deliveryTime = "\(SettingList.express_delivery_time ?? 0) Minuter"
                } else {
                    deliveryTime = "\(SettingList.express_delivery_time ?? 0) Minutes"
                }
            }
            
        }
        if appLanguage == .Dutch {
            expressDeliveryLabel.text = "Leverans inom \(deliveryTime) (extra \(SettingList.currency_symbol ?? "") \(SettingList.express_delivery_charge ?? 0))"
        } else {
            expressDeliveryLabel.text = "Delivery within \(deliveryTime) (Extra \(SettingList.currency_symbol ?? "") \(SettingList.express_delivery_charge ?? 0))"
        }
    }
    
    private func isExpressDeliveryProductInCart() -> Bool {
        var expressDeliveryProductCount : Int = 0
        for object in cartProductArray {
            let filterData = object.products.filter( { $0.is_express == true } )
            expressDeliveryProductCount += filterData.count
        }
        return expressDeliveryProductCount == 0 ? false : true
    }
    
    private func isNotExpressDeliveryProductInCart() -> Bool {
        var notExpressDeliveryProductCount : Int = 0
        for object in cartProductArray {
            let filterData = object.products.filter( { $0.is_express == false } )
            notExpressDeliveryProductCount += filterData.count
        }
        return notExpressDeliveryProductCount == 0 ? false : true
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text   = "Kundvagn"
        discountTitleLabel.text     = "Rabatt"
        totalAmountTitleLabel.text  = "Total summa"
        deliveryTitleLabel.text     = "Leverans"
        continueButton.setTitle("Fortsätt", for: .normal)
        continueButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}
