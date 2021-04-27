//
//  HomeSituationCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 05/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeSituationCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var homeSituationImageView : UIImageView!
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var homeSituationImage : UIImage! {
        didSet {
            homeSituationImageView.image = homeSituationImage
        }
    }
    
    var images : Images! {
        didSet {
            if images.product_image != nil {
                homeSituationImageView.sd_setImage(with: images.product_image, placeholderImage: Product_Placeholder)
            } else {
                homeSituationImageView.image = Product_Placeholder
            }
        }
    }
    
    var productImage : URL! {
        didSet {
            if productImage != nil {
                homeSituationImageView.sd_setImage(with: productImage, placeholderImage: Product_Placeholder)
            } else {
                homeSituationImageView.image = Product_Placeholder
            }
        }
    }

}
