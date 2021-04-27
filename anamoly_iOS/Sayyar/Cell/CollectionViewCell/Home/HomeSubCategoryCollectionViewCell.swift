//
//  HomeSubCategoryCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 22/03/21.
//  Copyright © 2021 Atri Patel. All rights reserved.
//

import UIKit

class HomeSubCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var shadowView           : UIView!
    @IBOutlet private weak var categoryImageView    : UIImageView!
    @IBOutlet private weak var categoryTitleLabel   : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.dropShadow(color: .darkGray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 2, scale: false)
    }
    
    func setSubcategories(_ subcategories : Subcategories) {
        categoryImageView.sd_setImage(with: subcategories.sub_cat_image, placeholderImage: Product_Placeholder)
        switch appLanguage {
        case .Arabic    : categoryTitleLabel.text = subcategories.sub_cat_name_ar
        case .Dutch     : categoryTitleLabel.text = subcategories.sub_cat_name_nl
        case .English   : categoryTitleLabel.text = subcategories.sub_cat_name_en
        case .Swedish   : categoryTitleLabel.text = subcategories.sub_cat_name_de
        case .Turkish   : categoryTitleLabel.text = subcategories.sub_cat_name_tr
        }
    }

}
