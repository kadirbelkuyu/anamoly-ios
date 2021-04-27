//
//  HomeSegmentBarCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 25/03/21.
//  Copyright © 2021 Atri Patel. All rights reserved.
//

import UIKit

class HomeSegmentBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var segmentTitleLabel    : UILabel!
    @IBOutlet private weak var selectedView         : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSubcategories(_ subcategories : Subcategories) {
        switch appLanguage {
                    case .Arabic    : segmentTitleLabel.text  = subcategories.sub_cat_name_ar
                    case .Dutch     : segmentTitleLabel.text  = subcategories.sub_cat_name_nl
                    case .English   : segmentTitleLabel.text  = subcategories.sub_cat_name_en
                    case .Swedish   : segmentTitleLabel.text  = subcategories.sub_cat_name_de
                    case .Turkish   : segmentTitleLabel.text  = subcategories.sub_cat_name_tr
                    }
        selectedView.isHidden   = !subcategories.isSelected
    }

}
