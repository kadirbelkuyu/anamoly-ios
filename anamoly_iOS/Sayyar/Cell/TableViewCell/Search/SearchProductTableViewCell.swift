//
//  SearchProductTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SearchProductTableViewCell: UITableViewCell {

    @IBOutlet private weak var categoryImageView    : UIImageView!
    @IBOutlet private weak var categoryNameLabel    : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var categoryListModel : CategoryListModel! {
        didSet {
            if categoryListModel.cat_image_small != nil {
                categoryImageView.sd_setImage(with: categoryListModel.cat_image_small, placeholderImage: Product_Placeholder)
            } else {
                categoryImageView.image = Product_Placeholder
            }
            switch appLanguage {
            case .Arabic    : categoryNameLabel.text = categoryListModel.cat_name_ar
            case .Dutch     : categoryNameLabel.text = categoryListModel.cat_name_nl
            case .English   : categoryNameLabel.text = categoryListModel.cat_name_en
            case .Swedish   : categoryNameLabel.text = categoryListModel.cat_name_de
            case .Turkish   : categoryNameLabel.text = categoryListModel.cat_name_tr
            }
        }
    }
    
    var subcategories : Subcategories! {
        didSet {
            if subcategories.sub_cat_image != nil {
                categoryImageView.sd_setImage(with: subcategories.sub_cat_image, placeholderImage: Product_Placeholder)
            } else {
                categoryImageView.image = Product_Placeholder
            }
            switch appLanguage {
            case .Arabic    : categoryNameLabel.text = subcategories.sub_cat_name_ar
            case .Dutch     : categoryNameLabel.text = subcategories.sub_cat_name_nl
            case .English   : categoryNameLabel.text = subcategories.sub_cat_name_en
            case .Swedish   : categoryNameLabel.text = subcategories.sub_cat_name_de
            case .Turkish   : categoryNameLabel.text = subcategories.sub_cat_name_tr
            }
        }
    }
    
}
