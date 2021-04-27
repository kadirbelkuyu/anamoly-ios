//
//  HomeSegmentCollectionViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 30/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeSegmentCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var segmentBackgroundView    : UIView!
    @IBOutlet private weak var segmentTitleLabel        : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentBackgroundView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: 0, height: 1), radius: 2, scale: false)
    }
    
    var tabSegmentModel : TabSegmentModel! {
        didSet {
            switch appLanguage {
            case .Arabic    : segmentTitleLabel.text = tabSegmentModel.tag_name_ar
            case .Dutch     : segmentTitleLabel.text = tabSegmentModel.tag_name_nl
            case .English   : segmentTitleLabel.text = tabSegmentModel.tag_name_en
            case .Swedish   : segmentTitleLabel.text = tabSegmentModel.tag_name_de
            case .Turkish   : segmentTitleLabel.text = tabSegmentModel.tag_name_tr
            }
            segmentTitleLabel.font = tabSegmentModel.isSelected ? UIFont.Tejawal.Bold(15) : UIFont.Tejawal.Medium(15)
            segmentTitleLabel.textColor             = tabSegmentModel.isSelected ? SettingList.header_text_color : SettingList.header_color
            segmentBackgroundView.backgroundColor   = tabSegmentModel.isSelected ? SettingList.header_color : SettingList.header_text_color
        }
    }

    var product : Product! {
        didSet {
            switch appLanguage {
            case .Arabic    : segmentTitleLabel.text = product.group_name_ar
            case .Dutch     : segmentTitleLabel.text = product.group_name_nl
            case .English   : segmentTitleLabel.text = product.group_name_en
            case .Swedish   : segmentTitleLabel.text = product.group_name_nl
            case .Turkish   : segmentTitleLabel.text = product.group_name_nl
            }
            segmentTitleLabel.font = product.isSelected ? UIFont.Tejawal.Bold(15) : UIFont.Tejawal.Medium(15)
            segmentTitleLabel.textColor             = product.isSelected ? SettingList.header_color : SettingList.header_text_color
            segmentBackgroundView.backgroundColor   = product.isSelected ? SettingList.header_text_color : SettingList.header_color
            segmentBackgroundView.fixRadius         = segmentBackgroundView.frame.size.height / 2
        }
    }
    
    
    var categoryListModel : CategoryListModel! {
        didSet {
            switch appLanguage {
            case .Arabic    : segmentTitleLabel.text = categoryListModel.cat_name_ar
            case .Dutch     : segmentTitleLabel.text = categoryListModel.cat_name_nl
            case .English   : segmentTitleLabel.text = categoryListModel.cat_name_en
            case .Swedish   : segmentTitleLabel.text = categoryListModel.cat_name_de
            case .Turkish   : segmentTitleLabel.text = categoryListModel.cat_name_tr
            }
            segmentTitleLabel.font = categoryListModel.isSelected ? UIFont.Tejawal.Bold(15) : UIFont.Tejawal.Medium(15)
            segmentTitleLabel.textColor             = categoryListModel.isSelected ? SettingList.header_text_color : SettingList.header_color
            segmentBackgroundView.backgroundColor   = categoryListModel.isSelected ? SettingList.header_color : SettingList.header_text_color
        }
    }
    
}
