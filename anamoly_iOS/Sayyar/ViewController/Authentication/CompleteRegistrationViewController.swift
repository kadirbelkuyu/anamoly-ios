//
//  CompleteRegistrationViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 04/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import MessageUI

class CompleteRegistrationViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var registrationCompleteView     : UIView!
    @IBOutlet private weak var tanksTitleLabel              : UILabel!
    @IBOutlet private weak var thanksDescriptionLabel       : UILabel!
    @IBOutlet private weak var waitingListTitleLabel        : UILabel!
    @IBOutlet private weak var waitingListCountLabel        : UILabel!
    @IBOutlet private weak var confirmationMessageLabel     : UILabel!
    @IBOutlet private weak var contactUsIfYouNeedHelpButton : UIButton!
    @IBOutlet private weak var closeButton                  : UIButton!
    
    var wailtingListNumber : Int = 0
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.prepareInitialAnimation()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        let translate = CGAffineTransform(translationX: 0, y: ScreenHeight)
        self.registrationCompleteView.transform =  translate
        
        waitingListCountLabel.text = "\(wailtingListNumber)"
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods
    @IBAction func didTapOnButtonContactUsIfYouNeedHelp(_ sender: Any) {
        callEmail(mailTo: SettingList.app_email, body: "")
    }
    
    @IBAction private func didTapOnButtonClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.registrationCompleteView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
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

//MARK: - Helper Methods
extension CompleteRegistrationViewController {
    
    private func prepareInitialAnimation() {
        UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
            self.registrationCompleteView.transform =  CGAffineTransform.identity
        })
    }
    
    private func prepareDutchLanguage() {
        tanksTitleLabel.text                 = "Tack för att du registrerade dig"
        thanksDescriptionLabel.text          = "Vänligen vänta tills administrationen bekräftar ditt konto."
        waitingListTitleLabel.text           = "Väntelista nr."
        confirmationMessageLabel.text        = "Vi kommer inom kort att maila dig om bekräftad konto"
        contactUsIfYouNeedHelpButton.setTitle("Kontakta oss om du behöver hjälp", for: .normal)
        closeButton.setTitle("Stäng", for: .normal)
        contactUsIfYouNeedHelpButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        closeButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
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
    
}

//MARK: - Mail Delegate
extension CompleteRegistrationViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
