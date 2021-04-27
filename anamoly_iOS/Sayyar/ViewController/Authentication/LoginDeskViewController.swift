//
//  LoginDeskViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 02/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class LoginDeskViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var backgroundImageView              : UIImageView!
    @IBOutlet private weak var selectedSegmentBackgroundView    : UIView!
    @IBOutlet private weak var languageButton                   : UIButton!
    @IBOutlet private weak var dutchLanguageButton              : UIButton!
    @IBOutlet private weak var englishLanguageButton            : UIButton!
    @IBOutlet private weak var existingCustomerButton           : UIButton!
    @IBOutlet private weak var newCustomerButton                : UIButton!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }

    //MARK: - Prepare View
    private func prepareView() {
//        prepareDutchLanguage()
        setLanguage(selectedAppLanguage: appLanguage)
        SharedApplication.userManager?.logoutUser()
        
        SUtill.settingListAPICall { [weak self] () in
            guard let `self` = self else { return }
            self.dutchLanguageButton.backgroundColor = SettingList.button_color
            self.dutchLanguageButton.setTitleColor(SettingList.button_text_color, for: .normal)
            self.englishLanguageButton.backgroundColor = SettingList.second_button_color
            self.englishLanguageButton.setTitleColor(SettingList.second_button_text_color, for: .normal)
            
            self.englishLanguageButton.setTitleColor(.lightGray, for: .normal)
            self.englishLanguageButton.backgroundColor = .clear
            
            self.existingCustomerButton.backgroundColor = SettingList.button_color
            self.existingCustomerButton.setTitleColor(SettingList.button_text_color, for: .normal)
            self.newCustomerButton.backgroundColor = SettingList.second_button_color
            self.newCustomerButton.setTitleColor(SettingList.second_button_text_color, for: .normal)
            
            self.backgroundImageView.sd_setImage(with: SettingList.login_top_image, placeholderImage: nil)
        }
    }

    @IBAction private func didTapOnButtonSelectLanguageNew(_ sender: Any) {
        if let chooseLanguageViewController = UIStoryboard.Authentication.get(ChooseLanguageViewController.self) {
            chooseLanguageViewController.modalTransitionStyle   = .crossDissolve
            chooseLanguageViewController.modalPresentationStyle = .overFullScreen
            chooseLanguageViewController.updateBlock = { [weak self] (appLanguage) in
                guard let `self` = self else { return }
                self.setLanguage(selectedAppLanguage: appLanguage)
            }
            self.navigationController?.present(chooseLanguageViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func didTapOnButtonSelectLanguage(_ sender : UIButton) {
        dutchLanguageButton.backgroundColor     = .clear
        englishLanguageButton.backgroundColor   = .clear
        dutchLanguageButton.setTitleColor(.lightGray, for: .normal)
        englishLanguageButton.setTitleColor(.lightGray, for: .normal)
//        UIView.animate(withDuration: 0.5, animations: {
            self.selectedSegmentBackgroundView.center.x = sender.center.x
//        }) { (status) in
            self.dutchLanguageButton.isSelected     = false
            self.englishLanguageButton.isSelected   = false
            sender.isSelected = true
//        }
        switch sender {
        case self.dutchLanguageButton:
//            prepareDutchLanguage()
            dutchLanguageButton.backgroundColor = SettingList.button_color
            dutchLanguageButton.setTitleColor(SettingList.button_text_color, for: .normal)
        case self.englishLanguageButton:
            prepareEnglishLanguage()
            englishLanguageButton.backgroundColor = SettingList.second_button_color
            englishLanguageButton.setTitleColor(SettingList.second_button_text_color, for: .normal)
        default:
            break
        }
    }
    
    @IBAction private func didTapOnButtonExistingCustomer(_ sender: UIButton) {
        let loginViewController = UIStoryboard.Authentication.get(LoginViewController.self)!
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction private func didTapOnButtonNewCustomer(_ sender: UIButton) {
        let registerViewController = UIStoryboard.Authentication.get(RegisterViewController.self)!
        self.navigationController?.pushViewController(registerViewController, animated: true)
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
extension LoginDeskViewController {
    
    private func prepareDutchLanguage() {
        
        appLanguage = .Dutch
        Bundle.setLanguage("es");
        APIManager.shared.setHeader()
//        SDefaultManager.setAppLanguage(isDutch: true)
        dutchLanguageButton.setTitle("Svenska", for: .normal)
        englishLanguageButton.setTitle("Engelska", for: .normal)
        existingCustomerButton.setTitle(NSLocalizedString("Existing Customer", comment: ""), for: .normal)
        newCustomerButton.setTitle(NSLocalizedString("New Customer", comment: ""), for: .normal)
        dutchLanguageButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        englishLanguageButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        existingCustomerButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        newCustomerButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    private func prepareEnglishLanguage() {
        appLanguage = .English
        Bundle.setLanguage("en");
        APIManager.shared.setHeader()
//        SDefaultManager.setAppLanguage(isDutch: false)
        dutchLanguageButton.setTitle("Swedish", for: .normal)
        englishLanguageButton.setTitle("English", for: .normal)
        existingCustomerButton.setTitle("Existing Customer", for: .normal)
        newCustomerButton.setTitle("New Customer", for: .normal)
        dutchLanguageButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        englishLanguageButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        existingCustomerButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        newCustomerButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    private func setLanguage(selectedAppLanguage : AppLanguage) {
        appLanguage = selectedAppLanguage
        Bundle.setLanguage(appLanguage.language)
        SDefaultManager.setAppLanguage(appLanguage.language)
        
        languageButton.setTitle(NSLocalizedString("English", comment: "English"), for: .normal)
        existingCustomerButton.setTitle(NSLocalizedString("Existing User", comment: "Existing User"), for: .normal)
        newCustomerButton.setTitle(NSLocalizedString("New User", comment: "New User"), for: .normal)
    }
    
}
