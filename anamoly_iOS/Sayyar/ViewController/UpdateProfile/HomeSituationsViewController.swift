//
//  HomeSituationsViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 05/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeSituationsViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var presentingView                       : UIView!
    @IBOutlet private weak var navigationTitleLabel                 : UILabel!
    @IBOutlet private weak var navigationDescriptionLabel           : UILabel!
    @IBOutlet private weak var adultCollectionView                  : UICollectionView!
    @IBOutlet private weak var adultTitleLabel                      : UILabel!
    @IBOutlet private weak var adultCollectionViewHeightConstraint  : NSLayoutConstraint!
    @IBOutlet private weak var adultStepper                         : UIStepper!
    @IBOutlet private weak var childCollectionView                  : UICollectionView!
    @IBOutlet private weak var childTitleLabel                      : UILabel!
    @IBOutlet private weak var childCollectionViewHeightConstraint  : NSLayoutConstraint!
    @IBOutlet private weak var childStepper                         : UIStepper!
    @IBOutlet private weak var dogCollectionView                    : UICollectionView!
    @IBOutlet private weak var dogTitleLabel                        : UILabel!
    @IBOutlet private weak var dogCollectionViewHeightConstraint    : NSLayoutConstraint!
    @IBOutlet private weak var dogStepper                           : UIStepper!
    @IBOutlet private weak var catCollectionView                    : UICollectionView!
    @IBOutlet private weak var catTitleLabel                        : UILabel!
    @IBOutlet private weak var catCollectionViewHeightConstraint    : NSLayoutConstraint!
    @IBOutlet private weak var catStepper                           : UIStepper!
    @IBOutlet private weak var saveButton                           : SpinnerButton!
    
    //MARK: - Variables
    private var isAnyChangeInData   : Bool  = false
    var userUpdatedBlock            : (() -> ())?
    private var adultCount          : Int   = 0
    private var childCount          : Int   = 0
    private var dogCount            : Int   = 0
    private var catCount            : Int   = 0
    
    private var adultString         : String = NSLocalizedString("Adults", comment: "Adults")
    private var childString         : String = NSLocalizedString("Child", comment: "Child")
    private var dogString           : String = NSLocalizedString("Dogs", comment: "Dogs")
    private var catString           : String = NSLocalizedString("Cats", comment: "Cats")
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        presentingView.topRoundCorner(radius: 10)
        
        ///User
        if let family = AppUser?.family {
            adultCount  = family.no_of_adults ?? 0
            childCount  = family.no_of_child ?? 0
            dogCount    = family.no_of_dogs
            catCount    = family.no_of_cats
        }
        
        adultStepper.value = Double(adultCount)
        childStepper.value = Double(childCount)
        dogStepper.value = Double(dogCount)
        catStepper.value = Double(catCount)
        
        adultTitleLabel.text = (adultCount == 0) ? adultString + " " : adultString + " - \(adultCount)"
        childTitleLabel.text = (childCount == 0) ? childString + " " : childString + " - \(childCount)"
        dogTitleLabel.text = (dogCount == 0) ? dogString + " " : dogString + " - \(dogCount)"
        catTitleLabel.text = (catCount == 0) ? catString + " " : catString + " - \(catCount)"
        
        let numberOfCellInRow1 = Int(adultCollectionView.frame.size.width / 30)
        let cellRowCount1 = Int(adultCount / numberOfCellInRow1) + 1
        adultCollectionViewHeightConstraint.constant = CGFloat(cellRowCount1 * 30)
        
        let numberOfCellInRow2 = Int(childCollectionView.frame.size.width / 30)
        let cellRowCount2 = Int(childCount / numberOfCellInRow2) + 1
        childCollectionViewHeightConstraint.constant = CGFloat(cellRowCount2 * 30)
        
        let numberOfCellInRow3 = Int(dogCollectionView.frame.size.width / 30)
        let cellRowCount3 = Int(dogCount / numberOfCellInRow3) + 1
        dogCollectionViewHeightConstraint.constant = CGFloat(cellRowCount3 * 30)
        
        let numberOfCellInRow4 = Int(childCollectionView.frame.size.width / 30)
        let cellRowCount4 = Int(catCount / numberOfCellInRow4) + 1
        catCollectionViewHeightConstraint.constant = CGFloat(cellRowCount4 * 30)
        
        adultCollectionView.reloadData()
        childCollectionView.reloadData()
        dogCollectionView.reloadData()
        catCollectionView.reloadData()
        
        ///Animation
        let translate = CGAffineTransform(translationX: 0, y: ScreenHeight)
        self.presentingView.transform =  translate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.presentingView.transform =  CGAffineTransform.identity
                
                UIView.animate(withDuration: 0.5) { [weak self] () in
                    guard let `self` = self else {return}
                    self.view.layoutIfNeeded()
                }
                
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
    
    @IBAction private func didChangeValueOfStepperHomeSituation(_ sender : UIStepper) {
        isAnyChangeInData = true
        switch sender.tag {
        case 0:
            adultCount = Int(sender.value)
            adultTitleLabel.text = (adultCount == 0) ? adultString + " " : adultString + " - \(adultCount)"
        case 1:
            childCount = Int(sender.value)
            childTitleLabel.text = (childCount == 0) ? childString + " " : childString + " - \(childCount)"
        case 2:
            dogCount = Int(sender.value)
            dogTitleLabel.text = (dogCount == 0) ? dogString + "" : dogString + " - \(dogCount)"
        case 3:
            catCount = Int(sender.value)
            catTitleLabel.text = (catCount == 0) ? catString + " " : catString + " - \(catCount)"
        default: break
        }
        
        let numberOfCellInRow1 = Int(adultCollectionView.frame.size.width / 30)
        let cellRowCount1 = Int(adultCount / numberOfCellInRow1) + 1
        adultCollectionViewHeightConstraint.constant = CGFloat(cellRowCount1 * 30)
        
        let numberOfCellInRow2 = Int(childCollectionView.frame.size.width / 30)
        let cellRowCount2 = Int(childCount / numberOfCellInRow2) + 1
        childCollectionViewHeightConstraint.constant = CGFloat(cellRowCount2 * 30)
        
        let numberOfCellInRow3 = Int(dogCollectionView.frame.size.width / 30)
        let cellRowCount3 = Int(dogCount / numberOfCellInRow3) + 1
        dogCollectionViewHeightConstraint.constant = CGFloat(cellRowCount3 * 30)
        
        let numberOfCellInRow4 = Int(childCollectionView.frame.size.width / 30)
        let cellRowCount4 = Int(catCount / numberOfCellInRow4) + 1
        catCollectionViewHeightConstraint.constant = CGFloat(cellRowCount4 * 30)
        
        UIView.animate(withDuration: 0.5) { [weak self] () in
            guard let `self` = self else {return}
            self.view.layoutIfNeeded()
        }
        
        adultCollectionView.reloadData()
        childCollectionView.reloadData()
        dogCollectionView.reloadData()
        catCollectionView.reloadData()
    }
    
    @IBAction private func didTapOnButtonSave(_ sender: Any) {
        if isValid() {
            updatePhoneAPICall()
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

//MARK: - API Call -
extension HomeSituationsViewController {
    
    private func updatePhoneAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id         : user.user_id ?? 0,
                        SText.Parameter.no_of_adults    : adultCount,
                        SText.Parameter.no_of_cats      : catCount,
                        SText.Parameter.no_of_child     : childCount,
                        SText.Parameter.no_of_dogs      : dogCount,
                    ] as [String : Any]
        saveButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.updateFamily(param), arrImages: [], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            self.saveButton.endLoading()
            if let data = response.data, response.success {
                if let family = user.family {
                    family.no_of_adults = data["no_of_adults"].intValue
                    family.no_of_child  = data["no_of_child"].intValue
                    family.no_of_dogs   = data["no_of_dogs"].intValue
                    family.no_of_cats   = data["no_of_cats"].intValue
                    Application.shared.userManager?.login(user: user, flowNavigate: false)
                    SharedApplication.userManager?.login(user: user, flowNavigate: false)
                    self.userUpdatedBlock?()
                    SUtill.showSuccessMessage(message: response.message ?? "")
                    self.dismissViewController()
                } else {
                    self.dismissViewController()
                }
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { [weak self] (apiErrorResponse) in
            guard let  `self` = self else {return}
            self.saveButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - Helper Methods -
extension HomeSituationsViewController {
    
    private func isValid() -> Bool {
        if isAnyChangeInData == false {
            self.showAlert(withMessage: SText.Messages.noValidation)
            return false
        }
        return true
    }
    
    private func dismissViewController() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text       = "Hemläge"
        navigationDescriptionLabel.text = "Hur många är ni i familjen?"
        saveButton.setTitle("Spara", for: .normal)
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - CollectionView DataSoruce, Dellegate, DelegateFlowLayout
extension HomeSituationsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case adultCollectionView:
            return adultCount
        case childCollectionView:
            return childCount
        case dogCollectionView:
            return dogCount
        case catCollectionView:
            return catCount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.registerAndGet(cell: HomeSituationCollectionViewCell.self, indexPath: indexPath)!
        switch collectionView {
        case adultCollectionView:
            cell.homeSituationImage = UIImage(named: "homeSituationAdult")
        case childCollectionView:
            cell.homeSituationImage = UIImage(named: "homeSituationChild")
        case dogCollectionView:
            cell.homeSituationImage = UIImage(named: "homeSituationDog")
        case catCollectionView:
            cell.homeSituationImage = UIImage(named: "homeSituationCat")
        default: break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
}
