//
//  CollectionView+Extension.swift
//  Imperfecto
//
//  Created by Atri Patel on 17/12/19.
//  Copyright © 2019 PCQ184. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func registerAndGet<T:UICollectionViewCell>(cell identifier:T.Type, indexPath : IndexPath) -> T?{
        let cellID = String(describing: identifier)
        self.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? T else {
            print("cell not exist")
            return nil
        }
        return cell
    }
    
    func register<T:UICollectionViewCell>(cell identifier:T.Type) {
        let cellID = String(describing: identifier)
        self.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    func getCell<T:UICollectionViewCell>(identifier:T.Type, indexPath : IndexPath) -> T?{
        let cellID = String(describing: identifier)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? T else {
            print("cell not exist")
            return nil
        }
        return cell
    }
    
    func reloadDataWithAnimation() {
        let range = Range(uncheckedBounds: (0, self.numberOfSections))
        let indexSet = IndexSet(integersIn: range)
        self.reloadSections(indexSet)
    }
    
    func reloadDataWithTransitionAnimation() {
        let transition = CATransition()
        transition.startProgress = 0.0
        transition.endProgress = 1.0
        transition.type = .push
        transition.subtype = .fromRight //leftSide ? kCATransitionFromRight : kCATransitionFromLeft
        transition.duration = 1
        self.layer.add(transition, forKey: nil)
    }
    
}
