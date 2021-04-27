//
//  ChooseLanguageViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 31/03/21.
//  Copyright © 2021 Atri Patel. All rights reserved.
//

import UIKit

class ChooseLanguageViewController: BaseViewController {

    @IBOutlet private weak var presentView  : UIView!
    
    var updateBlock : ((AppLanguage) -> ())?
    
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
        self.presentView.transform =  translate
        
        presentView.topRoundCorner(radius: 10)
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func didTapOnButtonLanguage(_ sender: UIButton) {
        switch sender.tag {
        case 1  : updateBlock?(AppLanguage.English)
        case 2  : updateBlock?(AppLanguage.Swedish)
        case 3  : updateBlock?(AppLanguage.Arabic)
        case 4  : updateBlock?(AppLanguage.Turkish)
        default : break
        }
        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
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
extension ChooseLanguageViewController {
    
    private func prepareInitialAnimation() {
        UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
            self.presentView.transform =  CGAffineTransform.identity
        })
    }

}
