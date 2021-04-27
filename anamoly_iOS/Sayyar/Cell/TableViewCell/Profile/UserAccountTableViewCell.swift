//
//  UserAccountTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class UserAccountTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet private weak var userAccountLabel : UILabel!
    
    //MARK: - Life Cycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var titleName : String! {
        didSet {
            self.userAccountLabel.text = titleName
        }
    }
    
}
