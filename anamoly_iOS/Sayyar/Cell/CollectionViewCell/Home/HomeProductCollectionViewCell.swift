//
//  HomeProductCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet         weak var productImageView         : UIImageView!
    @IBOutlet private weak var productPlusButton        : UIButton!
    @IBOutlet private weak var productQTYView           : UIView!
    @IBOutlet private weak var productQTYLabel          : UILabel!
    @IBOutlet private weak var productMinusButton       : UIButton!
    @IBOutlet private weak var productDiscountView      : UIView!
    @IBOutlet private weak var productDiscountLabel     : UILabel!
    @IBOutlet private weak var productnameLabel         : UILabel!
    @IBOutlet private weak var productWeightLabel       : UILabel!
    @IBOutlet private weak var expressDeliveryImageView : UIImageView!
    @IBOutlet private weak var productOldPriceView      : UIView!
    @IBOutlet private weak var productOldPriceLabel     : UILabel!
    @IBOutlet private weak var productNewPriceLabel     : UILabel!
    
    var productAddBlock     : (() -> ())?
    var productMinusBlock   : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var products : Products! {
        didSet {
            productDiscountLabel.text   = ""
            productWeightLabel.text     = ""
            productQTYLabel.text        = ""
            productOldPriceLabel.text   = ""
            productNewPriceLabel.text   = ""
            productPlusButton.isHidden  = false
            productQTYView.isHidden     = true
            productMinusButton.isHidden = true
            
            if products.product_image_small != nil {
                productImageView.sd_setImage(with: products.product_image_small, placeholderImage: Product_Placeholder)
            } else {
                productImageView.image = Product_Placeholder
            }
            switch appLanguage {
            case .Arabic    :
                productWeightLabel.text = "\(products.unit_value) " + products.unit_ar
                productnameLabel.text   = products.product_name_ar
            case .Dutch     :
                productWeightLabel.text = "\(products.unit_value) " + products.unit
                productnameLabel.text   = products.product_name_nl
            case .English   :
                productWeightLabel.text = "\(products.unit_value) " + products.unit_en
                productnameLabel.text   = products.product_name_en
            case .Swedish   :
                productWeightLabel.text = "\(products.unit_value) " + products.unit_de
                productnameLabel.text   = products.product_name_de
            case .Turkish   :
                productWeightLabel.text = "\(products.unit_value) " + products.unit_tr
                productnameLabel.text   = products.product_name_tr
            }
            
            offerType = products.offer_type
            
            productQTYView.isHidden     = products.cart_qty == 0
            productQTYLabel.text        = "\(products.cart_qty ?? 0)"
            productMinusButton.isHidden = products.cart_qty == 0
            
            expressDeliveryImageView.isHidden = products.is_express ? false : true
            
            productOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + products.price.twoDigitsString, fontSize: 20)
            
            productNewPrice = products.price
        }
    }
    
    private var offerType : String! {
        didSet {
            productDiscountView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
            productDiscountLabel.font = UIFont.Tejawal.Regular(12)
            
            productDiscountLabel.text = ""
            productDiscountView.isHidden = false
            if offerType == "flatcombo" {
                productDiscountLabel.text = "\(products.number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(products.offer_discount ?? 0)"
            } else if offerType == "plusone" {
                productDiscountLabel.text = "\(products.number_of_products ?? 0) + 1 gratis"
            } else {
                productDiscountView.isHidden = true
                productDiscountLabel.text = ""
            }
            if offerType.trimmedLength == 0 {
                productDiscount = products.discount
            }
        }
    }
    
    private var productDiscount : Int! {
        didSet {
            productDiscountView.backgroundColor = .darkGray
            productDiscountLabel.font = UIFont.Tejawal.Regular(10)
            
            if productDiscount > 0 {
                productDiscountView.isHidden = false
                
                if (products.discount_type == "flat") {
                    productOldPriceView.isHidden = false
                    productDiscountLabel.text = "\(productDiscount ?? 0) Flat"
                } else if (products.discount_type == "percentage") {
                    productOldPriceView.isHidden = false
                    productDiscountLabel.text = "\(productDiscount ?? 0)% Discount"
                } else {
                    productOldPriceView.isHidden = true
                }
            } else {
                productOldPriceView.isHidden = true
                productDiscountView.isHidden = true
                productDiscountLabel.text = ""
            }
        }
    }
    
    private var productNewPrice : Double! {
        didSet {
            var priceString = ""
            if (products.discount_type == "flat") {
                let afterFlatOffPrice = products.price - Double(products.discount)
                priceString = afterFlatOffPrice > 0 ? afterFlatOffPrice.twoDigitsString : "0.00"
            } else if (products.discount_type == "percentage") {
                let afterDiscountPrice = products.price - ((products.price * Double(products.discount)) / 100)
                priceString = afterDiscountPrice > 0 ? afterDiscountPrice.twoDigitsString : "0.00"
            } else {
                priceString = products.price.twoDigitsString
            }
            productNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + priceString, fontSize: 20)
            productOldPriceView.isHidden = productOldPriceLabel.attributedText == productNewPriceLabel.attributedText ? true : false
            if productOldPriceView.isHidden == false {
                productOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + products.price.twoDigitsString, fontSize: 14)
            }
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonMoreInfo(_ sender : UIButton) {
        DispatchQueue.main.async {
            if let homeDetailViewController = UIStoryboard.Home.get(HomeDetailViewController.self) {
                homeDetailViewController.products = self.products
                if let homeViewController = self.viewContainingController()?.parent?.parent as? HomeViewController {
                    homeViewController.isProductDetailPagePushed = true
                }
                self.viewContainingController()?.navigationController?.pushViewController(homeDetailViewController, animated: true)
            }
        }
    }
    
    @IBAction private func didTapOnButtonProductAdd(_ sender: Any) {
        productAddBlock?()
    }
    
    @IBAction private func didTapOnButtonProductMinus(_ sender: Any) {
        productMinusBlock?()
    }
    
}
