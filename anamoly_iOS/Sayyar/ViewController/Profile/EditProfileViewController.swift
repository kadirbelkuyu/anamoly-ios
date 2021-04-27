//
//  EditProfileViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 28/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

class EditProfileModel : NSObject {
    
    var productTitle        : String! = ""
    var productDescription  : String! = ""
    
    init(productTitle : String, productDescription : String) {
        self.productTitle = productTitle
        self.productDescription = productDescription
    }
    
}

import UIKit
import AVKit

class EditProfileViewController: BaseViewController {
    
    @IBOutlet private weak var navigationTitleLabel                     : UILabel!
    @IBOutlet private weak var userImageView                            : UIImageView!
    @IBOutlet private weak var userMobileNumberLabel                    : UILabel!
    @IBOutlet private weak var userEmailLabel                           : UILabel!
    
    @IBOutlet private weak var fullNameTitleLabel                       : UILabel!
    @IBOutlet private weak var emailIDTitleLabel                        : UILabel!
    @IBOutlet private weak var phoneNoTitleLabel                        : UILabel!
    @IBOutlet private weak var addressTitleLabel                        : UILabel!
    @IBOutlet private weak var homeSituationsTitleLabel                 : UILabel!
    
    @IBOutlet private weak var userFullNameLabel                        : UILabel!
    @IBOutlet private weak var userEmailIDLabel                         : UILabel!
    @IBOutlet private weak var userPhoneNoLabel                         : UILabel!
    @IBOutlet private weak var userAddressLabel                         : UILabel!
    @IBOutlet private weak var profileCollectionView                    : UICollectionView!
    @IBOutlet private weak var profileCollectionViewHeightConstraint    : NSLayoutConstraint!
    @IBOutlet private weak var changePasswordButton                     : UIButton!
    
    private var imagePicker : ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    private func prepareView() {
        //Image Picker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if let user = AppUser {
            setUser(user: user)
        }
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private var playerViewController : AVPlayerViewController!
    @IBAction private func didTapOnButtonLogout(_ sender: Any) {
        SUtill.userLogout(self)
    }
    
    @IBAction private func didTapOnButtonUserProfilePhoto(_ sender : UIButton) {
        self.imagePicker.present(from: self.view, showRemoveProfilePicture: false) {}
    }
    
