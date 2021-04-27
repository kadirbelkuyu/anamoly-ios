//
//  SeyyarTabbarViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SeyyarTabbarViewController: BaseViewController {

    @IBOutlet         weak var homeButton       : UIButton!
    @IBOutlet         weak var searchButton     : UIButton!
    @IBOutlet         weak var cartButton       : UIButton!
    @IBOutlet         weak var profileButton    : UIButton!
    @IBOutlet private weak var featureView      : UIView!
    @IBOutlet private weak var featureButton    : UIButton!
    @IBOutlet private weak var cartAmountLabel  : UILabel!
    @IBOutlet         weak var pageFrameView    : UIView! {
        willSet {
            self.addChild(self.pageMaster)
            newValue.addSubview(self.pageMaster.view)
            newValue.fitToSelf(childView: self.pageMaster.view)
            self.pageMaster.didMove(toParent: self)
        }
    }
    
    private let pageMaster          = PageMaster([])
    private let viewControllerList  : [UIViewController] = [
                                            UIStoryboard.Home.get(HomeViewController.self)!,
                                            UIStoryboard.Search.get(SearchViewController.self)!,
                                            UIStoryboard.Cart.get(CartViewController.self)!,
                                            UIStoryboard.Profile.get(ProfileViewController.self)!,
                                        ]
    var cartAmount                  : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Private View -
    private func prepareView() {
        self.setupPageViewController()
        
        cartAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: " 0.00", fontSize: 15)
        
        featureView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 2, scale: false)
    }
    
    func setCartAmountLabel(amount : Double) {
        cartAmount = amount
        cartAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: " " + amount.twoDigitsString, fontSize: 15)
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonTabbar(_ sender : UIButton) {
        setTabbarButton(sender: sender)
    }
    
    @IBAction private func didTapOnButtonFeature(_ sender: Any) {
        if let featuredViewController = UIStoryboard.Main.get(FeaturedViewController.self) {
            featuredViewController.modalTransitionStyle = .crossDissolve
            featuredViewController.modalPresentationStyle = .overFullScreen
            featuredViewController.updatedBlock = { [weak self] () in
                guard let `self` = self else { return }
                self.setTabbarButton(sender: self.homeButton)
                if let homeViewController = self.viewControllerList[0] as? HomeViewController {
                    homeViewController.setSelectedFeaturedList()
                }
            }
            self.present(featuredViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Methods -
    func setTabbarButton(sender : UIButton) {
        homeButton.isSelected       = false
        searchButton.isSelected     = false
        cartButton.isSelected       = false
        profileButton.isSelected    = false
        sender.isSelected           = true
        self.pageMaster.setPage(sender.tag, animated: true)
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

// MARK: - Page Master Delegate -
extension SeyyarTabbarViewController: PageMasterDelegate {
    
    private func setupPageViewController() {
        pageMaster.isPagingEnabled = false
        pageMaster.pageDelegate = self
        pageMaster.setup(self.viewControllerList)
    }
    
    func pageMaster(_ master: PageMaster, didChangePage page: Int) {
        switch page {
        case 0:
            setTabbarButton(sender: homeButton)
        case 1:
            setTabbarButton(sender: searchButton)
        case 2:
            setTabbarButton(sender: cartButton)
        case 3:
            setTabbarButton(sender: profileButton)
        default:
            break
        }
    }
    
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
