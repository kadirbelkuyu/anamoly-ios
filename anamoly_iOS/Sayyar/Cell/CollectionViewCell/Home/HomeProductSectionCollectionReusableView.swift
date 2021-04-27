//
//  HomeProductSectionCollectionReusableView.swift
//  Sayyar
//
//  Created by Atri Patel on 09/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeProductSectionCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var homeProductTitleLabel        : UILabel!
    @IBOutlet private weak var moreButton                   : UIButton!
    @IBOutlet private weak var moreButtonWidthConstraint    : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moreButton.setTitle(NSLocalizedString("More", comment: "More"), for: .normal)
        moreButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    var homeProduct : Product! {
        didSet {
            switch appLanguage {
            case .Arabic    : homeProductTitleLabel.text = homeProduct.sub_cat_name_ar
            case .Dutch     : homeProductTitleLabel.text = homeProduct.sub_cat_name_nl
            case .English   : homeProductTitleLabel.text = homeProduct.sub_cat_name_en
            case .Swedish   : homeProductTitleLabel.text = homeProduct.sub_cat_name_de
            case .Turkish   : homeProductTitleLabel.text = homeProduct.sub_cat_name_tr
            }
        }
    }
    
    var searchProduct : Product! {
        didSet {
            switch appLanguage {
            case .Arabic    : homeProductTitleLabel.text = searchProduct.group_name_ar
            case .Dutch     : homeProductTitleLabel.text = searchProduct.group_name_nl
            case .English   : homeProductTitleLabel.text = searchProduct.group_name_en
            case .Swedish   : homeProductTitleLabel.text = searchProduct.group_name_de
            case .Turkish   : homeProductTitleLabel.text = searchProduct.group_name_tr
            }
        }
    }
    
    var isMoreButtonHide : Bool! {
        didSet {
            moreButtonWidthConstraint.constant = isMoreButtonHide ? 0 : 120
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonMore(_ sender : UIButton) {
    }
    
    @IBAction private func didTapOnbuttonSection(_ sender: Any) {
        if isMoreButtonHide ==  false {
            if homeProduct != nil {
                let homeCategoryDetailViewController = UIStoryboard.Home.get(HomeCategoryDetailViewController.self)!
                homeCategoryDetailViewController.productObject = homeProduct
                self.viewContainingController()?.navigationController?.pushViewController(homeCategoryDetailViewController, animated: true)
            } else if searchProduct != nil {
                let homeCategoryDetailViewController = UIStoryboard.Home.get(HomeCategoryDetailViewController.self)!
                homeCategoryDetailViewController.productObject = searchProduct
                self.viewContainingController()?.navigationController?.pushViewController(homeCategoryDetailViewController, animated: true)
            }
        }
    }
    
}
