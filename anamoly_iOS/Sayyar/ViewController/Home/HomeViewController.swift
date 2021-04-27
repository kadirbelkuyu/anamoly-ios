//
//  HomeViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: - Outlets -
    @IBOutlet private weak var topView                      : UIView!
    @IBOutlet private weak var navigationView               : UIView!
    @IBOutlet private weak var offerViewbottomConstraint    : NSLayoutConstraint!
    @IBOutlet private weak var offerTitleLabel              : UILabel!
    @IBOutlet private weak var offerCollectionView          : UICollectionView!
    @IBOutlet private weak var headerLogoImageView          : UIImageView!
    @IBOutlet private weak var bannerCollectionView         : UICollectionView!
    @IBOutlet private weak var bannerPageControl            : UIPageControl!
    @IBOutlet private weak var segmentCollectionView        : UICollectionView!
    @IBOutlet private weak var subcategoryCollectionView    : UICollectionView!
    @IBOutlet         weak var pageFrameView                : UIView! {
        willSet {
            self.addChild(self.pageMaster)
            newValue.addSubview(self.pageMaster.view)
            newValue.fitToSelf(childView: self.pageMaster.view)
            self.pageMaster.didMove(toParent: self)
        }
    }
    @IBOutlet private weak var progressActivityIndicator    : UIActivityIndicatorView!
    
    //MARK: - Variable -
    private var tabSegmentArray     : [TabSegmentModel] = []
    private var homeProduct         : HomeProduct?
    var isProductDetailPagePushed   : Bool = false
    private let pageMaster          = PageMaster([])
    private var viewControllerList  : [UIViewController] = []
    private var offerProduct        : Product?
    
    private var bannerArray         : [Banner] = []
    private var categoryListArray   : [CategoryListModel] = []
    private var featureListArray    : [CategoryListModel] = []
    private var bannerImageTimer    = Timer()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tabSegmentArray.count > 0 {
            let filterData = tabSegmentArray.filter( { $0.isSelected == true } )
            if filterData.count > 0 {
                if isProductDetailPagePushed == false {
                    productTabsDataAPICall(tabSegment: filterData[0])
                } else {
                    isProductDetailPagePushed = false
                    if let index = tabSegmentArray.firstIndex(of: filterData[0]) {
                        if let homeContentViewController = viewControllerList[index] as? HomeContentViewController {
                            homeContentViewController.collectionViewReloadData()
                        }
                    }
                }
            }
        } else {
            productTabsAPICall()
        }
        
        setSelectedFeaturedList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        offerView(isShow: false)
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        ///API Call
        self.headerLogoImageView.sd_setImage(with: SettingList.header_logo, placeholderImage: UIImage())
        SUtill.settingListAPICall { [weak self] () in
            guard let `self` = self else { return }
            self.topView.backgroundColor         = SettingList.header_color
            self.navigationView.backgroundColor  = SettingList.header_color
            self.segmentCollectionView.reloadData()
            self.headerLogoImageView.sd_setImage(with: SettingList.header_logo, placeholderImage: UIImage())
        }
        
        ///Page Master
        setupPageViewController()
        
        ///API Call
        cartListAPICall()
        homeListAPICall()
    }
    
    //MARK: - Action Methods
    @IBAction private func didTapOnButtonCloseOfferView(_ sender: Any) {
        offerView(isShow: false)
    }
    
    @IBAction private func didTapOnButtonBarcodeScanner(_ sender: Any) {
        if let barcodeScanViewController = UIStoryboard.Home.get(BarcodeScanViewController.self) {
            self.navigationController?.pushViewController(barcodeScanViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnButtonNotification(_ sender: Any) {
        if let notificationListViewController = UIStoryboard.Home.get(NotificationListViewController.self) {
            self.navigationController?.pushViewController(notificationListViewController, animated: true)
        }
    }
    @IBAction private func didChangeValueOfPageControlBanner(_ sender: UIPageControl) {
        bannerCollectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0),
                                          at: .centeredHorizontally,
                                          animated: true)
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
extension HomeViewController {
   
    private func animationProductImage(animationView : UIView)  {
        self.view.addSubview(animationView)
        UIView.animate(withDuration: 2, animations: { animationView.animationZoom(scaleX: 1, y: 1) }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                animationView.animationZoom(scaleX: 0.2, y: 0.2)
                animationView.animationRoted(angle: CGFloat(Double.pi))
                if let seyyarTabbarViewController = self.parent?.parent as? SeyyarTabbarViewController {
                    animationView.frame.origin.x = seyyarTabbarViewController.cartButton.frame.origin.x + (seyyarTabbarViewController.cartButton.frame.size.width / 2)
                    animationView.frame.origin.y = seyyarTabbarViewController.pageFrameView.frame.size.height + 20
                }
            }, completion: { _ in
                animationView.removeFromSuperview()
                UIView.animate(withDuration: 1.0, animations: {
                    if let seyyarTabbarViewController = self.parent?.parent as? SeyyarTabbarViewController {
                        seyyarTabbarViewController.cartButton.animationZoom(scaleX: 1.4, y: 1.4)
                    }
                }, completion: {_ in
                    if let seyyarTabbarViewController = self.parent?.parent as? SeyyarTabbarViewController {
                        seyyarTabbarViewController.cartButton.animationZoom(scaleX: 1.0, y: 1.0)
                    }
                })
            })
        })
    }
    
    func productImage(imageView : UIImageView) {
        let imageViewPosition : CGPoint = imageView.convert(imageView.bounds.origin, to: self.view)
        let imgViewTemp     = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: imageView.frame.size.width, height: imageView.frame.size.height))
        imgViewTemp.image   = imageView.image
        animationProductImage(animationView: imgViewTemp)
    }
    
    func startActivityIndicator() {
        progressActivityIndicator.startAnimating()
        progressActivityIndicator.isHidden = false
    }
    
    func stopActivityIndicator() {
        progressActivityIndicator.isHidden = true
    }
    
    private func setBannerView(banners : [Banner]) {
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
    
    func setSelectedFeaturedList() {
        if let selectedFeatureCategory = SelectedFeatureCategory {
            let filterData = categoryListArray.filter( { $0.category_id == selectedFeatureCategory.category_id } )
            if filterData.count > 0, let index = categoryListArray.firstIndex(of: filterData[0]) {
                SelectedFeatureCategory = nil
                _ = categoryListArray.map( { $0.isSelected = false } )
                categoryListArray[index].isSelected = true
                segmentCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                segmentCollectionView.reloadData()
                subcategoryCollectionView.reloadData()
            }
        }
    }
    
}

