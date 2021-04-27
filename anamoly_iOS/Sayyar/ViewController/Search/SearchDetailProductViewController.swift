//
//  SearchDetailProductViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 20/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SearchDetailProductViewController: BaseViewController {

    @IBOutlet private weak var searchProductDetailNavigationTitleLabel  : UILabel!
    @IBOutlet private weak var categoryCollectionView                   : UICollectionView!
    @IBOutlet private weak var segmentCollectionView                    : UICollectionView!
    @IBOutlet private weak var searchProductDetailCollectionView        : UICollectionView!
    @IBOutlet private weak var cartAmountLabel                          : UILabel!
    @IBOutlet private weak var cartButton                               : UIButton!
    
    var categoryListModel       : CategoryListModel?
    var subcategoriesArray      : [Subcategories] = []
    var subcategories           : Subcategories?
    private var productArray    : [Product] = []
    
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
        searchProductDetailCollectionView.reloadData()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        //Cell Register
        searchProductDetailCollectionView.register(UINib(nibName: String(describing: HomeProductSectionCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HomeProductSectionCollectionReusableView.self))
        
        if let subcategories = subcategories {
            _ = subcategoriesArray.map( { $0.isSelected = false } )
            let filterData = subcategoriesArray.filter( { $0.sub_category_id == subcategories.sub_category_id } )
            if filterData.count > 0 {
                filterData[0].isSelected = true
                if let index = subcategoriesArray.firstIndex(of: filterData[0]) {
                    categoryCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
        categoryCollectionView.isHidden = subcategoriesArray.count == 0
        
        productsListAPICall()
    }

    //MARK: - Action Methods -
    @IBAction func didTapOnButtonBack(_ sender: Any) {
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
extension SearchDetailProductViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return collectionView == segmentCollectionView ? 1 : productArray.count == 0 ? 1 : productArray.count
        switch collectionView {
        case categoryCollectionView             : return 1
        case segmentCollectionView              : return 1
        case searchProductDetailCollectionView  : return productArray.count == 0 ? 1 : productArray.count
        default                                 : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView             : return subcategoriesArray.count
        case segmentCollectionView              : return productArray.count
        case searchProductDetailCollectionView  :
            if productArray.count == 0 {
                return 1
            } else if (productArray[section].products.count > 0) {
                return productArray.count - 1 == section ? productArray[section].products.count + 1 : productArray[section].products.count
            } else {
                return productArray[section].products.count
            }
        default                                 : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView             :
            let cell = collectionView.registerAndGet(cell: HomeSegmentBarCollectionViewCell.self, indexPath: indexPath)!
            cell.setSubcategories(subcategoriesArray[indexPath.item])
            return cell
        case segmentCollectionView              :
            let cell = collectionView.registerAndGet(cell: HomeSegmentCollectionViewCell.self, indexPath: indexPath)!
            cell.product = productArray[indexPath.item]
            return cell
        case searchProductDetailCollectionView  :
            if productArray.count == 0 {
                let cell = collectionView.registerAndGet(cell: HomeRequestNewCollectionViewCell.self, indexPath: indexPath)!
                return cell
            } else if productArray[indexPath.section].products.count - 1 >= indexPath.row {
                let cell = collectionView.registerAndGet(cell: HomeProductCollectionViewCell.self, indexPath: indexPath)!
                cell.productAddBlock = { [weak self] () in
                    guard let `self` = self else { return }
                    self.cartAddAPICall(products: self.productArray[indexPath.section].products[indexPath.item], qty: 1)
                    self.productImage(imageView: cell.productImageView)
                }
                cell.productMinusBlock = { [weak self] () in
                    guard let `self` = self else { return }
                    self.cartMinusAPICall(products: self.productArray[indexPath.section].products[indexPath.item])
                }
                cell.products = productArray[indexPath.section].products[indexPath.item]
                return cell
            } else {
                let cell = collectionView.registerAndGet(cell: HomeRequestNewCollectionViewCell.self, indexPath: indexPath)!
                return cell
            }
        default                                 : return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCollectionView             :
            let label = UILabel()
            switch appLanguage {
            case .Arabic    : label.text = subcategoriesArray[indexPath.item].sub_cat_name_ar
            case .Dutch     : label.text = subcategoriesArray[indexPath.item].sub_cat_name_nl
            case .English   : label.text = subcategoriesArray[indexPath.item].sub_cat_name_en
            case .Swedish   : label.text = subcategoriesArray[indexPath.item].sub_cat_name_de
            case .Turkish   : label.text = subcategoriesArray[indexPath.item].sub_cat_name_tr
            }
            label.font = UIFont.Tejawal.Medium(15)
            label.sizeToFit()
            return CGSize(width: label.getLabelWidth(), height: collectionView.frame.size.height)
        case segmentCollectionView              :
            let label = UILabel()
            switch appLanguage {
            case .Arabic    : label.text = productArray[indexPath.item].group_name_ar
            case .Dutch     : label.text = productArray[indexPath.item].group_name_nl
            case .English   : label.text = productArray[indexPath.item].group_name_en
            case .Swedish   : label.text = productArray[indexPath.item].group_name_de
            case .Turkish   : label.text = productArray[indexPath.item].group_name_tr
            }
            label.font = UIFont.Tejawal.Medium(15)
            label.sizeToFit()
            return CGSize(width: label.getLabelWidth() + 30, height: collectionView.frame.size.height)
        case searchProductDetailCollectionView  :
            let cellWidth = (ScreenWidth - 30) / 2
            return CGSize(width: cellWidth, height: cellWidth * 1.20)
        default                                 : return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView             :
            _ = subcategoriesArray.map( { $0.isSelected = false } )
            subcategoriesArray[indexPath.item].isSelected = true
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            subcategories = subcategoriesArray[indexPath.item]
            productsListAPICall()
        case segmentCollectionView              :
            _ = productArray.map( { $0.isSelected = false } )
            productArray[indexPath.item].isSelected = true
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if productArray[indexPath.item].products.count > 0 {
//                searchProductDetailCollectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath.item), at: .top, animated: true)
                if let attributes = searchProductDetailCollectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.item)) {
                    var offsetY = attributes.frame.origin.y - searchProductDetailCollectionView.contentInset.top
                    offsetY -= searchProductDetailCollectionView.safeAreaInsets.top - 5
                    searchProductDetailCollectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true) // or animated: false
                }
            }
        case searchProductDetailCollectionView  :
            if productArray.count == 0 {
                let requestNewProductViewController = UIStoryboard.Home.get(RequestNewProductViewController.self)!
                requestNewProductViewController.modalPresentationStyle = .overFullScreen
                requestNewProductViewController.modalTransitionStyle = .crossDissolve
                self.present(requestNewProductViewController, animated: true, completion: nil)
            } else if productArray[indexPath.section].products.count - 1 >= indexPath.row {
                if let homeDetailViewController = UIStoryboard.Home.get(HomeDetailViewController.self) {
                    homeDetailViewController.products = self.productArray[indexPath.section].products[indexPath.item]
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
        default                                 : break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == searchProductDetailCollectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing : HomeProductSectionCollectionReusableView.self), for: indexPath) as! HomeProductSectionCollectionReusableView
                if productArray.count > 0 {
                    headerView.searchProduct = productArray[indexPath.section]
                }
                headerView.isMoreButtonHide = true
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
        }
        assert(false, "Unexpected element kind")
        return UICollectionReusableView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == searchProductDetailCollectionView, productArray.count > 0 {
            return CGSize(width: ScreenWidth, height: 60)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(searchProductDetailCollectionView.indexPathsForVisibleItems)
        if scrollView == searchProductDetailCollectionView && searchProductDetailCollectionView.indexPathsForVisibleItems.count > 0 {
            var indexPath = IndexPath(item: 0, section: 0)
//            switch searchProductDetailCollectionView.indexPathsForVisibleItems.count {
//            case 1: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[0]
//            case 2: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[0]
//            case 3: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[1]
//            case 4: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[2]
//            case 5: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[3]
//            case 6: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[3]
//            case 7: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[4]
//            case 8: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[4]
//            case 9: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[5]
//            case 10: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[5]
//            case 11: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[6]
//            case 12: indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[6]
//            default: break
//            }
//            indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems[0]
            indexPath = searchProductDetailCollectionView.indexPathsForVisibleItems.sorted(by: { $0 < $1 } )[0]
            _ = productArray.map( { $0.isSelected = false } )
            productArray[indexPath.section].isSelected = true
            segmentCollectionView.reloadData()
            segmentCollectionView.scrollToItem(at: IndexPath(item: indexPath.section, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView == searchProductDetailCollectionView {
//            for cell in searchProductDetailCollectionView.visibleCells {
//                if let indexPath = searchProductDetailCollectionView.indexPath(for: cell) {
//                    _ = productArray.map( { $0.isSelected = false } )
//                    productArray[indexPath.section].isSelected = true
//                    segmentCollectionView.reloadData()
//                    segmentCollectionView.scrollToItem(at: IndexPath(item: indexPath.section, section: 0), at: .centeredHorizontally, animated: false)
//                }
//            }
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == searchProductDetailCollectionView {
//            for cell in searchProductDetailCollectionView.visibleCells {
//                if let indexPath = searchProductDetailCollectionView.indexPath(for: cell) {
//                    _ = productArray.map( { $0.isSelected = false } )
//                    productArray[indexPath.section].isSelected = true
//                    segmentCollectionView.reloadData()
//                    segmentCollectionView.scrollToItem(at: IndexPath(item: indexPath.section, section: 0), at: .centeredHorizontally, animated: false)
//                }
//            }
//        }
//    }
    
}

//MARK: - API Call -
extension SearchDetailProductViewController {
    
    private func productsListAPICall() {
        guard let user = AppUser else {return}
        var param : [String : Any] = [:]
        if let subcategories = subcategories {
            switch appLanguage {
            case .Arabic    : searchProductDetailNavigationTitleLabel.text = subcategories.sub_cat_name_ar
            case .Dutch     : searchProductDetailNavigationTitleLabel.text = subcategories.sub_cat_name_nl
            case .English   : searchProductDetailNavigationTitleLabel.text = subcategories.sub_cat_name_en
            case .Swedish   : searchProductDetailNavigationTitleLabel.text = subcategories.sub_cat_name_de
            case .Turkish   : searchProductDetailNavigationTitleLabel.text = subcategories.sub_cat_name_tr
            }
            param = [
                        SText.Parameter.user_id         : user.user_id ?? 0,
                        SText.Parameter.category_id     : subcategories.category_id ?? "",
                        SText.Parameter.sub_category_id : subcategories.sub_category_id ?? ""
                    ] as [String : Any]
        }
        if let categoryListModel = categoryListModel {
            switch appLanguage {
            case .Arabic    : searchProductDetailNavigationTitleLabel.text = categoryListModel.cat_name_ar
            case .Dutch     : searchProductDetailNavigationTitleLabel.text = categoryListModel.cat_name_nl
            case .English   : searchProductDetailNavigationTitleLabel.text = categoryListModel.cat_name_en
            case .Swedish   : searchProductDetailNavigationTitleLabel.text = categoryListModel.cat_name_de
            case .Turkish   : searchProductDetailNavigationTitleLabel.text = categoryListModel.cat_name_tr
            }
            param = [
                        SText.Parameter.user_id         : user.user_id ?? 0,
                        SText.Parameter.category_id     : categoryListModel.category_id ?? ""
                    ] as [String : Any]
        }
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.productsList(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                self.productArray.removeAll()
                for object in data.arrayValue {
                    if object["products"].arrayValue.count > 0 {
                        self.productArray.append(Product.init(aDict: object))
                    }
                }
                if self.productArray.count > 0 {
                    self.productArray[0].isSelected = true
                }
                self.segmentCollectionView.isHidden = self.productArray.count == 0
                self.segmentCollectionView.reloadData()
                self.searchProductDetailCollectionView.reloadData()
//                if self.productArray.count == 0 {
//                    let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    self.showAlert(withMessage: appLanguage == .Dutch ? "Geen producten gevonden." : "No Products Found.", withActions: okButton)
//                }
            } else {
//                let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                self.showAlert(withMessage: appLanguage == .Dutch ? "Geen producten gevonden." : "No Products Found.", withActions: okButton)
                self.segmentCollectionView.reloadData()
                self.searchProductDetailCollectionView.reloadData()
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
                self.searchProductDetailCollectionView.reloadData()
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
                self.searchProductDetailCollectionView.reloadData()
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
extension SearchDetailProductViewController {
    
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
