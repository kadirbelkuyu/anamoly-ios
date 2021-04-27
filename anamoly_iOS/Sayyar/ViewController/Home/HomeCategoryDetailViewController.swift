//
//  HomeCategoryDetailViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeCategoryDetailViewController: BaseViewController {

    @IBOutlet private weak var homeCategoryDetailNavigationBarTitleLabel    : UILabel!
    @IBOutlet private weak var homeCategoryDetailCollectionView             : UICollectionView!
    @IBOutlet private weak var cartAmountLabel                              : UILabel!
    @IBOutlet private weak var cartButton                                   : UIButton!
    
    var productObject           : Product?
    private var productsArray   : [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.parent as? UINavigationController {
            if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                cartAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: " " + seyyarTabbarViewController.cartAmount.twoDigitsString, fontSize: 15)
            }
        }
        homeCategoryDetailCollectionView.reloadData()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        if let product = productObject {
            homeCategoryDetailNavigationBarTitleLabel.text = appLanguage == .Dutch ? product.sub_cat_name_nl : product.sub_cat_name_en
            productsListAPICall()
        }
    }

    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonBarcodeScanner(_ sender: Any) {
        if let barcodeScanViewController = UIStoryboard.Home.get(BarcodeScanViewController.self) {
            self.navigationController?.pushViewController(barcodeScanViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnButtonTabbar(_ sender : UIButton) {
        if let navigationController = self.parent as? UINavigationController {
            if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                navigationController.popToRootViewController(animated: true)
                switch sender.tag {
                case 0  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.homeButton)
                case 1  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.searchButton)
                case 2  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.cartButton)
                case 3  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.profileButton)
                default : break
                }
            }
        }
    }
    
    @IBAction private func didTapOnButtonFeatureList(_ sender: Any) {
        if let featuredViewController = UIStoryboard.Main.get(FeaturedViewController.self) {
            featuredViewController.modalTransitionStyle = .crossDissolve
            featuredViewController.modalPresentationStyle = .overFullScreen
            featuredViewController.updatedBlock = { [weak self] () in
                guard let `self` = self else { return }
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        navigationController.popToRootViewController(animated: true)
                        seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.homeButton)
                    }
                }
            }
            self.present(featuredViewController, animated: true, completion: nil)
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

//MARK: - CollectionView DataSource, Delegate, Flowlayout Delegate -
extension HomeCategoryDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if productsArray.count - 1 >= indexPath.row {
            let cell = collectionView.registerAndGet(cell: HomeProductCollectionViewCell.self, indexPath: indexPath)!
            cell.productAddBlock = { [weak self] () in
                guard let `self` = self else { return }
                self.cartAddAPICall(products: self.productsArray[indexPath.row], qty: 1)
                self.productImage(imageView: cell.productImageView)
            }
            cell.productMinusBlock = { [weak self] () in
                guard let `self` = self else { return }
                self.cartMinusAPICall(products: self.productsArray[indexPath.row])
            }
            cell.products = productsArray[indexPath.row]
            return cell
        } else {
            let cell = collectionView.registerAndGet(cell: HomeRequestNewCollectionViewCell.self, indexPath: indexPath)!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - 30) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if productsArray.count - 1 >= indexPath.row {
            if let homeDetailViewController = UIStoryboard.Home.get(HomeDetailViewController.self) {
                homeDetailViewController.products = productsArray[indexPath.row]
                if let homeViewController = self.parent?.parent as? HomeViewController {
                    homeViewController.isProductDetailPagePushed = true
                }
                self.navigationController?.pushViewController(homeDetailViewController, animated: true)
            }
        } else {
            let requestNewProductViewController = UIStoryboard.Home.get(RequestNewProductViewController.self)!
            requestNewProductViewController.modalPresentationStyle = .overFullScreen
            requestNewProductViewController.modalTransitionStyle = .crossDissolve
            self.present(requestNewProductViewController, animated: true, completion: nil)
        }
    }
    
}

//MARK: - API Call -
extension HomeCategoryDetailViewController {
    
    private func productsListAPICall() {
        guard let user = AppUser else {return}
        guard let product = productObject else {return}
        let param = [
                        SText.Parameter.user_id         : user.user_id ?? 0,
                        SText.Parameter.category_id     : product.category_id ?? 0,
                        SText.Parameter.sub_category_id : product.sub_category_id ?? 0
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.productsList(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                var productArray : [Product] = []
                for object in data.arrayValue {
                    productArray.append(Product.init(aDict: object))
                }
                for object in productArray {
                    self.productsArray.append(contentsOf: object.products)
                }
                self.homeCategoryDetailCollectionView.reloadData()
            } else {
//                let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                self.showAlert(withMessage: "No Products Found.", withActions: okButton)
                self.homeCategoryDetailCollectionView.reloadData()
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func cartAddAPICall(products : Products, qty : Int) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.product_id  : products.product_id,
                        SText.Parameter.qty         : qty,
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartAdd(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if response.success, let data = response.data {
                products.cart_qty = products.cart_qty + qty
                self.homeCategoryDetailCollectionView.reloadData()
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                        seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                        self.cartAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: " " + amount.twoDigitsString, fontSize: 15)
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
                        SText.Parameter.qty         : 1,
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartMinus(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if response.success, let data = response.data {
                products.cart_qty = products.cart_qty - 1
                self.homeCategoryDetailCollectionView.reloadData()
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                        seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                        self.cartAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: " " + amount.twoDigitsString, fontSize: 15)
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
extension HomeCategoryDetailViewController {
    
    private func animationProductImage(animationView : UIView)  {
        self.view.addSubview(animationView)
        UIView.animate(withDuration: 2, animations: { animationView.animationZoom(scaleX: 1, y: 1) }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                animationView.animationZoom(scaleX: 0.2, y: 0.2)
                animationView.animationRoted(angle: CGFloat(Double.pi))
                animationView.frame.origin.x = self.cartButton.frame.origin.x + (self.cartButton.frame.size.width / 2)
                animationView.frame.origin.y = self.view.frame.size.height + 20
            }, completion: { _ in
                animationView.removeFromSuperview()
                UIView.animate(withDuration: 1.0, animations: {
                    self.cartButton.animationZoom(scaleX: 1.4, y: 1.4)
                }, completion: {_ in
                    self.cartButton.animationZoom(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }
    
    private func productImage(imageView : UIImageView) {
        let imageViewPosition : CGPoint = imageView.convert(imageView.bounds.origin, to: self.view)
        let imgViewTemp     = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: imageView.frame.size.width, height: imageView.frame.size.height))
        imgViewTemp.image   = imageView.image
        animationProductImage(animationView: imgViewTemp)
    }
    
}
