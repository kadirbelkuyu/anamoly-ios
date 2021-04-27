//
//  HomeBannerCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var bannerImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var banner : Banner! {
        didSet {
            if banner.banner_image != nil {
                bannerImageView.sd_setImage(with: banner.banner_image, placeholderImage: Product_Placeholder)
            } else {
                bannerImageView.image = Product_Placeholder
            }
        }
    }

}
