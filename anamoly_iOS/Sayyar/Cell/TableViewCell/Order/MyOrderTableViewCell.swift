//
//  MyOrderTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet private weak var orderTitleLabel  : UILabel!
    @IBOutlet private weak var orderAmountLabel : UILabel!
    @IBOutlet private weak var orderQTYLabel    : UILabel!
    @IBOutlet private weak var orderStatusLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var myOrder : MyOrder! {
        didSet {
//            if appLanguage == .Dutch {
                if let date = DateApp.date(fromString: myOrder.order_date, withFormat: .fixFullDate, identifier: appLanguage.language) {
                    orderTitleLabel.text    = DateApp.string(fromDate: date, withFormat: .myOrderDate, identifier: appLanguage.language)
                }
//            } else {
//                if let date = DateApp.date(fromString: myOrder.order_date, withFormat: .fixFullDate) {
//                    orderTitleLabel.text    = DateApp.string(fromDate: date, withFormat: .myOrderDate)
//                }
//            }
            orderAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: SettingList.currency_symbol + " " + myOrder.order_amount.twoDigitsString, fontSize: 15)
            orderQTYLabel.text              = "\(NSLocalizedString("QTY", comment: "QTY")) : \(myOrder.total_qty ?? 0)"
            orderStatusLabel.text           = NSLocalizedString(myOrder.status.Title, comment: myOrder.status.Title)
            orderStatusLabel.textColor      = myOrder.status.Color
        }
    }
    
}
