//
//  WaitingListThreeViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 13/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class WaitingListThreeViewController: BaseViewController {
    
    @IBOutlet private weak var whenTimeComesLabel       : UILabel!
    @IBOutlet private weak var notifyImmediatetlyLabel  : UILabel!
    @IBOutlet private weak var areYouClearButton        : SpinnerButton!
    
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
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonNext(_ sender: Any) {
        Application.shared.window?.rootViewController = UIStoryboard.Authentication.instantiateInitialViewController()
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
extension WaitingListThreeViewController {
 
    private func prepareDutchLanguage() {
        whenTimeComesLabel.text         = "När kommer det?"
        notifyImmediatetlyLabel.text    = "Du kommer att meddelas så fort det är klart, du kommer inte vänta i kö längre"
        areYouClearButton.setTitle("Är du klar?", for: .normal)
        areYouClearButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}
