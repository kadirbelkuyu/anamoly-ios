//
//  AppIntroViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 16/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import WebKit

class AppIntroViewController: BaseViewController {

    @IBOutlet private weak var introductionWebView              : WKWebView!
    @IBOutlet private weak var introductionActivityIndicator    : UIActivityIndicatorView!
    @IBOutlet private weak var settingsButton                   : SpinnerButton!
    @IBOutlet private weak var okButton                         : SpinnerButton!
    
    var statusCode  : Int       = 0
    var emailID     : String    = ""
    var waitingNo   : Int       = 0
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    
    //MARK: - Prepre View
    private func prepareView() {
        self.introductionWebView.navigationDelegate = self
        self.introductionWebView.allowsBackForwardNavigationGestures = true
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
            self.introductionWebView.load(URLRequest(url: URL(string: BaseURL + "/index.php/apppages/intro/dutch")!))
        } else {
            self.introductionWebView.load(URLRequest(url: URL(string: BaseURL + "/index.php/apppages/intro/english")!))
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnButtonSettings(_ sender : Any) {
        let settingsViewController = UIStoryboard.UpdateProfile.get(SettingsViewController.self)!
        settingsViewController.statusCode   = statusCode == 0 ? 1 : statusCode
        settingsViewController.emailID      = emailID
        settingsViewController.waitingNo    = waitingNo
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction private func didTapOnButtonOk(_ sender : Any) {
        if statusCode == 108, emailID.trimmedLength > 0 {
            let otpViewController = UIStoryboard.Authentication.get(OTPViewController.self)!
            otpViewController.emailAddress = emailID.trimmed
            self.navigationController?.pushViewController(otpViewController, animated: true)
        } else if statusCode == 106, waitingNo > 0 {
            let waitingListOneViewController = UIStoryboard.Introduction.get(WaitingListOneViewController.self)!
            waitingListOneViewController.waitingListNo = waitingNo
            let navigationViewController = UINavigationController(rootViewController: waitingListOneViewController)
            navigationViewController.modalPresentationStyle = .overFullScreen
            navigationViewController.isNavigationBarHidden  = true
            navigationViewController.navigationBar.isHidden = true
            self.navigationController?.present(navigationViewController, animated: true, completion: nil)
        } else if statusCode == 105 {
            let noDeliveryViewController = UIStoryboard.Introduction.get(NoDeliveryViewController.self)!
            noDeliveryViewController.modalPresentationStyle = .overFullScreen
            self.present(noDeliveryViewController, animated: true, completion: nil)
        } else {
            Application.shared.window?.rootViewController = UIStoryboard.Main.instantiateInitialViewController()
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

//MARK: - WKNavigation Delegate
extension AppIntroViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.introductionActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.introductionActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.introductionActivityIndicator.stopAnimating()
    }
    
}

//MARK: - Helper Methods -
extension AppIntroViewController {
    
    private func prepareDutchLanguage() {
        settingsButton.setTitle("Inställningar", for: .normal)
        okButton.setTitle("OK", for: .normal)
        settingsButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        okButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}
