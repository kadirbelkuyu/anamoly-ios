//
//  WaitingListOneViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 13/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import MessageUI

class WaitingListOneViewController: BaseViewController {
    
    @IBOutlet private weak var welcomeYourplaceIsReservedLabel  : UILabel!
    @IBOutlet private weak var youAreInQueueLabel               : UILabel!
    @IBOutlet private weak var waitingListNumberLabel           : UILabel!
    @IBOutlet private weak var weWillSendMessageLabel           : UILabel!
    @IBOutlet private weak var contactUsButton                  : UIButton!
    @IBOutlet private weak var youAreInQueueWaitLabel           : UILabel!
    @IBOutlet private weak var whenCanIStartLabel               : UILabel!
    
    var waitingListNo : Int = 0
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
        
        waitingListNumberLabel.text = "\(waitingListNo)"
    }
    
    //MARK: - Action Methods -
    @IBAction func didTapOnButtonContactUsIfYouNeedHelp(_ sender: Any) {
        callEmail(mailTo: SettingList.app_email, body: "")
    }
    
    @IBAction private func didTapOnButtonNext(_ sender: Any) {
        let waitingListTwoViewController = UIStoryboard.Introduction.get(WaitingListTwoViewController.self)!
        let navigationController = UINavigationController(rootViewController: waitingListTwoViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.isNavigationBarHidden  = true
        navigationController.navigationBar.isHidden = true
        self.navigationController?.present(navigationController, animated: true, completion: nil)
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
extension WaitingListOneViewController {
   
    private func callEmail(mailTo : String, body : String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailTo])
            mail.setMessageBody("<p>\(body)</p>", isHTML: true)
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    private func prepareDutchLanguage() {
        welcomeYourplaceIsReservedLabel.text    = "Välkommen!\n Din plats är reserverad"
        youAreInQueueLabel.text                 = "Du står i kö"
        weWillSendMessageLabel.text             = "Vi kommer att låta dig veta så fort vi är redo!"
        youAreInQueueWaitLabel.text             = "Du står i kö. Vänta tills administrationen bekräftar ditt konto"
        contactUsButton.setTitle("Kontakta oss om du behöver hjälp", for: .normal)
        contactUsButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 45, bottom: 0, right: 0)
        contactUsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        whenCanIStartLabel.text                 = "När kan jag börja?"
    }
    
}

//MARK: - Mail Delegate -
extension WaitingListOneViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
