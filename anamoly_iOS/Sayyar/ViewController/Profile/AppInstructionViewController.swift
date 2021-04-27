//
//  AppInstructionViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 04/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import WebKit

class AppInstructionViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var navigationBarTitleLabel  : UILabel!
    @IBOutlet private weak var introductionWebView      : WKWebView!
    @IBOutlet private weak var webViewActivityIndicator : UIActivityIndicatorView!
    
    var navigationTitle : String!   = ""
    var loadURL         : URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
        
        
    }
    
    //MARK: - Prepre View
    private func prepareView() {
        navigationBarTitleLabel.text = navigationTitle
        
        self.introductionWebView.navigationDelegate = self
        self.introductionWebView.allowsBackForwardNavigationGestures = true
        if let loadURL = loadURL {
            introductionWebView.load(URLRequest(url: loadURL))
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
extension AppInstructionViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewActivityIndicator.startAnimating()
        
        if navigationTitle == "iDeal Payment" && webView.url != nil && webView.url!.absoluteString.containsIgnoringCase(find: "idealpayment/response") {
            webView.isHidden = true
            webViewActivityIndicator.stopAnimating()
            webView.stopLoading()
            callAPI(path: webView.url?.absoluteString ?? "")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewActivityIndicator.stopAnimating()
        if navigationTitle == "iDeal Payment" && webView.url != nil && webView.url!.absoluteString.containsIgnoringCase(find: "idealpayment/response") {
            webView.isHidden = true
            webView.stopLoading()
            callAPI(path: webView.url?.absoluteString ?? "")
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewActivityIndicator.stopAnimating()
    }
    
}

//MARK: - Helper Methods -
extension AppInstructionViewController {
    
    private func callAPI(path : String) {
        SUtill.showProgressHUD()
        let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        APIManager.shared.callRequest(path: path, onSuccess: { [weak self] (response) in
            guard let `self` = self else {return}
            SUtill.hideProgressHUD()
            if response.success, let data = response.data {
                let orderCompletionViewController = UIStoryboard.Cart.get(OrderCompletionViewController.self)!
                orderCompletionViewController.myOrderDetail = MyOrderDetail.init(aDict: data)
                self.navigationController?.pushViewController(orderCompletionViewController, animated: true)
            } else {
                self.showAlert(withMessage: response.message ?? "", withActions: okButton)
            }
        }, onFailure: { (apiErrorResponse) in
            SUtill.hideProgressHUD()
            self.showAlert(withMessage: apiErrorResponse.message, withActions: okButton)
        })
    }
    
}
