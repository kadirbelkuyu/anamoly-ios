//
//  RequestNewProductViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 23/03/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class RequestNewProductViewController: BaseViewController {
    
    @IBOutlet private weak var presentingView               : UIView!
    @IBOutlet private weak var suggestMissionProductLabel   : UILabel!
    @IBOutlet private weak var productNameTextField         : UITextField!
    @IBOutlet private weak var uploadProductLabel           : UILabel!
    @IBOutlet private weak var productImageView             : UIImageView!
    @IBOutlet private weak var saveButton                   : SpinnerButton!
    
    private var imagePicker : ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        presentingView.topRoundCorner(radius: 10)
        
        ///Animation
        let translate = CGAffineTransform(translationX: 0, y: ScreenHeight)
        self.presentingView.transform =  translate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.presentingView.transform =  CGAffineTransform.identity
            })
        }
        
        //Image Picker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonDismiss(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
            guard let `self` = self else {return}
            self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }) { [weak self] (status) in
            guard let `self` = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func didTapOnButtonAddImage(_ sender : UIImage) {
        self.imagePicker.present(from: self.view, showRemoveProfilePicture: false) {}
    }
    
    @IBAction private func didTapOnButtonSave(_ sender: Any) {
        if isValid() {
            productSuggestAPICall()
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

//MARK: - Helper Methods -
extension RequestNewProductViewController {
    
    private func isValid() -> Bool {
        if (productNameTextField.text?.trimmedLength == 0) {
            let okButton = UIAlertAction(title: SText.Button.OK, style: .default) { (status) in
                self.productNameTextField.becomeFirstResponder()
            }
            self.showAlert(withMessage: SText.Messages.blankProductName, withActions: okButton)
            return false
        }
        self.view.endEditing(true)
        return true
    }
    
    private func prepareDutchLanguage() {
        suggestMissionProductLabel.text     = "Föreslag av missade produkter"
        productNameTextField.placeholder    = "Ex. Ekologisk banan, 5 sek."
        uploadProductLabel.text             = "Ladda upp produkt bild (frivilligt)"
        saveButton.setTitle("Skicka", for: .normal)
        saveButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - TextField Delegate
extension RequestNewProductViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if isValid() {
            productSuggestAPICall()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

//MARK: - Image Picker Delegate -
extension RequestNewProductViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            productImageView.image = image
        }
    }
    
}

//MARK: - API Call
extension RequestNewProductViewController {
    
    private func productSuggestAPICall() {
        guard let user = AppUser else {return}
        let param = [
                        SText.Parameter.user_id     : user.user_id ?? 0,
                        SText.Parameter.suggestion  : productNameTextField.text?.trimmed ?? ""
                    ] as [String : Any]
        var imageArray : [UIImage] = []
        if let image = productImageView.image {
            imageArray.append(image)
        }
        saveButton.startLoading()
        APIManager.shared.callRequestWithMultipartData(APIRouter.productSuggest(param), arrImages: imageArray, onSuccess: { (response) in
            self.saveButton.endLoading()
            if response.success {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak self] () in
                    guard let `self` = self else {return}
                    self.presentingView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
                }) { [weak self] (status) in
                    guard let `self` = self else {return}
                    self.dismiss(animated: true, completion: nil)
                }
                SUtill.showSuccessMessage(message: response.message ?? "")
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.saveButton.endLoading()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}
