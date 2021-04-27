//
//  MyOrdersViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class MyOrdersViewController: BaseViewController {

    @IBOutlet private weak var navigationTitleLabel : UILabel!
    @IBOutlet private weak var myOrderListTableView : UITableView!
    
    private var myOrderArray : [MyOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        orderListAPICall()
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }

    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

//MARK: - TableView DataSouce, Delegate
extension MyOrdersViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: MyOrderTableViewCell.self)!
        cell.myOrder = myOrderArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myOrderDetailViewController = UIStoryboard.Order.get(MyOrderDetailViewController.self)!
        myOrderDetailViewController.myOrder = myOrderArray[indexPath.row]
        self.navigationController?.pushViewController(myOrderDetailViewController, animated: true)
    }
    
}

//MARK: - API Call -
extension MyOrdersViewController {
    
    private func orderListAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id : user.user_id ?? 0
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.orderList(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                for object in data.arrayValue {
                    self.myOrderArray.append(MyOrder.init(aDict: object))
                }
                self.myOrderListTableView.reloadData()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension MyOrdersViewController {
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text = "Mina beställningar"
    }
    
}