    @IBAction private func didTapOnButtonFullName(_ sender : Any) {
        let fullNameViewController = UIStoryboard.UpdateProfile.get(FullNameViewController.self)!
        fullNameViewController.modalPresentationStyle = .overFullScreen
        fullNameViewController.modalTransitionStyle = .crossDissolve
        fullNameViewController.userUpdatedBlock = { [weak self] () in
            guard let `self` = self else {return}
            if let user = AppUser {
                self.setUser(user: user)
            }
        }
        self.present(fullNameViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapOnButtonEmail(_ sender : Any) {
        let emailViewController = UIStoryboard.UpdateProfile.get(EmailViewController.self)!
        emailViewController.userUpdatedBlock = { [weak self] () in
            guard let `self` = self else {return}
            if let user = AppUser {
                self.setUser(user: user)
            }
        }
        let navigationController = UINavigationController(rootViewController: emailViewController)
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapOnButtonPhone(_ sender : Any) {
        let phoneNoViewController = UIStoryboard.UpdateProfile.get(PhoneNoViewController.self)!
        phoneNoViewController.modalPresentationStyle = .overFullScreen
        phoneNoViewController.modalTransitionStyle = .crossDissolve
        phoneNoViewController.userUpdatedBlock = { [weak self] () in
            guard let `self` = self else {return}
            if let user = AppUser {
                self.setUser(user: user)
            }
        }
        self.present(phoneNoViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapOnButtonAddress(_ sender : Any) {
        let addressViewController = UIStoryboard.UpdateProfile.get(AddressViewController.self)!
        addressViewController.modalPresentationStyle = .overFullScreen
        addressViewController.modalTransitionStyle = .crossDissolve
        addressViewController.isForUpdateAddress = true
        addressViewController.userUpdatedBlock = { [weak self] () in
            guard let `self` = self else {return}
            if let user = AppUser {
                self.setUser(user: user)
            }
        }
        self.present(addressViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapOnButtonHomeSituations(_ sender : Any) {
        let homeSituationsViewController = UIStoryboard.UpdateProfile.get(HomeSituationsViewController.self)!
        homeSituationsViewController.modalPresentationStyle = .overFullScreen
        homeSituationsViewController.modalTransitionStyle = .crossDissolve
        homeSituationsViewController.userUpdatedBlock = { [weak self] () in
            guard let `self` = self else {return}
            if let user = AppUser {
                self.setUser(user: user)
            }
        }
        self.present(homeSituationsViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapOnButtonChangePassword(_ sender: Any) {
        let changePasswordViewController = UIStoryboard.UpdateProfile.get(ChangePasswordViewController.self)!
        changePasswordViewController.modalPresentationStyle = .overFullScreen
        changePasswordViewController.modalTransitionStyle = .crossDissolve
        changePasswordViewController.userUpdatedBlock = { [weak self] () in
            guard let `self` = self else {return}
            if let user = AppUser {
                self.setUser(user: user)
            }
        }
        self.present(changePasswordViewController, animated: true, completion: nil)
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

//MARK: - Helper Methods -
extension EditProfileViewController {
    
    private func setUser(user : User) {
        if let url = user.user_image {
            userImageView.sd_setImage(with: url, placeholderImage: Product_Placeholder)
        } else {
            userImageView.image = Product_Placeholder
        }
        userMobileNumberLabel.text  = user.user_phone
        userEmailLabel.text         = user.user_email
        userFullNameLabel.text      = user.user_firstname + " " + user.user_lastname
        userEmailIDLabel.text       = user.user_email
        userPhoneNoLabel.text       = user.user_phone
        if user.addresses.count > 0 {
            userAddressLabel.text   = user.addresses[0].fullAddress
        }
        
        if let family = user.family {
            let familyCount = family.no_of_adults + family.no_of_child + family.no_of_dogs + family.no_of_cats
            let numberOfCellInRow = Int(profileCollectionView.frame.size.width / 30)
            let cellRowCount = Int(familyCount / numberOfCellInRow) + 1
            profileCollectionViewHeightConstraint.constant = CGFloat(cellRowCount * 30)
        }
        profileCollectionView.reloadData()
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text       = "Min profil"
        fullNameTitleLabel.text         = "Fullständig namn"
        emailIDTitleLabel.text          = "Ange e-postadress"
        phoneNoTitleLabel.text          = "Telefonnummer"
        addressTitleLabel.text          = "Adress"
        homeSituationsTitleLabel.text   = "Hemläge"
        changePasswordButton.setTitle("Ändra lösenord", for: .normal)
        changePasswordButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - CollectionView DataSouce, Delegate, FlowLayout
extension EditProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let family = AppUser?.family {
            return family.no_of_adults + family.no_of_child + family.no_of_dogs + family.no_of_cats
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.registerAndGet(cell: HomeSituationCollectionViewCell.self, indexPath: indexPath)!
        if let family = AppUser?.family {
            let adult   : Int = family.no_of_adults
            let child   : Int = family.no_of_child
            let dog     : Int = family.no_of_dogs
            let cat     : Int = family.no_of_cats
            
            if indexPath.row < adult {
                cell.homeSituationImage = UIImage(named: "homeSituationAdult")!
            } else if indexPath.row >= adult && indexPath.row < adult + child {
                cell.homeSituationImage = UIImage(named: "homeSituationChild")!
            } else if indexPath.row >= adult + child && indexPath.row < adult + child + dog {
                cell.homeSituationImage = UIImage(named: "homeSituationDog")!
            } else if indexPath.row >= adult + child + dog && indexPath.row < adult + child + dog + cat {
                cell.homeSituationImage = UIImage(named: "homeSituationCat")!
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
}

//MARK: - Image Picker Delegate -
extension EditProfileViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            userImageView.image = image
            updateProfilePhotoAPICall(image: image)
        }
    }
    
}

//MARK: - API Call -
extension EditProfileViewController {
    
    private func updateProfilePhotoAPICall(image : UIImage) {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0
                    ] as [String : Any]
        SUtill.showProgressHUD()
        APIManager.shared.callRequestWithMultipartData(APIRouter.updateProfilePhoto(param), arrImages: [image], onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if let data = response.data, response.success {
                print(data)
                SUtill.showSuccessMessage(message: response.message ?? "")
//                SharedApplication.userManager?.updateUserProfilePhoto(user: user, urlString: data["user_image"].stringValue)
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
