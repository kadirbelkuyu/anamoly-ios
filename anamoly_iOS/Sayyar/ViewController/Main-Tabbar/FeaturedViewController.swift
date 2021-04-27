//
//  FeaturedViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 30/03/21.
//  Copyright © 2021 Atri Patel. All rights reserved.
//

import UIKit

class FeaturedViewController: BaseViewController {

    @IBOutlet private weak var featuredCollectionView: UICollectionView!
    
    var updatedBlock : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        
        let filterData = FeatureListArray.filter( { $0.isSelected } )
        if filterData.count == 0, FeatureListArray.count > 0 {
            FeatureListArray[0].isSelected = true
        } else if FeatureListArray.count > 0 {
            if let index = FeatureListArray.firstIndex(of: filterData[0]) {
                featuredCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - CollectionView DataSource, Delegate, Flowlayout Delegate -
extension FeaturedViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeatureListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.registerAndGet(cell: HomeSegmentCollectionViewCell.self, indexPath: indexPath)!
        cell.categoryListModel = FeatureListArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = FeatureListArray[indexPath.item].cat_name_en
        label.font = UIFont.Tejawal.Medium(15)
        label.sizeToFit()
        return CGSize(width: label.getLabelWidth() + 50, height: collectionView.frame.size.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = FeatureListArray.map( { $0.isSelected = false } )
        FeatureListArray[indexPath.item].isSelected = true
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        SelectedFeatureCategory = FeatureListArray[indexPath.item]
        updatedBlock?()
        self.dismiss(animated: true, completion: nil)
    }
    
}
