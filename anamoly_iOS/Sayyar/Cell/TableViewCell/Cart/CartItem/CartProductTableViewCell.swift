//
//  CartProductTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class CartProductTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var oneCartView                      : UIView!
    @IBOutlet private weak var oneitemImageView                 : UIImageView!
    @IBOutlet private weak var oneitemDicountLabel              : UILabel!
    @IBOutlet private weak var oneproductDiscountBgView         : UIView!
    @IBOutlet private weak var oneitemNameLabel                 : UILabel!
    @IBOutlet private weak var oneitemUnitTypeLabel             : UILabel!
    @IBOutlet private weak var oneexpressDeliveryImageView      : UIImageView!
    @IBOutlet private weak var oneitemOldPriceBgView            : UIView!
    @IBOutlet private weak var oneitemOldPriceLabel             : UILabel!
    @IBOutlet private weak var oneitemNewPriceLabel             : UILabel!
    @IBOutlet private weak var oneitemQtyLabel                  : UILabel!
    
    @IBOutlet private weak var twoCartView                      : UIView!
    @IBOutlet private weak var twoitemImageView                 : UIImageView!
    @IBOutlet private weak var twoitemDicountLabel              : UILabel!
    @IBOutlet private weak var twoproductDiscountBgView         : UIView!
    @IBOutlet private weak var twoitemNameLabel                 : UILabel!
    @IBOutlet private weak var twoitemUnitTypeLabel             : UILabel!
    @IBOutlet private weak var twoexpressDeliveryImageView      : UIImageView!
    @IBOutlet private weak var twoitemOldPriceBgView            : UIView!
    @IBOutlet private weak var twoitemOldPriceLabel             : UILabel!
    @IBOutlet private weak var twoitemNewPriceLabel             : UILabel!
    @IBOutlet private weak var twoitemQtyLabel                  : UILabel!
    
    @IBOutlet private weak var threeCartView                    : UIView!
    @IBOutlet private weak var threeitemImageView               : UIImageView!
    @IBOutlet private weak var threeitemDicountLabel            : UILabel!
    @IBOutlet private weak var threeproductDiscountBgView       : UIView!
    @IBOutlet private weak var threeitemNameLabel               : UILabel!
    @IBOutlet private weak var threeitemUnitTypeLabel           : UILabel!
    @IBOutlet private weak var threeexpressDeliveryImageView    : UIImageView!
    @IBOutlet private weak var threeitemOldPriceBgView          : UIView!
    @IBOutlet private weak var threeitemOldPriceLabel           : UILabel!
    @IBOutlet private weak var threeitemNewPriceLabel           : UILabel!
    @IBOutlet private weak var threeitemQtyLabel                : UILabel!
    
    @IBOutlet private weak var cartUpdateViewWidthConstraint    : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    var product : Product! {
//        didSet {
//            let productsArray = product.products
//            if productsArray.count == 3 {
//                cartUpdateViewWidthConstraint.constant = 0
//                self.layoutIfNeeded()
//
//                oneCartView.isHidden = false
//                twoCartView.isHidden = false
//                threeCartView.isHidden = false
//
//                oneitemDicountLabel.text   = ""
//                oneitemNameLabel.text      = ""
//                oneitemUnitTypeLabel.text  = ""
//                oneitemOldPriceLabel.text  = ""
//                oneitemNewPriceLabel.text  = ""
//                oneitemQtyLabel.text       = ""
//                oneitemOldPriceBgView.isHidden     = true
//                oneproductDiscountBgView.isHidden  = true
//
//                twoitemDicountLabel.text   = ""
//                twoitemNameLabel.text      = ""
//                twoitemUnitTypeLabel.text  = ""
//                twoitemOldPriceLabel.text  = ""
//                twoitemNewPriceLabel.text  = ""
//                twoitemQtyLabel.text       = ""
//                twoitemOldPriceBgView.isHidden     = true
//                twoproductDiscountBgView.isHidden  = true
//
//                threeitemDicountLabel.text   = ""
//                threeitemNameLabel.text      = ""
//                threeitemUnitTypeLabel.text  = ""
//                threeitemOldPriceLabel.text  = ""
//                threeitemNewPriceLabel.text  = ""
//                threeitemQtyLabel.text       = ""
//                threeitemOldPriceBgView.isHidden     = true
//                threeproductDiscountBgView.isHidden  = true
//
//                oneitemImageView.image = Product_Placeholder
//                twoitemImageView.image = Product_Placeholder
//                threeitemImageView.image = Product_Placeholder
//                if productsArray[0].product_image_small != nil {
//                    oneitemImageView.sd_setImage(with: productsArray[0].product_image_small, placeholderImage: Product_Placeholder)
//                }
//                if productsArray[1].product_image_small != nil {
//                    twoitemImageView.sd_setImage(with: productsArray[1].product_image_small, placeholderImage: Product_Placeholder)
//                }
//                if productsArray[2].product_image_small != nil {
//                    threeitemImageView.sd_setImage(with: productsArray[2].product_image_small, placeholderImage: Product_Placeholder)
//                }
//
//                oneitemUnitTypeLabel.text = "\(productsArray[0].unit_value) " + productsArray[0].unit
//                twoitemUnitTypeLabel.text = "\(productsArray[1].unit_value) " + productsArray[1].unit
//                threeitemUnitTypeLabel.text = "\(productsArray[2].unit_value) " + productsArray[2].unit
//
//                oneitemNameLabel.text = appLanguage == .Dutch ? productsArray[0].product_name_nl : productsArray[0].product_name_en
//                twoitemNameLabel.text = appLanguage == .Dutch ? productsArray[1].product_name_nl : productsArray[1].product_name_en
//                threeitemNameLabel.text = appLanguage == .Dutch ? productsArray[2].product_name_nl : productsArray[2].product_name_en
//                if appLanguage == .English && productsArray[0].product_name_en.trimmedLength == 0 {
//                    oneitemNameLabel.text = productsArray[0].product_name_nl
//                }
//                if appLanguage == .English && productsArray[1].product_name_en.trimmedLength == 0 {
//                    twoitemNameLabel.text = productsArray[1].product_name_nl
//                }
//                if appLanguage == .English && productsArray[2].product_name_en.trimmedLength == 0 {
//                    threeitemNameLabel.text = productsArray[2].product_name_nl
//                }
//
//                oneexpressDeliveryImageView.isHidden = productsArray[0].is_express ? false : true
//                twoexpressDeliveryImageView.isHidden = productsArray[1].is_express ? false : true
//                threeexpressDeliveryImageView.isHidden = productsArray[2].is_express ? false : true
//
//                oneitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + productsArray[0].price.twoDigitsString, fontSize: 16)
//                twoitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + productsArray[1].price.twoDigitsString, fontSize: 16)
//                threeitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + productsArray[2].price.twoDigitsString, fontSize: 16)
//
//                oneitemQtyLabel.text = "\(productsArray[0].qty ?? 0)"
//                twoitemQtyLabel.text = "\(productsArray[1].qty ?? 0)"
//                threeitemQtyLabel.text = "\(productsArray[2].qty ?? 0)"
//
//                threeitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + product.effected_price.twoDigitsString, fontSize: 20)
//
//                if productsArray[0].offer_type.trimmedLength > 0 {
//                    oneproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
//                    oneproductDiscountBgView.isHidden = false
//
//                    if productsArray[0].offer_type == "flatcombo" {
//                        oneitemDicountLabel.text = "\(productsArray[0].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(productsArray[0].offer_discount ?? 0)"
//                    } else if productsArray[0].offer_type == "plusone" {
//                        oneitemDicountLabel.text = "\(productsArray[0].number_of_products ?? 0) + 1 gratis"
//                    } else {
//                        oneproductDiscountBgView.isHidden = true
//                        oneitemDicountLabel.text = ""
//                    }
//                } else if productsArray[0].discount > 0 {
//                    oneproductDiscountBgView.backgroundColor = .darkGray
//                    oneproductDiscountBgView.isHidden = false
//                    oneitemOldPriceBgView.isHidden = false
//
//                    if (productsArray[0].discount_type == "flat") {
//                        oneitemDicountLabel.text = "\(productsArray[0].discount) Flat"
//                    } else if (productsArray[0].discount_type == "percentage") {
//                        oneitemDicountLabel.text = "\(productsArray[0].discount)% Discount"
//                    } else {
//                        oneitemOldPriceLabel.text = ""
//                        oneitemOldPriceBgView.isHidden = true
//                    }
//                } else {
//                    oneitemOldPriceLabel.text = ""
//                    oneitemOldPriceBgView.isHidden = true
//                    oneproductDiscountBgView.isHidden = true
//                    oneitemDicountLabel.text = ""
//                }
//
//                if productsArray[1].offer_type.trimmedLength > 0 {
//                    twoproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
//                    twoproductDiscountBgView.isHidden = false
//
//                    if productsArray[1].offer_type == "flatcombo" {
//                        twoitemDicountLabel.text = "\(productsArray[1].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(productsArray[1].offer_discount ?? 0)"
//                    } else if productsArray[1].offer_type == "plusone" {
//                        twoitemDicountLabel.text = "\(productsArray[1].number_of_products ?? 0) + 1 gratis"
//                    } else {
//                        twoproductDiscountBgView.isHidden = true
//                        twoitemDicountLabel.text = ""
//                    }
//                } else if productsArray[1].discount > 0 {
//                    twoproductDiscountBgView.backgroundColor = .darkGray
//                    twoproductDiscountBgView.isHidden = false
//                    twoitemOldPriceBgView.isHidden = false
//
//                    if (productsArray[1].discount_type == "flat") {
//                        twoitemDicountLabel.text = "\(productsArray[1].discount) Flat"
//                    } else if (productsArray[1].discount_type == "percentage") {
//                        twoitemDicountLabel.text = "\(productsArray[1].discount)% Discount"
//                    } else {
//                        twoitemOldPriceLabel.text = ""
//                        twoitemOldPriceBgView.isHidden = true
//                    }
//                } else {
//                    twoitemOldPriceLabel.text = ""
//                    twoitemOldPriceBgView.isHidden = true
//                    twoproductDiscountBgView.isHidden = true
//                    twoitemDicountLabel.text = ""
//                }
//
//                if productsArray[2].offer_type.trimmedLength > 0 {
//                    threeproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
//                    threeproductDiscountBgView.isHidden = false
//
//                    if productsArray[2].offer_type == "flatcombo" {
//                        threeitemDicountLabel.text = "\(productsArray[2].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(productsArray[2].offer_discount ?? 0)"
//                    } else if productsArray[2].offer_type == "plusone" {
//                        threeitemDicountLabel.text = "\(productsArray[2].number_of_products ?? 0) + 1 gratis"
//                    } else {
//                        threeproductDiscountBgView.isHidden = true
//                        threeitemDicountLabel.text = ""
//                    }
//                } else if productsArray[2].discount > 0 {
//                    threeproductDiscountBgView.backgroundColor = .darkGray
//                    threeproductDiscountBgView.isHidden = false
//                    threeitemOldPriceBgView.isHidden = false
//
//                    if (productsArray[2].discount_type == "flat") {
//                        threeitemDicountLabel.text = "\(productsArray[2].discount) Flat"
//                    } else if (productsArray[2].discount_type == "percentage") {
//                        threeitemDicountLabel.text = "\(productsArray[2].discount)% Discount"
//                    } else {
//                        threeitemOldPriceLabel.text = ""
//                        threeitemOldPriceBgView.isHidden = true
//                    }
//                } else {
//                    threeitemOldPriceLabel.text = ""
//                    threeitemOldPriceBgView.isHidden = true
//                    threeproductDiscountBgView.isHidden = true
//                    threeitemDicountLabel.text = ""
//                }
//            } else if productsArray.count == 2 {
//                cartUpdateViewWidthConstraint.constant = 0
//                self.layoutIfNeeded()
//
//                oneCartView.isHidden = false
//                twoCartView.isHidden = false
//                threeCartView.isHidden = true
//
//                oneitemDicountLabel.text   = ""
//                oneitemNameLabel.text      = ""
//                oneitemUnitTypeLabel.text  = ""
//                oneitemOldPriceLabel.text  = ""
//                oneitemNewPriceLabel.text  = ""
//                oneitemQtyLabel.text       = ""
//                oneitemOldPriceBgView.isHidden     = true
//                oneproductDiscountBgView.isHidden  = true
//
//                twoitemDicountLabel.text   = ""
//                twoitemNameLabel.text      = ""
//                twoitemUnitTypeLabel.text  = ""
//                twoitemOldPriceLabel.text  = ""
//                twoitemNewPriceLabel.text  = ""
//                twoitemQtyLabel.text       = ""
//                twoitemOldPriceBgView.isHidden     = true
//                twoproductDiscountBgView.isHidden  = true
//
//                oneitemImageView.image = Product_Placeholder
//                twoitemImageView.image = Product_Placeholder
//                if productsArray[0].product_image_small != nil {
//                    oneitemImageView.sd_setImage(with: productsArray[0].product_image_small, placeholderImage: Product_Placeholder)
//                }
//                if productsArray[1].product_image_small != nil {
//                    twoitemImageView.sd_setImage(with: productsArray[1].product_image_small, placeholderImage: Product_Placeholder)
//                }
//
//                oneitemUnitTypeLabel.text = "\(productsArray[0].unit_value) " + productsArray[0].unit
//                twoitemUnitTypeLabel.text = "\(productsArray[1].unit_value) " + productsArray[1].unit
//
//                oneitemNameLabel.text = appLanguage == .Dutch ? productsArray[0].product_name_nl : productsArray[0].product_name_en
//                twoitemNameLabel.text = appLanguage == .Dutch ? productsArray[1].product_name_nl : productsArray[1].product_name_en
//                if appLanguage == .English && productsArray[0].product_name_en.trimmedLength == 0 {
//                    oneitemNameLabel.text = productsArray[0].product_name_nl
//                }
//                if appLanguage == .English && productsArray[1].product_name_en.trimmedLength == 0 {
//                    twoitemNameLabel.text = productsArray[1].product_name_nl
//                }
//
//                oneexpressDeliveryImageView.isHidden = productsArray[0].is_express ? false : true
//                twoexpressDeliveryImageView.isHidden = productsArray[1].is_express ? false : true
//
//                oneitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + productsArray[0].price.twoDigitsString, fontSize: 16)
//                twoitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + productsArray[1].price.twoDigitsString, fontSize: 16)
//
//                oneitemQtyLabel.text = "\(productsArray[0].qty ?? 0)"
//                twoitemQtyLabel.text = "\(productsArray[1].qty ?? 0)"
//
//                twoitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + product.effected_price.twoDigitsString, fontSize: 20)
//
//                if productsArray[0].offer_type.trimmedLength > 0 {
//                    oneproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
//                    oneproductDiscountBgView.isHidden = false
//
//                    if productsArray[0].offer_type == "flatcombo" {
//                        oneitemDicountLabel.text = "\(productsArray[0].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(productsArray[0].offer_discount ?? 0)"
//                    } else if productsArray[0].offer_type == "plusone" {
//                        oneitemDicountLabel.text = "\(productsArray[0].number_of_products ?? 0) + 1 gratis"
//                    } else {
//                        oneproductDiscountBgView.isHidden = true
//                        oneitemDicountLabel.text = ""
//                    }
//                } else if productsArray[0].discount > 0 {
//                    oneproductDiscountBgView.backgroundColor = .darkGray
//                    oneproductDiscountBgView.isHidden = false
//                    oneitemOldPriceBgView.isHidden = false
//
//                    if (productsArray[0].discount_type == "flat") {
//                        oneitemDicountLabel.text = "\(productsArray[0].discount) Flat"
//                    } else if (productsArray[0].discount_type == "percentage") {
//                        oneitemDicountLabel.text = "\(productsArray[0].discount)% Discount"
//                    } else {
//                        oneitemOldPriceLabel.text = ""
//                        oneitemOldPriceBgView.isHidden = true
//                    }
//                } else {
//                    oneitemOldPriceLabel.text = ""
//                    oneitemOldPriceBgView.isHidden = true
//                    oneproductDiscountBgView.isHidden = true
//                    oneitemDicountLabel.text = ""
//                }
//
//                if productsArray[1].offer_type.trimmedLength > 0 {
//                    twoproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
//                    twoproductDiscountBgView.isHidden = false
//
//                    if productsArray[1].offer_type == "flatcombo" {
//                        twoitemDicountLabel.text = "\(productsArray[1].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(productsArray[1].offer_discount ?? 0)"
//                    } else if productsArray[1].offer_type == "plusone" {
//                        twoitemDicountLabel.text = "\(productsArray[1].number_of_products ?? 0) + 1 gratis"
//                    } else {
//                        twoproductDiscountBgView.isHidden = true
//                        twoitemDicountLabel.text = ""
//                    }
//                } else if productsArray[1].discount > 0 {
//                    twoproductDiscountBgView.backgroundColor = .darkGray
//                    twoproductDiscountBgView.isHidden = false
//                    twoitemOldPriceBgView.isHidden = false
//
//                    if (productsArray[1].discount_type == "flat") {
//                        twoitemDicountLabel.text = "\(productsArray[1].discount) Flat"
//                    } else if (productsArray[1].discount_type == "percentage") {
//                        twoitemDicountLabel.text = "\(productsArray[1].discount)% Discount"
//                    } else {
//                        twoitemOldPriceLabel.text = ""
//                        twoitemOldPriceBgView.isHidden = true
//                    }
//                } else {
//                    twoitemOldPriceLabel.text = ""
//                    twoitemOldPriceBgView.isHidden = true
//                    twoproductDiscountBgView.isHidden = true
//                    twoitemDicountLabel.text = ""
//                }
//            } else if productsArray.count == 1 {
//                cartUpdateViewWidthConstraint.constant = product.isCartOpen ? 50 : 0
//                self.layoutIfNeeded()
//
//                oneCartView.isHidden = false
//                twoCartView.isHidden = true
//                threeCartView.isHidden = false
//
//                oneitemDicountLabel.text   = ""
//                oneitemNameLabel.text      = ""
//                oneitemUnitTypeLabel.text  = ""
//                oneitemOldPriceLabel.text  = ""
//                oneitemNewPriceLabel.text  = ""
//                oneitemQtyLabel.text       = ""
//                oneitemOldPriceBgView.isHidden     = true
//                oneproductDiscountBgView.isHidden  = true
//
//                oneitemImageView.image = Product_Placeholder
//                if productsArray[0].product_image_small != nil {
//                    oneitemImageView.sd_setImage(with: productsArray[0].product_image_small, placeholderImage: Product_Placeholder)
//                }
//
//                oneitemUnitTypeLabel.text = "\(productsArray[0].unit_value) " + productsArray[0].unit
//
//                oneitemNameLabel.text = appLanguage == .Dutch ? productsArray[0].product_name_nl : productsArray[0].product_name_en
//                if appLanguage == .English && productsArray[0].product_name_en.trimmedLength == 0 {
//                    oneitemNameLabel.text = productsArray[0].product_name_nl
//                }
//
//                oneexpressDeliveryImageView.isHidden = productsArray[0].is_express ? false : true
//
//                oneitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + productsArray[0].price.twoDigitsString, fontSize: 16)
//
//                oneitemQtyLabel.text = "\(productsArray[0].qty ?? 0)"
//
//                oneitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + product.effected_price.twoDigitsString, fontSize: 20)
//
//                if productsArray[0].offer_type.trimmedLength > 0 {
//                    oneproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
//                    oneproductDiscountBgView.isHidden = false
//
//                    if productsArray[0].offer_type == "flatcombo" {
//                        oneitemDicountLabel.text = "\(productsArray[0].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(productsArray[0].offer_discount ?? 0)"
//                    } else if productsArray[0].offer_type == "plusone" {
//                        oneitemDicountLabel.text = "\(productsArray[0].number_of_products ?? 0) + 1 gratis"
//                    } else {
//                        oneproductDiscountBgView.isHidden = true
//                        oneitemDicountLabel.text = ""
//                    }
//                } else if productsArray[0].discount > 0 {
//                    oneproductDiscountBgView.backgroundColor = .darkGray
//                    oneproductDiscountBgView.isHidden = false
//                    oneitemOldPriceBgView.isHidden = false
//
//                    if (productsArray[0].discount_type == "flat") {
//                        oneitemDicountLabel.text = "\(productsArray[0].discount) Flat"
//                    } else if (productsArray[0].discount_type == "percentage") {
//                        oneitemDicountLabel.text = "\(productsArray[0].discount)% Discount"
//                    } else {
//                        oneitemOldPriceLabel.text = ""
//                        oneitemOldPriceBgView.isHidden = true
//                    }
//                } else {
//                    oneitemOldPriceLabel.text = ""
//                    oneitemOldPriceBgView.isHidden = true
//                    oneproductDiscountBgView.isHidden = true
//                    oneitemDicountLabel.text = ""
//                }
//            }
//        }
//    }
    
    var products : Products! {
        didSet {
            cartUpdateViewWidthConstraint.constant = products.isCartOpen ? 50 : 0
            self.layoutIfNeeded()
            
            oneCartView.isHidden = false
            twoCartView.isHidden = true
            threeCartView.isHidden = true
            
            oneitemDicountLabel.text   = ""
            oneitemNameLabel.text      = ""
            oneitemUnitTypeLabel.text  = ""
            oneitemOldPriceLabel.text  = ""
            oneitemNewPriceLabel.text  = ""
            oneitemQtyLabel.text       = ""
            oneitemOldPriceBgView.isHidden     = true
            oneproductDiscountBgView.isHidden  = true
            
            oneitemImageView.image = Product_Placeholder
            if products.product_image_small != nil {
                oneitemImageView.sd_setImage(with: products.product_image_small, placeholderImage: Product_Placeholder)
            }
            
            switch appLanguage {
            case .Arabic    :
                oneitemUnitTypeLabel.text   = "\(products.unit_value) " + products.unit_ar
                oneitemNameLabel.text       = products.product_name_ar
            case .Dutch     :
                oneitemUnitTypeLabel.text   = "\(products.unit_value) " + products.unit_de
                oneitemNameLabel.text       = products.product_name_nl
            case .English   :
                oneitemUnitTypeLabel.text   = "\(products.unit_value) " + products.unit_en
                oneitemNameLabel.text       = products.product_name_en
            case .Swedish   :
                oneitemUnitTypeLabel.text   = "\(products.unit_value) " + products.unit_de
                oneitemNameLabel.text       = products.product_name_de
            case .Turkish   :
                oneitemUnitTypeLabel.text   = "\(products.unit_value) " + products.unit_tr
                oneitemNameLabel.text       = products.product_name_tr
            }
            oneitemNameLabel.textColor      = SettingList.default_text_color
            oneexpressDeliveryImageView.isHidden = products.is_express ? false : true
            
            let oldPrice : Double = products.price * Double(products.qty)
            oneitemOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + oldPrice.twoDigitsString, fontSize: 16)
            
            oneitemQtyLabel.text = "\(products.qty ?? 0)"
            
            if products.offer_type.trimmedLength > 0 {
                oneproductDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
                oneproductDiscountBgView.isHidden = false
                
                if products.offer_type == "flatcombo" {
                    oneitemDicountLabel.text = "\(products.number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(products.offer_discount ?? 0)"
                } else if products.offer_type == "plusone" {
                    oneitemDicountLabel.text = "\(products.number_of_products ?? 0) + 1 gratis"
                } else {
                    oneproductDiscountBgView.isHidden = true
                    oneitemDicountLabel.text = ""
                }
            } else if products.discount > 0 {
                oneproductDiscountBgView.backgroundColor = .darkGray
                oneproductDiscountBgView.isHidden = false
                oneitemOldPriceBgView.isHidden = false
                
                if (products.discount_type == "flat") {
                    oneitemDicountLabel.text = "\(products.discount) Flat"
                } else if (products.discount_type == "percentage") {
                    oneitemDicountLabel.text = "\(products.discount)% Discount"
                } else {
                    oneitemOldPriceLabel.text = ""
                    oneitemOldPriceBgView.isHidden = true
                }
            } else {
                oneitemOldPriceLabel.text = ""
                oneitemOldPriceBgView.isHidden = true
                oneproductDiscountBgView.isHidden = true
                oneitemDicountLabel.text = ""
            }
        }
    }
    
    var effectedPrice : Double! {
        didSet {
            if products != nil {
                if products.offer_type.trimmedLength == 0 {
                    if products.discount == 0 {
                        let price : Double = products.price * Double(products.qty)
                        oneitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + price.twoDigitsString, fontSize: 20)
                    } else {
                        var price : Double = 0
                        if (products.discount_type == "flat") {
                            price = (products.price - Double(products.discount)) * Double(products.qty)
                        } else if (products.discount_type == "percentage") {
                            let dicount : Double = ((products.price * Double(100 - products.discount)) / 100)
                            price = dicount * Double(products.qty)
                        }
                        oneitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + price.twoDigitsString, fontSize: 20)
                    }
                } else {
                    oneitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + effectedPrice.twoDigitsString, fontSize: 20)
                }
            } else {
                oneitemNewPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + effectedPrice.twoDigitsString, fontSize: 20)
            }
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonCartQTY(_ sender: Any) {
        if products.offer_type.trimmedLength == 0 {
            products.isCartOpen = !products.isCartOpen
            cartUpdateViewWidthConstraint.constant = products.isCartOpen ? 50 : 0
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @IBAction private func didTapOnButtonAddToCart(_ sender: Any) {
        if products != nil, let cartViewController = self.viewContainingController() as? CartViewController {
            cartViewController.cartAddAPICall(products: products)
        }
    }
    
    @IBAction private func didTapOnButtonRemoveFromCart(_ sender: Any) {
        
        if products != nil, let cartViewController = self.viewContainingController() as? CartViewController {
            cartViewController.cartMinusAPICall(products: products)
        }
    }
    
    
}
