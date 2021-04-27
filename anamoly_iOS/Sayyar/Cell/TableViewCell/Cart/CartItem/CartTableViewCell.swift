//
//  CartTableViewCell.swift
//  Sayyar
//
//  Created by Atri Patel on 21/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet private weak var cartTableView : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var product : Product! {
        didSet {
            cartTableView.dataSource = self
            cartTableView.delegate = self
            cartTableView.reloadData()
        }
    }
    
}

extension CartTableViewCell : UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if product != nil {
            return product.products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: CartProductTableViewCell.self)!
        cell.products = product.products[indexPath.row]
        if indexPath.row == product.products.count - 1 {
            cell.effectedPrice = product.effected_price
        }
        return cell
    }
    
}
