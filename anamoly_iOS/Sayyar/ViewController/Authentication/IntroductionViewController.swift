//
//  IntroductionViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 05/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import WebKit

class IntroductionViewController: BaseViewController {

    //MARK: - Outlets -
    @IBOutlet private weak var navigationBarTitleLabel  : UILabel!
    @IBOutlet private weak var introductionWebView      : WKWebView!
    @IBOutlet private weak var webViewActivityIndicator : UIActivityIndicatorView!
    
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
            self.introductionWebView.load(URLRequest(url: URL(string: BaseURL + "/index.php/apppages/policy/dutch")!))
        } else {
            self.introductionWebView.load(URLRequest(url: URL(string: BaseURL + "/index.php/apppages/policy/english")!))
        }
    }
    
    //MARK: - Action Methods
    @IBAction private func didTapOnButtonback(_ sender : Any) {
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

//MARK: - WKNavigation Delegate
extension IntroductionViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.webViewActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webViewActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webViewActivityIndicator.stopAnimating()
    }
    
}

//MARK: - Helper Methods -
extension IntroductionViewController {
    
    private func prepareDutchLanguage() {
        navigationBarTitleLabel.text = "Integritetspolicy"
    }
    
}
