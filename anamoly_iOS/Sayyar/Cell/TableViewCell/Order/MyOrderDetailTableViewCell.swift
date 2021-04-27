//
//  MyOrderDetailTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class MyOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var orderImageView       : UIImageView!
    @IBOutlet private weak var orderDicountLabel    : UILabel!
    @IBOutlet private weak var orderDiscountBgView  : UIView!
    @IBOutlet private weak var orderTitleLabel      : UILabel!
    @IBOutlet private weak var orderTypeLabel       : UILabel!
    @IBOutlet private weak var orderOldAmountView   : UIView!
    @IBOutlet private weak var orderOldAmountLabel  : UILabel!
    @IBOutlet private weak var orderAmountLabel     : UILabel!
    @IBOutlet private weak var orderQTYLabel        : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var myOrderDetailItem : MyOrderDetailItem! {
        didSet {
            if myOrderDetailItem.product_image_small != nil {
                orderImageView.sd_setImage(with: myOrderDetailItem.product_image_small, placeholderImage: Product_Placeholder)
            } else {
                orderImageView.image            = Product_Placeholder
            }
            switch appLanguage {
            case .Arabic    :
                orderTitleLabel.text    = myOrderDetailItem.product_name_ar
                orderTypeLabel.text     = "\(myOrderDetailItem.unit_value ?? 0) \(myOrderDetailItem.unit_ar ?? "")"
            case .Dutch     :
                orderTitleLabel.text    = myOrderDetailItem.product_name_nl
                orderTypeLabel.text     = "\(myOrderDetailItem.unit_value ?? 0) \(myOrderDetailItem.unit_de ?? "")"
            case .English   :
                orderTitleLabel.text    = myOrderDetailItem.product_name_en
                orderTypeLabel.text     = "\(myOrderDetailItem.unit_value ?? 0) \(myOrderDetailItem.unit_en ?? "")"
            case .Swedish   :
                orderTitleLabel.text    = myOrderDetailItem.product_name_de
                orderTypeLabel.text     = "\(myOrderDetailItem.unit_value ?? 0) \(myOrderDetailItem.unit_de ?? "")"
            case .Turkish   :
                orderTitleLabel.text    = myOrderDetailItem.product_name_tr
                orderTypeLabel.text     = "\(myOrderDetailItem.unit_value ?? 0) \(myOrderDetailItem.unit_tr ?? "")"
            }
            orderTitleLabel.textColor   = SettingList.default_text_color
            orderOldAmountLabel.attributedText  = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + Double(myOrderDetailItem.product_price * Double(myOrderDetailItem.order_qty)).twoDigitsString, fontSize: 15)
            orderQTYLabel.text                  = "\(myOrderDetailItem.order_qty ?? 0)"
            
            offerType       = myOrderDetailItem.offer_type
            productNewPrice = myOrderDetailItem.price
        }
    }
    
    private var offerType : String! {
            didSet {
                orderDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
                
                orderDicountLabel.text = ""
                orderDiscountBgView.isHidden = false
                if offerType == "flatcombo" {
                    orderDicountLabel.text = "\(myOrderDetailItem.number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(myOrderDetailItem.offer_discount ?? 0)"
                } else if offerType == "plusone" {
                    orderDicountLabel.text = "\(myOrderDetailItem.number_of_products ?? 0) + 1 gratis"
                } else {
                    orderDiscountBgView.isHidden = true
                    orderDicountLabel.text = ""
                }
                
                if offerType.trimmedLength == 0 {
                    productDiscount = Int(myOrderDetailItem.discount)
                }
            }
        }
        
        private var productDiscount : Int! {
            didSet {
                orderDiscountBgView.backgroundColor = .darkGray
                
                if productDiscount > 0 {
                    orderDiscountBgView.isHidden = false
                    
                    if (myOrderDetailItem.discount_type == "flat") {
                        orderOldAmountView.isHidden = false
                        orderDicountLabel.text = "\(productDiscount ?? 0) Flat"
                    } else if (myOrderDetailItem.discount_type == "percentage") {
                        orderOldAmountView.isHidden = false
                        orderDicountLabel.text = "\(productDiscount ?? 0)% Discount"
                    } else {
                        orderOldAmountView.isHidden = true
                    }
                } else {
                    orderOldAmountView.isHidden = true
                    orderDiscountBgView.isHidden = true
                    orderDicountLabel.text = ""
                }
            }
        }
        
        private var productNewPrice : Double! {
            didSet {
//                var price : Double = 0
//                if (myOrderDetailItem.discount_type == "flat") {
//                    let afterFlatOffPrice = myOrderDetailItem.price - Double(myOrderDetailItem.discount)
//                    price = afterFlatOffPrice > 0 ? afterFlatOffPrice : 0
//                } else if (myOrderDetailItem.discount_type == "percentage") {
//                    let afterDiscountPrice = myOrderDetailItem.price - ((myOrderDetailItem.price * Double(myOrderDetailItem.discount)) / 100)
//                    price = afterDiscountPrice > 0 ? afterDiscountPrice : 0
//                } else {
//                    price = myOrderDetailItem.price
//                }
                orderAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + Double(myOrderDetailItem.price * Double(myOrderDetailItem.order_qty)).twoDigitsString, fontSize: 18)
                if myOrderDetailItem.discount > 0 {
                    orderOldAmountView.isHidden = false
                    orderOldAmountLabel.attributedText  = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + Double(myOrderDetailItem.product_price * Double(myOrderDetailItem.order_qty)).twoDigitsString, fontSize: 15)
                } else {
                    orderOldAmountView.isHidden = true
                    orderOldAmountLabel.text = ""
                    
                }
            }
        }
    
}
