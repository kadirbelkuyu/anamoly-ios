//
//  HomeContentViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 20/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeContentViewController: BaseViewController {

    @IBOutlet private weak var bannerViewHeightConstraint   : NSLayoutConstraint!
    @IBOutlet         weak var bannerCollectionView         : UICollectionView!
    @IBOutlet private weak var bannerPageControl            : UIPageControl!
    @IBOutlet         weak var productCollectionView        : UICollectionView!
    
    private var bannerImageTimer    = Timer()
    var homeProduct                 : HomeProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        ///Cell Register
        productCollectionView.register(UINib(nibName: String(describing: HomeProductSectionCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HomeProductSectionCollectionReusableView.self))
    }
    
    //MARK: - Action Methods -
    @IBAction func didChangeValueOfPageControlBanner(_ sender: UIPageControl) {
        bannerCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
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
extension HomeContentViewController {
    
    private func setBannerView(banners : [Banner]) {
        bannerViewHeightConstraint.constant = banners.count > 0 ? 100 : 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        bannerImageTimer.invalidate()
        bannerImageTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (status) in
            if (banners.count > 1) {
                let indexRow = Int(self.bannerCollectionView.contentOffset.x / self.bannerCollectionView.frame.size.width)
                if indexRow == banners.count - 1 {
                    self.bannerCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                } else {
                    self.bannerCollectionView.scrollToItem(at: IndexPath(item: indexRow + 1, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        })
    }
    
    func collectionViewReloadData() {
        if bannerCollectionView != nil {
            bannerCollectionView.reloadData()
        } else {
            print("Banner Collection view not reload")
        }
        if productCollectionView != nil {
            productCollectionView.reloadData()
        } else {
            print("Banner Collection view not reload")
        }
    }
    
}

//MARK: - CollectionView DataSource, Delegate, Flowlayout Delegate -
extension HomeContentViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let homeProduct = homeProduct {
            if collectionView == bannerCollectionView {
                setBannerView(banners: homeProduct.banners)
                return homeProduct.banners.count > 0 ? 1 : 0
            } else {
                return homeProduct.product.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let homeProduct = homeProduct {
            if collectionView == bannerCollectionView {
                bannerPageControl.numberOfPages = homeProduct.banners.count
                return homeProduct.banners.count
            } else {
                return homeProduct.product[section].products.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let homeProduct = homeProduct {
            if collectionView == bannerCollectionView {
                let cell = collectionView.registerAndGet(cell: HomeBannerCollectionViewCell.self, indexPath: indexPath)!
                cell.banner = homeProduct.banners[indexPath.row]
                return cell
            } else {
                let cell = collectionView.registerAndGet(cell: HomeProductCollectionViewCell.self, indexPath: indexPath)!
                cell.productAddBlock = { [weak self] () in
                    guard let `self` = self else { return }
                    self.cartAddAPICall(products : homeProduct.product[indexPath.section].products[indexPath.row], indexPath: indexPath)
                    if let homeViewController = self.parent?.parent as? HomeViewController {
                        homeViewController.productImage(imageView: cell.productImageView)
                    }
                }
                cell.productMinusBlock = { [weak self] () in
                    guard let `self` = self else { return }
                    self.cartMinusAPICall(products: homeProduct.product[indexPath.section].products[indexPath.row], indexPath: indexPath)
                }
                cell.products = homeProduct.product[indexPath.section].products[indexPath.row]
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: ScreenWidth, height: collectionView.frame.size.height)
        } else {
            let cellWidth = (collectionView.frame.size.width - 30) / 2
            return CGSize(width: cellWidth, height: cellWidth * 1.20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView {
            if let homeProduct = homeProduct {
                if let homeDetailViewController = UIStoryboard.Home.get(HomeDetailViewController.self) {
                    homeDetailViewController.products = homeProduct.product[indexPath.section].products[indexPath.row]
                    if let homeViewController = self.parent?.parent as? HomeViewController {
                        homeViewController.isProductDetailPagePushed = true
                    }
                    self.navigationController?.pushViewController(homeDetailViewController, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == bannerCollectionView) {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            bannerPageControl.currentPage = index
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (collectionView == productCollectionView) {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing : HomeProductSectionCollectionReusableView.self), for: indexPath) as! HomeProductSectionCollectionReusableView
                if let homeProduct = homeProduct {
                    headerView.homeProduct = homeProduct.product[indexPath.section]
                    headerView.isMoreButtonHide = false
                }
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
        }
        assert(false, "Unexpected element kind")
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (collectionView == productCollectionView) {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        return CGSize(width: 0, height: 0)
    }
    
}

//MARK: - API Call -
extension HomeContentViewController {
    
    private func cartAddAPICall(products: Products, indexPath : IndexPath) {
        guard let user = AppUser else {return}
        if let homeViewController = self.parent?.parent as? HomeViewController {
            let param = [
                            SText.Parameter.user_id     : user.user_id ?? 0,
                            SText.Parameter.product_id  : products.product_id,
                            SText.Parameter.qty         : 1,
                        ] as [String : Any]
            homeViewController.startActivityIndicator()
            APIManager.shared.callRequestWithMultipartData(APIRouter.cartAdd(param), arrImages: [], onSuccess: { (response) in
                homeViewController.stopActivityIndicator()
                if response.success, let data = response.data {
                    if let seyyarTabbarViewController = self.parent?.parent?.parent?.parent as? SeyyarTabbarViewController {
                        let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                        seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                    }
                    products.cart_qty += 1
                    self.productCollectionView.reloadItems(at: [indexPath])
                    if products.product_offer_id != 0 {
                        let homeProduct = HomeProduct.init(aDict: data)
                        var product : Product?
                        for object in homeProduct.product {
                            let filterData = object.products.filter( { $0.product_id == products.product_id } )
                            if filterData.count > 0 {
                                product = object
                            }
                        }
                        if let product = product {
                            homeViewController.offerView(isShow: true)
                            homeViewController.offerProductCountManage(product: product)
                        } else {
                            homeViewController.offerView(isShow: false)
                        }
                    } else {
                        homeViewController.offerView(isShow: false)
                    }
                } else {
                    self.showAlert(withMessage: response.message ?? "")
                }
            }, onFailure: { (apiErrorResponse) in
                homeViewController.stopActivityIndicator()
                self.showAlert(withMessage: apiErrorResponse.message)
            })
        }
    }
    
    private func cartMinusAPICall(products : Products, indexPath : IndexPath) {
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
                if let seyyarTabbarViewController = self.parent?.parent?.parent?.parent as? SeyyarTabbarViewController {
                    let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                    seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                }
                products.cart_qty -= 1
                self.productCollectionView.reloadItems(at: [indexPath])
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
