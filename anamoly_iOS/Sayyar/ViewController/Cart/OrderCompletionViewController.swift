//
//  OrderCompletionViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 04/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class OrderCompletionViewController: BaseViewController {

    @IBOutlet private weak var thanksForYourOrderTitleLabel         : UILabel!
    @IBOutlet private weak var yourOrderPlaceSuccessfullyTitleLabel : UILabel!
    @IBOutlet private weak var bookingDetailsTitleLabel             : UILabel!
    @IBOutlet private weak var orderIDTitleLabel                    : UILabel!
    @IBOutlet private weak var dateTitleLabel                       : UILabel!
    
    @IBOutlet private weak var totalItemsTitleLabel                 : UILabel!
    @IBOutlet private weak var subTotalTitleLabel                   : UILabel!
    @IBOutlet private weak var discountTitleLabel                   : UILabel!
    @IBOutlet private weak var getwayChargesTitleLabel              : UILabel!
    @IBOutlet private weak var deliveryChargesTitleLabel            : UILabel!
    @IBOutlet private weak var totalPaidTitleLabel                  : UILabel!
    
    @IBOutlet private weak var barcodeImageView                     : UIImageView!
    @IBOutlet private weak var orderIDLabel                         : UILabel!
    @IBOutlet private weak var orderDateLabel                       : UILabel!
    @IBOutlet private weak var subTotalLabel                        : UILabel!
    @IBOutlet private weak var discountLabel                        : UILabel!
    @IBOutlet private weak var getwayChargesLabel                   : UILabel!
    @IBOutlet private weak var deliveryChargesLabel                 : UILabel!
    @IBOutlet private weak var totalPaidLabel                       : UILabel!
    @IBOutlet private weak var continueButton                       : SpinnerButton!
    
    var myOrderDetail : MyOrderDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
        
        if let myOrderDetail = myOrderDetail {
            setmyOrderDetail(myOrderDetail: myOrderDetail)
        }
    }
    
    //MARK: - Action Methods -
    @IBAction func didTapOnButtonContinue(_ sender: Any) {
        if let navigationController = self.parent as? UINavigationController {
            if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                navigationController.popToRootViewController(animated: true)
                seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.homeButton)
                seyyarTabbarViewController.setCartAmountLabel(amount: 0)
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

//MARK: - Helper Methods -
extension OrderCompletionViewController {
    
    private func setmyOrderDetail(myOrderDetail : MyOrderDetail) {
        var orderDate = DateApp.date(fromString: myOrderDetail.delivery_date, withFormat: .fixFullDate)
        var barcodeString : String = ""
//        if appLanguage == .Dutch {
            orderDate = DateApp.date(fromString: myOrderDetail.delivery_date, withFormat: .fixFullDate, identifier: appLanguage.language)
            barcodeString = "\(NSLocalizedString("Order ID", comment: "Order ID")) : \(myOrderDetail.order_id ?? 0), \(NSLocalizedString("Date", comment: "Date")) : \(DateApp.string(fromDate: orderDate ?? Date(), withFormat: .orderDetailDate, identifier: appLanguage.language)), \(NSLocalizedString("Total Items", comment: "Total Items")) : \(myOrderDetail.items.count), \(NSLocalizedString("Subtotal", comment: "Subtotal")) : \(myOrderDetail.order_amount.twoDigitsString), \(NSLocalizedString("Discount", comment: "Discount")) : \(myOrderDetail.discount_amount.twoDigitsString), \(NSLocalizedString("Gateway Charges", comment: "Gateway Charges")) : \(myOrderDetail.gateway_charges.twoDigitsString), \(NSLocalizedString("Total Paid", comment: "Total Paid")) : \(myOrderDetail.net_amount.twoDigitsString)"
//        } else {
//            orderDate = DateApp.date(fromString: myOrderDetail.delivery_date, withFormat: .fixFullDate)
//            barcodeString = "Order ID : \(myOrderDetail.order_id ?? 0), Date : \(DateApp.string(fromDate: orderDate ?? Date(), withFormat: .orderDetailDate)), Total Items : \(myOrderDetail.items.count), Subtotal : \(myOrderDetail.order_amount.twoDigitsString), Discount : \(myOrderDetail.discount_amount.twoDigitsString), Gateway Charges : \(myOrderDetail.gateway_charges.twoDigitsString), Total Paid : \(myOrderDetail.net_amount.twoDigitsString)"
//        }
        
        if let image = generateQRCode(from: barcodeString) {
            barcodeImageView.image = image
        }

        orderIDLabel.text           = "\(myOrderDetail.order_id ?? 0)"
//        if appLanguage == .Dutch {
            orderDateLabel.text     = DateApp.string(fromDate: orderDate ?? Date(), withFormat: .orderDetailDate, identifier: appLanguage.language)
//        } else {
//            orderDateLabel.text     = DateApp.string(fromDate: orderDate ?? Date(), withFormat: .orderDetailDate)
//        }
        
        subTotalLabel.attributedText            = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrderDetail.order_amount.twoDigitsString, fontSize: 15)
        discountLabel.attributedText            = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrderDetail.discount_amount.twoDigitsString, fontSize: 15)
        
        if myOrderDetail.gateway_charges == 0 {
            getwayChargesTitleLabel.text        = ""
            getwayChargesLabel.text             = ""
        } else {
            getwayChargesTitleLabel.text        = appLanguage == .Dutch ? "Leverans avgift" : "Getway Charges"
            getwayChargesLabel.attributedText   = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrderDetail.gateway_charges.twoDigitsString, fontSize: 15)
        }
        
        if myOrderDetail.delivery_amount == 0 {
            deliveryChargesTitleLabel.text      = ""
            deliveryChargesLabel.text           = ""
        } else {
            deliveryChargesTitleLabel.text      = appLanguage == .Dutch ? "Leveransavgift" : "Delivery Charges"
            deliveryChargesLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrderDetail.delivery_amount.twoDigitsString, fontSize: 15)
        }
        
        totalPaidLabel.attributedText           = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrderDetail.net_amount.twoDigitsString, fontSize: 15)
        
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    private func prepareDutchLanguage() {
        thanksForYourOrderTitleLabel.text           = "Tack för din beställning"
        yourOrderPlaceSuccessfullyTitleLabel.text   = "Din beställning är bekräftad"
        bookingDetailsTitleLabel.text               = "Order detaljer"
        orderIDTitleLabel.text                      = "Ordernummer"
        dateTitleLabel.text                         = "Datum"
        totalItemsTitleLabel.text                   = "Total varor"
        subTotalTitleLabel.text                     = "Delsumma"
        discountTitleLabel.text                     = "Rabatt"
        getwayChargesTitleLabel.text                = "Leverans avgift"
        deliveryChargesTitleLabel.text              = "Leveransavgift"
        totalPaidTitleLabel.text                    = "Total betald"
        continueButton.setTitle("Fortsätt", for: .normal)
        continueButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}
