//
//  DeliveryTimeSlotViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 09/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class DeliveryTimeSlotViewController: BaseViewController {

    @IBOutlet private weak var presentingView               : UIView!
    @IBOutlet private weak var navigationTitleLabel         : UILabel!
    @IBOutlet private weak var deliveryTimeSlotTableView    : UITableView!
    
    private var deliveryTimeSlotArray   : [DeliveryTimeSlot] = []
    var deliveryTimeSlotSelected        : DeliveryTimeSlot?
    var deliveryTimeUpdatedBlock        : ((DeliveryTimeSlot) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        presentingView.topRoundCorner(radius: 10)
        
        timeSlotsAPICall()
        
        ///Animation
        let translate = CGAffineTransform(translationX: 0, y: ScreenHeight)
        self.presentingView.transform =  translate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.presentingView.transform =  CGAffineTransform.identity
            })
        }
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonDismiss(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
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

extension DeliveryTimeSlotViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryTimeSlotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: DeliveryTimeSlotTableViewCell.self)!
        cell.deliveryTimeSlot = deliveryTimeSlotArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deliveryTimeUpdatedBlock?(deliveryTimeSlotArray[indexPath.row])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - API Call -
extension DeliveryTimeSlotViewController {
    
    private func timeSlotsAPICall() {
        guard AppUser?.addresses.count ?? 0 > 0, let addresses = AppUser?.addresses.first else {return}
        let param = [
                        SText.Parameter.postal_code : addresses.postal_code ?? ""
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.timeSlots(param), arrImages: [], onSuccess: {  [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                for object in data.arrayValue {
                    self.deliveryTimeSlotArray.append(DeliveryTimeSlot.init(aDict: object))
                }
                if let deliveryTimeSlotSelected = self.deliveryTimeSlotSelected {
                    let filterData = self.deliveryTimeSlotArray.filter( { $0.date == deliveryTimeSlotSelected.date } )
                    if filterData.count > 0 {
                        filterData.first?.isSelected = true
                    }
                }
                self.deliveryTimeSlotTableView.reloadData()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension DeliveryTimeSlotViewController {
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text = "Välj leveranstid"
    }
    
}
