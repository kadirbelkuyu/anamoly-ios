//
//  HomeDetailViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 24/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import WebKit

class HomeDetailViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet private weak var productImageCollectionView           : UICollectionView!
    @IBOutlet private weak var productDiscountBgView                : UIView!
    @IBOutlet private weak var productDiscountLabel                 : UILabel!
    @IBOutlet private weak var productNameLabel                     : UILabel!
    @IBOutlet private weak var productWeightLabel                   : UILabel!
    @IBOutlet private weak var expressDeliveryImageView             : UIImageView!
    @IBOutlet private weak var productOldPriceView                  : UIView!
    @IBOutlet private weak var productOldPriceLabel                 : UILabel!
    @IBOutlet private weak var productPriceLabel                    : UILabel!
    @IBOutlet private weak var productIngredientsCollectionView     : UICollectionView!
    @IBOutlet private weak var plusButton                           : UIButton!
    @IBOutlet private weak var productCountLabel                    : UILabel!
    @IBOutlet private weak var minusButton                          : UIButton!
    @IBOutlet private weak var productDetailWebView                 : WKWebView!
    @IBOutlet private weak var productDetailWebViewHeightConstant   : NSLayoutConstraint!
    
    var products                    : Products?
    private var productsObject      : Products?
    private var productImageTimer   = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }

    //MARK: - Prepare View -
    private func prepareView() {
        if let products = products {
            self.setProduct(products: products)
        }
        
        DispatchQueue.main.async { [weak self] () in
            guard let `self` = self else {return}
            self.productDetailAPICall()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func didTapOnButtonPlus(_ sender: Any) {
        if let products = products {
            cartAddAPICall(products: products)
        }
    }
    @IBAction private func didTapOnButtonMinus(_ sender: Any) {
        if let products = products {
            cartMinusAPICall(products: products)
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
extension HomeDetailViewController {
    
    private func productDetailAPICall() {
        guard let user = AppUser else {return}
        guard let products = products else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.product_id  : products.product_id
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.productDetail(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                self.productsObject = Products.init(aDict: data)
                self.setProduct(products: self.productsObject!)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func cartAddAPICall(products : Products) {
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
                products.cart_qty = products.cart_qty + 1
                self.cartValueUpdate(products: products)
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                        seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                    }
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func cartMinusAPICall(products : Products) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.product_id  : products.product_id,
                        SText.Parameter.qty     : 1,
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartMinus(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if response.success, let data = response.data {
                products.cart_qty = products.cart_qty - 1
                self.cartValueUpdate(products: products)
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                        seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                    }
                }
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
extension HomeDetailViewController {
    
    private func setProduct(products : Products) {
        productImageCollectionView.reloadData()
        productIngredientsCollectionView.reloadData()
        
        productImageTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (status) in
            if (products.images.count > 1) {
                let indexRow = Int(self.productImageCollectionView.contentOffset.x / self.productImageCollectionView.frame.size.width)
                if indexRow == products.images.count - 1 {
                    self.productImageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                } else {
                    self.productImageCollectionView.scrollToItem(at: IndexPath(item: indexRow + 1, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        })
        
        switch appLanguage {
        case .Arabic    :
            productWeightLabel.text = "\(products.unit_value) " + products.unit_ar
            productNameLabel.text   = products.product_name_ar
            productDetailWebView.loadHTMLString(products.product_desc_ar, baseURL: nil)
        case .Dutch     :
            productWeightLabel.text = "\(products.unit_value) " + products.unit
            productNameLabel.text   = products.product_name_nl
            productDetailWebView.loadHTMLString(products.product_desc_nl, baseURL: nil)
        case .English   :
            productWeightLabel.text = "\(products.unit_value) " + products.unit_en
            productNameLabel.text   = products.product_name_en
            productDetailWebView.loadHTMLString(products.product_desc_en, baseURL: nil)
        case .Swedish   :
            productWeightLabel.text = "\(products.unit_value) " + products.unit_de
            productNameLabel.text   = products.product_name_de
            productDetailWebView.loadHTMLString(products.product_desc_de, baseURL: nil)
        case .Turkish   :
            productWeightLabel.text = "\(products.unit_value) " + products.unit_tr
            productNameLabel.text   = products.product_name_tr
            productDetailWebView.loadHTMLString(products.product_desc_tr, baseURL: nil)
        }
        
        expressDeliveryImageView.isHidden = products.is_express ? false : true
        
        //Offer
        productDiscountBgView.backgroundColor = ColorApp.ColorRGB(65,23,116,1)
        productDiscountLabel.font = UIFont.Tejawal.Medium(18)
        
        productDiscountLabel.text = ""
        productDiscountBgView.isHidden = false
        if products.offer_type == "flatcombo" {
            productDiscountLabel.text = "\(products.number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(products.offer_discount ?? 0)"
        } else if products.offer_type == "plusone" {
            productDiscountLabel.text = "\(products.number_of_products ?? 0) + 1 gratis"
        } else {
            productDiscountBgView.isHidden = true
            productDiscountLabel.text = ""
        }
        if products.offer_type.trimmedLength == 0 {
            //Discount
            productDiscountBgView.backgroundColor = .darkGray
            productDiscountLabel.font = UIFont.Tejawal.Medium(15)
            
            if products.discount > 0 {
                productDiscountBgView.isHidden = false
                
                if (products.discount_type == "flat") {
                    productOldPriceView.isHidden = false
                    productDiscountLabel.text = "\(products.discount) Flat"
                } else if (products.discount_type == "percentage") {
                    productOldPriceView.isHidden = false
                    productDiscountLabel.text = "\(products.discount)% Discount"
                } else {
                    productOldPriceView.isHidden = true
                }
            } else {
                productOldPriceView.isHidden = true
                productDiscountBgView.isHidden = true
                productDiscountLabel.text = ""
            }
        }
        
        productOldPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + products.price.twoDigitsString, fontSize: 20)
        
        var priceString = ""
        if (products.discount_type == "flat") {
            let afterFlatOffPrice = products.price - Double(products.discount)
            priceString = afterFlatOffPrice > 0 ? afterFlatOffPrice.twoDigitsString : "0"
        } else if (products.discount_type == "percentage") {
            let afterDiscountPrice = products.price - ((products.price * Double(products.discount)) / 100)
            priceString = afterDiscountPrice > 0 ? afterDiscountPrice.twoDigitsString : "0"
        } else {
            priceString = products.price.twoDigitsString
        }
        productPriceLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + priceString, fontSize: 20)
        if productOldPriceLabel.text == productPriceLabel.text {
            productOldPriceView.isHidden = true
        }
        
        productCountLabel.text = "\(products.cart_qty ?? 0)"
        minusButton.isEnabled = products.cart_qty == 0 ? false : true

        
        productDetailWebView.navigationDelegate = self
        productDetailWebView.scrollView.isScrollEnabled = false
    }
    
    private func cartValueUpdate(products : Products) {
        minusButton.isEnabled = products.cart_qty == 0 ? false : true
        productCountLabel.text = "\(products.cart_qty ?? 0)"
    }
    
}

//MARK: - CollectionView DataSource, Delegate, DelegateFlowLayout
extension HomeDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let products = productsObject else { return 0 }
        if collectionView == productImageCollectionView {
            if products.images.count > 0 {
                return products.images.count
            } else {
                if products.product_image != nil {
                    return 1
                }
            }
        } else {
            return products.ingredients.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productImageCollectionView {
            let cell = collectionView.registerAndGet(cell: HomeSituationCollectionViewCell.self, indexPath: indexPath)!
            if productsObject?.images.count ?? 0 > 0 {
                cell.images = productsObject?.images[indexPath.item]
            } else if let productImage = productsObject?.product_image {
                cell.productImage = productImage
            } else {
                cell.homeSituationImage = UIImage()
            }
            return cell
        } else {
            let cell = collectionView.registerAndGet(cell: ProductIngredientsCollectionViewCell.self, indexPath: indexPath)!
            cell.ingredients = productsObject?.ingredients[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productImageCollectionView {
            var urlStringArray : [String] = []
            for object in productsObject?.images ?? [] {
                if object.product_image != nil {
                    urlStringArray.append(object.product_image.absoluteString)
                }
            }
            if productsObject?.images.count == 0 {
                if let productImage = productsObject?.product_image {
                    urlStringArray.append(productImage.absoluteString)
                }
            }
            if urlStringArray.count > 0 {
                let zoomPinchView = (ZoomPinchMultiImageView() as ZoomPinchMultiImageView).loadViewFromNib()
                zoomPinchView.currentImageIndex = indexPath.item
                zoomPinchView.showInView(toView: self.view, withArray: urlStringArray , withCurrentIndex: indexPath.item)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productImageCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            let label = UILabel(frame: CGRect.zero)
            switch appLanguage {
            case .Arabic    : label.text = productsObject?.ingredients[indexPath.item].ingredient_name_ar
            case .Dutch     : label.text = productsObject?.ingredients[indexPath.item].ingredient_name_nl
            case .English   : label.text = productsObject?.ingredients[indexPath.item].ingredient_name_en
            case .Swedish   : label.text = productsObject?.ingredients[indexPath.item].ingredient_name_nl
            case .Turkish   : label.text = productsObject?.ingredients[indexPath.item].ingredient_name_nl
            }
            label.font = UIFont.Tejawal.Medium(20)
            label.sizeToFit()
            return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height)
        }
    }
    
}

extension HomeDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.productDetailWebViewHeightConstant.constant = webView.scrollView.contentSize.height + 100
            self.view.layoutIfNeeded()
        }
    }
    
}