//MARK: - CollectionView DataSource, Delegate, Flowlayout Delegate -
extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case segmentCollectionView      : return categoryListArray.count
        case bannerCollectionView       : return bannerArray.count
        case offerCollectionView        :
            if let offerProduct = offerProduct, offerProduct.products.count > 0 {
                if offerProduct.products[0].offer_type == "flatcombo" {
                    return offerProduct.products[0].number_of_products
                } else if offerProduct.products[0].offer_type == "plusone" {
                    return offerProduct.products[0].number_of_products + 1
                }
            }
        case subcategoryCollectionView  :
            let filterData = categoryListArray.filter( { $0.isSelected } )
            if categoryListArray.count > 0, filterData.count > 0, let index = categoryListArray.firstIndex(of: filterData[0]) {
                return categoryListArray[index].subcategories.count
            }
        default                         : return 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == segmentCollectionView {
            let cell = collectionView.registerAndGet(cell: HomeSegmentCollectionViewCell.self, indexPath: indexPath)!
            cell.categoryListModel = categoryListArray[indexPath.item]
            return cell
        } else if  collectionView == bannerCollectionView {
            let cell = collectionView.registerAndGet(cell: HomeBannerCollectionViewCell.self, indexPath: indexPath)!
            cell.banner = bannerArray[indexPath.item]
            return cell
        } else if collectionView == subcategoryCollectionView {
            let cell = collectionView.registerAndGet(cell: HomeSubCategoryCollectionViewCell.self, indexPath: indexPath)!
            let filterData = categoryListArray.filter( { $0.isSelected } )
            if categoryListArray.count > 0, filterData.count > 0, let index = categoryListArray.firstIndex(of: filterData[0]) {
                cell.setSubcategories(categoryListArray[index].subcategories[indexPath.item])
            }
            return cell
        } else {
            let cell = collectionView.registerAndGet(cell: HomeOfferCollectionViewCell.self, indexPath: indexPath)!
            cell.isPlusShow = indexPath.item == 0 ? false : true
            cell.productNumber = indexPath.item + 1
            if let offerProduct = offerProduct, offerProduct.products.count > 0, offerProduct.products.count - 1 >= indexPath.item {
                cell.productURL = offerProduct.products[indexPath.item].product_image_small
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == segmentCollectionView {
            let label = UILabel()
            switch appLanguage {
            case .Arabic    : label.text = categoryListArray[indexPath.item].cat_name_ar
            case .Dutch     : label.text = categoryListArray[indexPath.item].cat_name_de
            case .English   : label.text = categoryListArray[indexPath.item].cat_name_en
            case .Swedish   : label.text = categoryListArray[indexPath.item].cat_name_nl
            case .Turkish   : label.text = categoryListArray[indexPath.item].cat_name_tr
            }
            label.font = UIFont.Tejawal.Medium(15)
            label.sizeToFit()
            return CGSize(width: label.getLabelWidth() + 30, height: collectionView.frame.size.height)
        } else if collectionView == bannerCollectionView {
            return CGSize(width: ScreenWidth, height: collectionView.frame.size.height)
        } else if collectionView == subcategoryCollectionView {
            let width = (ScreenWidth - 40 - 60) / 4
            return CGSize(width: width, height: width * 1.25)
        } else {
            if indexPath.item == 0 {
                return CGSize(width: 90, height: 65)
            } else {
                return CGSize(width: 110, height: 65)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case segmentCollectionView      :
            _ = categoryListArray.map( { $0.isSelected = false } )
            categoryListArray[indexPath.item].isSelected = true
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
            subcategoryCollectionView.reloadData()
        case subcategoryCollectionView  :
            let searchDetailProductViewController = UIStoryboard.Search.get(SearchDetailProductViewController.self)!
            let filterData = categoryListArray.filter( { $0.isSelected } )
            if categoryListArray.count > 0, filterData.count > 0, let index = categoryListArray.firstIndex(of: filterData[0]) {
                searchDetailProductViewController.subcategoriesArray    = categoryListArray[index].subcategories
                searchDetailProductViewController.subcategories         = categoryListArray[index].subcategories[indexPath.item]
            }
            self.navigationController?.pushViewController(searchDetailProductViewController, animated: true)
        default                         : break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == bannerCollectionView) {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            bannerPageControl.currentPage = index
        }
    }
    
}

//MARK: - API Call -
extension HomeViewController {
    
    private func productTabsAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0
                    ] as [String : Any]
        startActivityIndicator()
        APIManager.shared.callRequestWithMultipartData(APIRouter.productTabs(param), arrImages: [], onSuccess: { (response) in
            self.stopActivityIndicator()
            if let data = response.data, response.success {
                self.tabSegmentArray.removeAll()
                for obejct in data.arrayValue {
                    self.tabSegmentArray.append(TabSegmentModel.init(aDict: obejct))
                    self.viewControllerList.append(UIStoryboard.Home.get(HomeContentViewController.self)!)
                }
                self.setupPageViewController()
                if self.tabSegmentArray.count > 0 {
                    self.tabSegmentArray[0].isSelected = true
                    self.productTabsDataAPICall(tabSegment: self.tabSegmentArray[0])
                }
                self.segmentCollectionView.reloadData()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.stopActivityIndicator()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func productTabsDataAPICall(tabSegment : TabSegmentModel) {
        guard let user = AppUser else {return}
        offerView(isShow: false)
        if let index = self.tabSegmentArray.firstIndex(of: tabSegment) {
            pageMaster.setPage(index, animated: true)
            let param = [
                            SText.Parameter.user_id : user.user_id ?? 0,
                            SText.Parameter.tab_ref : tabSegment.tag_ref
                        ] as [String : Any]
            startActivityIndicator()
            APIManager.shared.callRequestWithMultipartData(APIRouter.productTabsData(param), arrImages: [], onSuccess: { (response) in
                self.stopActivityIndicator()
                if let data = response.data, response.success {
                    self.homeProduct = HomeProduct.init(aDict: data)
                    if let homeContentViewController = self.viewControllerList[index] as? HomeContentViewController {
                        homeContentViewController.homeProduct = HomeProduct.init(aDict: data)
                        homeContentViewController.collectionViewReloadData()
                    }
                } else {
                    self.showAlert(withMessage: response.message ?? "")
                }
            }, onFailure: { (apiErrorResponse) in
                self.stopActivityIndicator()
                self.showAlert(withMessage: apiErrorResponse.message)
            })
        }
    }
    
    private func cartListAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0
                    ] as [String : Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.cartList(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            if let data = response.data, response.success {
                if let seyyarTabbarViewController = self.parent?.parent as? SeyyarTabbarViewController {
                    let amount = data["total_amount"].doubleValue - (data["total_amount"].doubleValue - data["net_paid_amount"].doubleValue)
                    seyyarTabbarViewController.setCartAmountLabel(amount: amount)
                }
            }
        }, onFailure: { (apiErrorResponse) in
        })
    }
    
    private func homeListAPICall() {
        let param = [:] as [String : Any]
        startActivityIndicator()
        APIManager.shared.callRequestWithMultipartData(APIRouter.homeList(param), arrImages: [], onSuccess: { (response) in
            self.stopActivityIndicator()
            if let data = response.data, response.success {
                print(data)
                self.bannerArray.removeAll()
                self.categoryListArray.removeAll()
                self.featureListArray.removeAll()
                for object in data["banners"].arrayValue {
                    self.bannerArray.append(Banner(aDict: object))
                }
                for object in data["categories"].arrayValue {
                    self.categoryListArray.append(CategoryListModel(aDict: object))
                }
                for object in data["is_featured"].arrayValue {
                    self.featureListArray.append(CategoryListModel(aDict: object))
                }
                FeatureListArray = self.featureListArray
                if self.categoryListArray.count > 0 {
                    self.categoryListArray[0].isSelected = true
                    self.segmentCollectionView.reloadData()
                    self.segmentCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                }
                self.setBannerView(banners: self.bannerArray)
                self.bannerPageControl.numberOfPages    = self.bannerArray.count
                self.bannerPageControl.isHidden         = self.bannerArray.count == 0
                self.bannerCollectionView.reloadData()
                self.offerCollectionView.reloadData()
                self.segmentCollectionView.reloadData()
                self.subcategoryCollectionView.reloadData()
                self.setSelectedFeaturedList()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.stopActivityIndicator()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Offer View -
extension HomeViewController {
    
    func offerView(isShow : Bool) {
        if isShow == true && offerViewbottomConstraint.constant == 0 {
            offerViewbottomConstraint.constant = -(SafeAreaTop + 140)
        } else if isShow == false && offerViewbottomConstraint.constant == -(SafeAreaTop + 140) {
            offerViewbottomConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.5) { [weak self] () in
            guard let `self` = self else {return}
            self.view.layoutIfNeeded()
        }
    }
    
    func offerProductCountManage(product : Product) {
        offerProduct = product
        offerCollectionView.reloadData()
        
        if product.products.count > 0 {
            if product.products[0].offer_type == "flatcombo" {
                offerTitleLabel.text = "\(product.products[0].number_of_products ?? 0) voor \(SettingList.currency_symbol ?? "") \(product.products[0].offer_discount ?? 0)"
            } else if product.products[0].offer_type == "plusone" {
                offerTitleLabel.text = "\(product.products[0].number_of_products ?? 0) + 1 gratis"
            }
        }
        offerCollectionView.scrollToItem(at: IndexPath(item: product.products.count - 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}

// MARK: - Page Master Delegate
extension HomeViewController: PageMasterDelegate {
    
    private func setupPageViewController() {
        self.pageMaster.pageDelegate = self
        self.pageMaster.setup(self.viewControllerList)
    }
    
    func pageMaster(_ master: PageMaster, didChangePage page: Int) {
        _ = tabSegmentArray.map( { $0.isSelected = false } )
        tabSegmentArray[page].isSelected = true
        segmentCollectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
        productTabsDataAPICall(tabSegment: tabSegmentArray[page])
        segmentCollectionView.reloadData()
    }
    
}
