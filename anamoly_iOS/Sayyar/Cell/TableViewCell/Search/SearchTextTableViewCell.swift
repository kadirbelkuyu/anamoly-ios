//
//  SearchTextTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 23/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SearchTextTableViewCell: UITableViewCell {

    @IBOutlet private weak var searchTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var searchProductModel : SearchProductModel! {
        didSet {
            let blackString = [NSAttributedString.Key.foregroundColor : SettingList.default_text_color]
            let blueString = [NSAttributedString.Key.foregroundColor : ColorApp.ColorRGB(65,23,116,1)]
            let myAttributedString = NSMutableAttributedString()
            var languageString : String = ""
            switch appLanguage {
            case .Arabic    : languageString = searchProductModel.search_ar
            case .Dutch     : languageString = searchProductModel.search_nl
            case .English   : languageString = searchProductModel.search_en
            case .Swedish   : languageString = searchProductModel.search_de
            case .Turkish   : languageString = searchProductModel.search_tr
            }
            if languageString == "" {
                languageString = searchProductModel.search_nl
            }
            
            for letter in languageString.unicodeScalars {
                let myLetter : NSAttributedString
                let searchCaharcterSet = CharacterSet(charactersIn: searchProductModel.searchText)
                if searchCaharcterSet.contains(letter) {
                    myLetter = NSAttributedString(string: "\(letter)", attributes: blueString)
                } else {
                    myLetter = NSAttributedString(string: "\(letter)", attributes: blackString)
                }
                myAttributedString.append(myLetter)
            }
            searchTextLabel.attributedText = myAttributedString
        }
    }
    
}
