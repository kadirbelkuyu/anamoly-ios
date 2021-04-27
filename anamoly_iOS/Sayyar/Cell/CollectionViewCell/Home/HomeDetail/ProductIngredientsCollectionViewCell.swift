//
//  ProductIngredientsCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 24/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class ProductIngredientsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var ingredientBgView : UIView!
    @IBOutlet private weak var ingredientLabel  : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var ingredients : Ingredients! {
        didSet {
            ingredientBgView.borderColor = UIColor.init(hexString: ingredients.ingredient_colour)
            switch appLanguage {
            case .Arabic    : ingredientLabel.text = ingredients.ingredient_name_ar
            case .Dutch     : ingredientLabel.text = ingredients.ingredient_name_nl
            case .English   : ingredientLabel.text = ingredients.ingredient_name_en
            case .Swedish   : ingredientLabel.text = ingredients.ingredient_name_nl
            case .Turkish   : ingredientLabel.text = ingredients.ingredient_name_nl
            }
            ingredientLabel.textColor = UIColor.init(hexString: ingredients.ingredient_colour)
        }
    }

}
