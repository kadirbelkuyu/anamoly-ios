//
//  HomeNewCategoryViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 25/03/21.
//  Copyright © 2021 Atri Patel. All rights reserved.
//

import UIKit

class HomeNewCategoryViewController: BaseViewController {

    @IBOutlet private weak var navigationTitleLabel         : UILabel!
    @IBOutlet private weak var categoryCollectionView       : UICollectionView!
    @IBOutlet private weak var subcategoryCollectionView    : UICollectionView!
    @IBOutlet private weak var productCollectionView        : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        ///Cell Register
        productCollectionView.register(UINib(nibName: String(describing: HomeProductSectionCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HomeProductSectionCollectionReusableView.self))
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
    }
    
    @IBAction private func didTapOnButtonBarcode(_ sender: Any) {
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

//MARK: - CollectionView DataSource, Delegate, Delegate FlowLayout -
extension HomeNewCategoryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    ///Section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case categoryCollectionView     : return 1
        case subcategoryCollectionView  : return 1
        case productCollectionView      : return 1
        default                         : return 0
        }
    }
    
    ///Cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView     : return 10
        case subcategoryCollectionView  : return 10
        case productCollectionView      : return 10
        default                         : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView     :
            let cell = collectionView.registerAndGet(cell: HomeSegmentBarCollectionViewCell.self, indexPath: indexPath)!
            return cell
        case subcategoryCollectionView  :
            let cell = collectionView.registerAndGet(cell: HomeSegmentCollectionViewCell.self, indexPath: indexPath)!
            return cell
        case productCollectionView      :
            let cell = collectionView.registerAndGet(cell: HomeProductCollectionViewCell.self, indexPath: indexPath)!
            return cell
        default                         : return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCollectionView     : return CGSize(width: 100, height: collectionView.frame.size.height)
        case subcategoryCollectionView  : return CGSize(width: 100, height: collectionView.frame.size.height)
        case productCollectionView      :
            let cellWidth = (collectionView.frame.size.width - 30) / 2
            return CGSize(width: cellWidth, height: cellWidth * 1.20)
        default                         : return CGSize(width: 0, height: 0)
        }
    }
    
    //Reuseable Cell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == productCollectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing : HomeProductSectionCollectionReusableView.self), for: indexPath) as! HomeProductSectionCollectionReusableView
//                if productArray.count > 0 {
//                    headerView.searchProduct = productArray[indexPath.section]
//                }
                headerView.isMoreButtonHide = true
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
        }
        assert(false, "Unexpected element kind")
        return UICollectionReusableView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == productCollectionView, productArray.count > 0 {
//            return CGSize(width: collectionView.frame.width, height: 60)
//        }
        return CGSize(width: 0, height: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productCollectionView && productCollectionView.indexPathsForVisibleItems.count > 0 {
            var indexPath = IndexPath(item: 0, section: 0)
            indexPath = productCollectionView.indexPathsForVisibleItems.sorted(by: { $0 < $1 } )[0]
//            _ = productArray.map( { $0.isSelected = false } )
//            productArray[indexPath.section].isSelected = true
            productCollectionView.reloadData()
            productCollectionView.scrollToItem(at: IndexPath(item: indexPath.section, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
}
