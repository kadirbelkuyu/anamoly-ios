//
//  HomeSituationTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 05/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeSituationTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var homeSituationTitleLabel                      : UILabel!
    @IBOutlet         weak var homeSituationCollectionView                  : UICollectionView!
    @IBOutlet private weak var homeSituationCollectionViewHeightConstraint  : NSLayoutConstraint!
    @IBOutlet private weak var homeSituationStepper                         : UIStepper!
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        self.homeSituationCollectionView.dataSource = self
        self.homeSituationCollectionView.delegate = self
    }
    
    var homeSituation : HomeSituation! {
        didSet {
            self.homeSituationTitleLabel.text = (homeSituation.homeSituationCount == 0) ? homeSituation.homeSituationTitle : homeSituation.homeSituationTitle + " - \(homeSituation.homeSituationCount ?? 0)"
            self.homeSituationStepper.value = Double(homeSituation.homeSituationCount)
            
            let familyCount = homeSituation.homeSituationCount ?? 0
            let numberOfCellInRow = Int(homeSituationCollectionView.frame.size.width / 30)
            let cellRowCount = Int(familyCount / numberOfCellInRow) + 1
            homeSituationCollectionViewHeightConstraint.constant = CGFloat(cellRowCount * 30)
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Action Methods
    @IBAction private func didChangeValueOfStepperHomeSituation(_ sender : UIStepper) {
        self.homeSituation.homeSituationCount = Int(sender.value)
        self.homeSituationTitleLabel.text = (homeSituation.homeSituationCount == 0) ? homeSituation.homeSituationTitle : homeSituation.homeSituationTitle + " - \(homeSituation.homeSituationCount ?? 0)"
        self.homeSituationCollectionView.reloadData()
    }
    
}

//MARK: - CollectionView DataSouce, Delegate, FlowLayout
extension HomeSituationTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.homeSituation != nil) {
            return self.homeSituation.homeSituationCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.registerAndGet(cell: HomeSituationCollectionViewCell.self, indexPath: indexPath)!
        cell.homeSituationImage = self.homeSituation.homeSituationImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
}
