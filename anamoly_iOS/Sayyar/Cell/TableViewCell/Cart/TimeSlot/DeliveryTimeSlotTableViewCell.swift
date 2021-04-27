//
//  DeliveryTimeSlotTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class DeliveryTimeSlotTableViewCell: UITableViewCell {

    @IBOutlet private weak var backgroundColorView  : UIView!
    @IBOutlet private weak var dayLabel             : UILabel!
    @IBOutlet private weak var dateLabel            : UILabel!
    @IBOutlet private weak var timeSlotLabel        : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var deliveryTimeSlot : DeliveryTimeSlot! {
        didSet {
//            if appLanguage == .Dutch {
                if let date = DateApp.date(fromString: deliveryTimeSlot.date, withFormat: .activityServerDate, identifier: appLanguage.language) {
                    dayLabel.text   = DateApp.string(fromDate: date, withFormat: .weekDay, identifier: appLanguage.language)
                    dateLabel.text  = DateApp.string(fromDate: date, withFormat: .dayMonth, identifier: appLanguage.language)
                }
                if let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime, identifier: appLanguage.language), let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime, identifier: appLanguage.language) {
                    timeSlotLabel.text = DateApp.string(fromDate: fromDate, withFormat: .time, identifier: appLanguage.language) + " - " + DateApp.string(fromDate: toDate, withFormat: .time, identifier: appLanguage.language)
                }
//            } else {
//                if let date = DateApp.date(fromString: deliveryTimeSlot.date, withFormat: .activityServerDate) {
//                    dayLabel.text   = DateApp.string(fromDate: date, withFormat: .weekDay)
//                    dateLabel.text  = DateApp.string(fromDate: date, withFormat: .dayMonth)
//                }
//                if let fromDate = DateApp.date(fromString: deliveryTimeSlot.from_time, withFormat: .fullTime), let toDate = DateApp.date(fromString: deliveryTimeSlot.to_time, withFormat: .fullTime) {
//                    timeSlotLabel.text = DateApp.string(fromDate: fromDate, withFormat: .time) + " - " + DateApp.string(fromDate: toDate, withFormat: .time)
//                }
//            }
                    
            backgroundColorView.backgroundColor = deliveryTimeSlot.isSelected ? SettingList.header_color.withAlphaComponent(0.25) : .white
            dayLabel.textColor                  = deliveryTimeSlot.isSelected ? .white : .lightGray
            dateLabel.textColor                 = deliveryTimeSlot.isSelected ? .white : .lightGray
            timeSlotLabel.textColor             = deliveryTimeSlot.isSelected ? .white : .lightGray
        }
    }
    
}
