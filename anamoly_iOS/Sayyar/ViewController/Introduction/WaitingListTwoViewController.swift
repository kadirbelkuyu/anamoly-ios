//
//  WaitingListTwoViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 13/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class WaitingListTwoViewController: BaseViewController {
    
    @IBOutlet private weak var whenCanIStartLabel   : UILabel!
    @IBOutlet private weak var thatTakeTimeLabel    : UILabel!
    @IBOutlet private weak var whenItComesLabel     : UILabel!
    
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
        let waitingListThreeViewController = UIStoryboard.Introduction.get(WaitingListThreeViewController.self)!
        let navigationController = UINavigationController(rootViewController: waitingListThreeViewController)
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
extension WaitingListTwoViewController {
    
    private func prepareDutchLanguage() {
        whenCanIStartLabel.text = "När kan jag börja?"
        thatTakeTimeLabel.text  = "Detta kan dröja lite, men vi jobbar hårt på det, varje vecka tar vi fram nya bilar och chaufförer för leverans"
        whenItComesLabel.text   = "När kommer det?"
    }
    
}
