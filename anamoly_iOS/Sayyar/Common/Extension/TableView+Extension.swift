//
//  TableView+Extension.swift
//  Imperfecto
//
//  Created by PCQ184 on 08/11/19.
//  Copyright © 2019 PCQ184. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerAndGet<T:UITableViewCell>(cell identifier:T.Type) -> T?{
        let cellID = String(describing: identifier)
        
        if let cell = self.dequeueReusableCell(withIdentifier: cellID) as? T {
            return cell
        } else {
            //regiser
            self.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
            return self.dequeueReusableCell(withIdentifier: cellID) as? T
            
        }
    }
    
    func register<T:UITableViewCell>(cell identifier:T.Type) {
        let cellID = String(describing: identifier)
        self.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func getCell<T:UITableViewCell>(identifier:T.Type) -> T?{
        let cellID = String(describing: identifier)
        guard let cell = self.dequeueReusableCell(withIdentifier: cellID) as? T else {
            print("cell not exist")
            return nil
        }
        return cell
    }
    
    //Top -> Bottom
    func reloadWithTopToBottomAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -(tableViewHeight + 50))
        }
        for cell in cells {
            UIView.animate(withDuration: 3, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
                cell.transform = CGAffineTransform.identity
                
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    //Bottom -> Top
    func reloadWithBottomToTopAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    //Right -> Left
    func reloadWithAnimationRightToLeft() {
        self.reloadData()
        let tableViewWidth = self.bounds.size.width
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewWidth, y: 0)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
    
    func updateFooterViewHeight() {
        if let footer = self.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            footer.frame.size.height = newSize.height
        }
    }
    
}
