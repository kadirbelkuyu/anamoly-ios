//
//  MyOrderDetailViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class MyOrderDetailViewController: BaseViewController {

    @IBOutlet private weak var navigationTitleLabel         : UILabel!
    @IBOutlet private weak var orderDateLabel               : UILabel!
    @IBOutlet private weak var orderAmountLabel             : UILabel!
    @IBOutlet private weak var orrderDetailTableView        : UITableView!
    @IBOutlet private weak var orrderDetailTableFooterView  : UIView!
    
    @IBOutlet private weak var totalItemsTitleLabel         : UILabel!
    @IBOutlet private weak var subTotalTitleLabel           : UILabel!
    @IBOutlet private weak var discountTitleLabel           : UILabel!
    @IBOutlet private weak var getwayChargesTitleLabel      : UILabel!
    @IBOutlet private weak var deliveryChargesTitleLabel    : UILabel!
    @IBOutlet private weak var totalPaidTitleLabel          : UILabel!
    
    @IBOutlet private weak var subTotalLabel                : UILabel!
    @IBOutlet private weak var discountLabel                : UILabel!
    @IBOutlet private weak var getwayChargesLabel           : UILabel!
    @IBOutlet private weak var deliveryChargesLabel         : UILabel!
    @IBOutlet private weak var totalPaidLabel               : UILabel!
    @IBOutlet private weak var trackOrderView               : UIView!
    @IBOutlet private weak var reOrderButton                : SpinnerButton!
    @IBOutlet private weak var trackButton                  : SpinnerButton!
    
    var myOrder                         : MyOrder?
    private var myOrderDetail           : MyOrderDetail?
    private var previousContentOffSet   : CGFloat       = 0
    var orderID                         : Int           = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        orrderDetailTableView.tableFooterView = orrderDetailTableFooterView
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
        
        if let myOrder = myOrder {
            setMyOrder(myOrder: myOrder)
            orderListAPICall(myOrder: myOrder, orderID: nil)
        }
        if orderID != 0 {
            orderListAPICall(myOrder: nil, orderID: orderID)
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonTrack(_ sender: Any) {
        if let orderTrackingViewController = UIStoryboard.Order.get(OrderTrackingViewController.self) {
            orderTrackingViewController.myOrderDetail = myOrderDetail
            self.navigationController?.pushViewController(orderTrackingViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnButtonReOrder(_ sender: Any) {
        let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            if let myOrder = self.myOrder {
                self.cartReOderAPICall(orderID: myOrder.order_id ?? 0)
            } else if self.orderID != 0 {
                self.cartReOderAPICall(orderID: self.orderID)
            }
        }
        let cancelButton = UIAlertAction(title: SText.Button.CANCEL, style: .cancel, handler: nil)
        self.showAlert(withMessage: SText.Messages.askReOrder, withActions: cancelButton, okButton)
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
extension MyOrderDetailViewController {
    
    private func setMyOrder(myOrder : MyOrder) {
        if appLanguage == .Dutch {
            if let date = DateApp.date(fromString: myOrder.order_date, withFormat: .fixFullDate, identifier: DutchDateIdentifier) {
                orderDateLabel.text = DateApp.string(fromDate: date, withFormat: .myOrderDate, identifier: DutchDateIdentifier)
            }
        } else {
            if let date = DateApp.date(fromString: myOrder.order_date, withFormat: .fixFullDate) {
                orderDateLabel.text = DateApp.string(fromDate: date, withFormat: .myOrderDate)
            }
        }
        orderDateLabel.textColor        = SettingList.default_text_color
        orderAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.net_amount.twoDigitsString, fontSize: 15)
        subTotalLabel.attributedText    = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.order_amount.twoDigitsString, fontSize: 15)
        discountLabel.attributedText    = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.discount_amount.twoDigitsString, fontSize: 15)
        if myOrder.gateway_charges == 0 {
            getwayChargesTitleLabel.text = ""
            getwayChargesLabel.text = ""
        } else {
//            getwayChargesTitleLabel.text = appLanguage == .Dutch ? "Leverans avgift" : "Getway Charges"
            getwayChargesLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.gateway_charges.twoDigitsString, fontSize: 15)
        }
        if myOrder.delivery_amount == 0 {
            deliveryChargesTitleLabel.text = ""
            deliveryChargesLabel.text = ""
        } else {
//            deliveryChargesTitleLabel.text = appLanguage == .Dutch ? "Leveransavgift" : "Delivery Charges"
            deliveryChargesLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.delivery_amount.twoDigitsString, fontSize: 15)
        }
        totalPaidLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.net_amount.twoDigitsString, fontSize: 15)
        trackButton.isHidden    = myOrder.status == .OutForDelivery ? false : true
        
        orrderDetailTableView.updateFooterViewHeight()
    }
    
    private func trackOrderView(isHide : Bool) {
        if isHide {
            UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.trackOrderView.transform =  CGAffineTransform(translationX: 0, y: ScreenHeight)
            })
        } else {
            UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.trackOrderView.transform =  CGAffineTransform.identity
            })
        }
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text       = "Order detaljer"
        totalItemsTitleLabel.text       = "Total varor"
        subTotalTitleLabel.text         = "Delsumma"
        discountTitleLabel.text         = "Rabatt"
        getwayChargesTitleLabel.text    = "Leverans avgift"
        deliveryChargesTitleLabel.text  = "Leveransavgift"
        totalPaidTitleLabel.text        = "Total betald"
        reOrderButton.setTitle("Beställ om", for: .normal)
        trackButton.setTitle("Spåra", for: .normal)
        trackButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        reOrderButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
    }
    
}

//MARK: - TableView DataSourrce, Delegate
extension MyOrderDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let myOrderDetail = myOrderDetail {
            return myOrderDetail.items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: MyOrderDetailTableViewCell.self)!
        if let myOrderDetail = myOrderDetail {
            cell.myOrderDetailItem = myOrderDetail.items[indexPath.row]
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < previousContentOffSet {
            trackOrderView(isHide: true)
        } else {
            trackOrderView(isHide: false)
        }
        previousContentOffSet = scrollView.contentOffset.y
    }
    
}

//MARK: - API Call -
extension MyOrderDetailViewController {
    
    private func orderListAPICall(myOrder : MyOrder?, orderID : Int?) {
        guard let user = AppUser else {return}
        var myOrderID : Int = 0
        if let myOrder = myOrder {
            myOrderID = myOrder.order_id
        }
        if let orderID = orderID {
            myOrderID = orderID
        }
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.order_id    : myOrderID
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.orderList(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                self.myOrderDetail = MyOrderDetail.init(aDict: data)
                self.setMyOrder(myOrder: MyOrder.init(aDict: data))
                self.orrderDetailTableView.reloadData()
                if (ScreenWidth == 375 && self.myOrderDetail?.items.count ?? 0 < 5) || (ScreenWidth == 414 && self.myOrderDetail?.items.count ?? 0 < 8) {
                    self.trackOrderView(isHide: false)
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func cartReOderAPICall(orderID : Int) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.order_id    : orderID
                    ] as [String : Any]
        reOrderButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartReOder(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            self.reOrderButton.endLoading()
            if response.success {
                SUtill.showSuccessMessage(message: response.message ?? "")
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        navigationController.popToRootViewController(animated: true)
                        seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.cartButton)
                    }
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            self.reOrderButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
