//
//  ProfileViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    //MARK: - Outlets -
    @IBOutlet private weak var navigationTitleLabel : UILabel!
    @IBOutlet private weak var userImageView        : UIImageView!
    @IBOutlet private weak var userNameLabel        : UILabel!
    @IBOutlet private weak var userEmailLabel       : UILabel!
    @IBOutlet private weak var userAccountTableView : UITableView!
    
    //MARK: - Variables -
    private var userAccountArray : [String] = [
        NSLocalizedString("My Orders", comment: "My Orders"),
        NSLocalizedString("Settings", comment: ""),
//        NSLocalizedString("Discount on Share app", comment: "Discount on Share app"),
        NSLocalizedString("App Instruction", comment: "App Instruction"),
        NSLocalizedString("Contact Us", comment: "Contact Us")
    ]
//        "My Orders", "Settings", /*"Discount on Share app",*/ "App Instruction", "Contact us"]
    
    //MARK: - Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = AppUser {
            setUser(user: user)
        }
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonEditProfile(_ sender: Any) {
        let editProfileViewController = UIStoryboard.Profile.get(EditProfileViewController.self)!
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    @IBAction private func didTapOnButtonLogout(_ sender: Any) {
        SUtill.userLogout(self)
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
extension ProfileViewController {
    
    private func setUser(user : User) {
        if let url = user.user_image {
            userImageView.sd_setImage(with: url, placeholderImage: Product_Placeholder)
        } else {
            userImageView.image = Product_Placeholder
        }
        userNameLabel.text = user.user_phone
        userEmailLabel.text = user.user_email
    }
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text = "Användare"
        userAccountArray = [ "Mina beställningar", "Inställningar", /*"Korting op Delen App",*/ "App instruktion", "Kontakta oss" ]
        userAccountTableView.reloadData()
    }
    
}

//MARK: - TableView DataSource, Delegate -
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAccountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGet(cell: UserAccountTableViewCell.self)!
        cell.titleName = userAccountArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let myOrdersViewController = UIStoryboard.Order.get(MyOrdersViewController.self)!
            self.navigationController?.pushViewController(myOrdersViewController, animated: true)
        case 1:
            let settingsViewController = UIStoryboard.UpdateProfile.get(SettingsViewController.self)!
            self.navigationController?.pushViewController(settingsViewController, animated: true)
//        case 2:
//            let shareApplicationViewController = UIStoryboard.Profile.get(ShareApplicationViewController.self)!
//            self.navigationController?.pushViewController(shareApplicationViewController, animated: true)
        case 2:
            let appInstructionViewController = UIStoryboard.Profile.get(AppInstructionViewController.self)!
            appInstructionViewController.navigationTitle = NSLocalizedString("App Instruction", comment: "App Instruction")
            appInstructionViewController.loadURL = appLanguage == .Dutch ? URL(string: BaseURL + "/index.php/apppages/about/dutch") : URL(string: BaseURL + "/index.php/apppages/about/english")
            self.navigationController?.pushViewController(appInstructionViewController, animated: true)
            break
        case 3:
            let contactUsViewController = UIStoryboard.Profile.get(ContactUsViewController.self)!
            self.navigationController?.pushViewController(contactUsViewController, animated: true)
        default: break
        }
    }
    
}
