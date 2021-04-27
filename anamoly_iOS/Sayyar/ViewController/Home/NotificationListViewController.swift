//
//  NotificationListViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 16/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class NotificationListViewController: BaseViewController {

    @IBOutlet private weak var notificationListTableView : UITableView!
    @IBOutlet private weak var navigationTitleLabel : UILabel!
    var notificationListArray : [NotificationListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if appLanguage == .Dutch {
//            navigationTitleLabel.text = "Notiser";
        }
        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        notificationListAPICall()
    }
    
    //MARK: - Action Methods -
    @IBAction func didTapOnButtonBack(_ sender: Any) {
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

//MARK: - TableView DataSource, Delegate -
extension NotificationListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: NotificationListTableViewCell.self)!
        cell.notificationListModel = notificationListArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationListArray[indexPath.row].type.lowercased() == "order" {
            if let myOrderDetailViewController = UIStoryboard.Order.get(MyOrderDetailViewController.self) {
                myOrderDetailViewController.orderID = notificationListArray[indexPath.row].type_id
                self.navigationController?.pushViewController(myOrderDetailViewController, animated: true)
            }
        }
    }
    
}

//MARK: - API Call -
extension NotificationListViewController {
    
    private func notificationListAPICall() {
        guard let user = AppUser else {return}
        let param = [ SText.Parameter.user_id : user.user_id ?? 0 ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.notificationList(param), arrImages: [], onSuccess: { (response) in
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                for object in data.arrayValue {
                    self.notificationListArray.append(NotificationListModel.init(aDict: object))
                }
                self.notificationListTableView.reloadData()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
