//
//  NoDeliveryViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 13/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class NoDeliveryViewController: BaseViewController {
    
    @IBOutlet private weak var weNotDeliverLabel            : UILabel!
    @IBOutlet private weak var unfortunatlyLabel            : UILabel!
    @IBOutlet private weak var weWillLetYouKnowSoonLabel    : UILabel!
    
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
    @IBAction private func didTapOnButtonWeWillLetYouKnow(_ sender: Any) {
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
extension NoDeliveryViewController {
    private func prepareDutchLanguage() {
        weNotDeliverLabel.text          = "Ursäkta! Vi levererar inte"
        unfortunatlyLabel.text          = "Tyvärr kan vi inte leverera till dig på grund av hög upptagenhet."
        weWillLetYouKnowSoonLabel.text  = "Vi kommer att låta dig veta så fort vi är redo!"
    }
}
