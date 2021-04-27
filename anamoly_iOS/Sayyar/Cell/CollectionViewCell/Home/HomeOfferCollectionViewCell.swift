//
//  HomeOfferCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 21/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeOfferCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var plusImageView        : UIImageView!
    @IBOutlet private weak var productNumberLabel   : UILabel!
    @IBOutlet private weak var productImageView     : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var isPlusShow : Bool! {
        didSet {
            plusImageView.isHidden = isPlusShow ? false : true
            productImageView.image = UIImage()
            productImageView.isHidden = true
        }
    }
    
    var productNumber : Int! {
        didSet {
            productNumberLabel.text = "\(productNumber ?? 0)"
            productImageView.image = UIImage()
            productImageView.isHidden = true
        }
    }
    
    var productURL : URL? {
        didSet {
            productImageView.isHidden = false
            if productURL != nil {
                productImageView.sd_setImage(with: productURL, placeholderImage: Product_Placeholder)
            } else {
                productImageView.image = Product_Placeholder
            }
        }
    }

}
