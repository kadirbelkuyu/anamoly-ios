//
//  NotificationListTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 16/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {

    @IBOutlet private weak var notificationTitleLabel   : UILabel!
    @IBOutlet private weak var notificationDetailLabel  : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var notificationListModel : NotificationListModel! {
        didSet {
            switch appLanguage {
            case .Arabic    :
                notificationTitleLabel.text     = notificationListModel.title_ar
                notificationDetailLabel.text    = notificationListModel.message_ar
            case .Dutch     :
                notificationTitleLabel.text     = notificationListModel.title_nl
                notificationDetailLabel.text    = notificationListModel.message_nl
            case .English   :
                notificationTitleLabel.text     = notificationListModel.title_en
                notificationDetailLabel.text    = notificationListModel.message_en
            case .Swedish   :
                notificationTitleLabel.text     = notificationListModel.title_de
                notificationDetailLabel.text    = notificationListModel.message_de
            case .Turkish   :
                notificationTitleLabel.text     = notificationListModel.title_tr
                notificationDetailLabel.text    = notificationListModel.message_tr
            }
        }
    }
    
}
