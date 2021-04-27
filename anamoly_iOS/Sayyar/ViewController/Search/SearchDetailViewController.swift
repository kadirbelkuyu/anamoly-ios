//
//  SearchDetailViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 20/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SearchDetailViewController: BaseViewController {

    @IBOutlet private weak var searchDetailNavigationTitleLabel : UILabel!
    @IBOutlet private weak var searchDetailTableView            : UITableView!
    @IBOutlet private weak var cartAmountLabel                  : UILabel!
    
    var categoryListModel : CategoryListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.parent as? UINavigationController {
            if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                cartAmountLabel.attributedText = SUtill.getSuperAttributedScriptForPrice(price: " " + seyyarTabbarViewController.cartAmount.twoDigitsString, fontSize: 15)
            }
        }
    }
    
    private func prepareView() {
        if let categoryObject = categoryListModel {
            switch appLanguage {
            case .Arabic    : searchDetailNavigationTitleLabel.text = categoryObject.cat_name_ar
            case .Dutch     : searchDetailNavigationTitleLabel.text = categoryObject.cat_name_nl
            case .English   : searchDetailNavigationTitleLabel.text = categoryObject.cat_name_en
            case .Swedish   : searchDetailNavigationTitleLabel.text = categoryObject.cat_name_de
            case .Turkish   : searchDetailNavigationTitleLabel.text = categoryObject.cat_name_tr
            }
            searchDetailTableView.reloadData()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonBarcodeScanner(_ sender: Any) {
        if let barcodeScanViewController = UIStoryboard.Home.get(BarcodeScanViewController.self) {
            self.navigationController?.pushViewController(barcodeScanViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnButtonTabbar(_ sender : UIButton) {
        if let navigationController = self.parent as? UINavigationController {
            if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                navigationController.popToRootViewController(animated: true)
                switch sender.tag {
                case 0  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.homeButton)
                case 1  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.searchButton)
                case 2  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.cartButton)
                case 3  : seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.profileButton)
                default : break
                }
            }
        }
    }
    
    @IBAction private func didTapOnButtonFeatureList(_ sender: Any) {
        if let featuredViewController = UIStoryboard.Main.get(FeaturedViewController.self) {
            featuredViewController.modalTransitionStyle = .crossDissolve
            featuredViewController.modalPresentationStyle = .overFullScreen
            featuredViewController.updatedBlock = { [weak self] () in
                guard let `self` = self else { return }
                if let navigationController = self.parent as? UINavigationController {
                    if navigationController.viewControllers.count > 0, let seyyarTabbarViewController = navigationController.viewControllers.first as? SeyyarTabbarViewController {
                        navigationController.popToRootViewController(animated: true)
                        seyyarTabbarViewController.setTabbarButton(sender: seyyarTabbarViewController.homeButton)
                    }
                }
            }
            self.present(featuredViewController, animated: true, completion: nil)
        }
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

//MARK: - TableView DataSource, Delegate -
extension SearchDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListModel != nil ? categoryListModel?.subcategories.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: SearchProductTableViewCell.self)! as SearchProductTableViewCell
        cell.subcategories = categoryListModel?.subcategories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDetailProductViewController = UIStoryboard.Search.get(SearchDetailProductViewController.self)!
        searchDetailProductViewController.subcategoriesArray    = categoryListModel?.subcategories ?? []
        searchDetailProductViewController.subcategories         = categoryListModel?.subcategories[indexPath.row]
        self.navigationController?.pushViewController(searchDetailProductViewController, animated: true)
    }
    
}
