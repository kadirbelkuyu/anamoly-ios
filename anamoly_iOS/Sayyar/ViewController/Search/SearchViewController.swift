//
//  SearchViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 08/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    //MARK: - Outlets -
    @IBOutlet private weak var navigationTitleLabel         : UILabel!
    @IBOutlet private weak var searchTextField              : UITextField!
    @IBOutlet private weak var searchProductTableView       : UITableView!
    @IBOutlet private weak var progressActivityIndicator    : UIActivityIndicatorView!
    
    //MARK: - Variables -
    private var categoryListArray   : [CategoryListModel]   = []
    private var searchProductArray  : [SearchProductModel]  = []
    private var isSearching         : Bool                  = false
    
    //MARK: - Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    //MARK: - Prepare View
    private func prepareView() {
        categoryListAPICall()
        
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnButtonBarcodeScanner(_ sender: Any) {
        if let barcodeScanViewController = UIStoryboard.Home.get(BarcodeScanViewController.self) {
            self.navigationController?.pushViewController(barcodeScanViewController, animated: true)
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

//MARK: - TableView DataSource, Delegate -
extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchProductArray.count : categoryListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.registerAndGet(cell: SearchTextTableViewCell.self)!
            cell.searchProductModel = searchProductArray[indexPath.row]
            return cell
        } else {
            let cell = tableView.registerAndGet(cell: SearchProductTableViewCell.self)!
            cell.categoryListModel = categoryListArray [indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let searchTextProductDetailViewController = UIStoryboard.Search.get(SearchTextProductDetailViewController.self)!
            searchTextProductDetailViewController.searchProductModel = searchProductArray[indexPath.row]
            self.navigationController?.pushViewController(searchTextProductDetailViewController, animated: true)
        } else {
            if (categoryListArray[indexPath.row].subcategories.count > 0) {
                let searchDetailViewController = UIStoryboard.Search.get(SearchDetailViewController.self)!
                searchDetailViewController.categoryListModel = categoryListArray[indexPath.row]
                self.navigationController?.pushViewController(searchDetailViewController, animated: true)
            } else {
                let searchDetailProductViewController = UIStoryboard.Search.get(SearchDetailProductViewController.self)!
                searchDetailProductViewController.categoryListModel = categoryListArray[indexPath.row]
                self.navigationController?.pushViewController(searchDetailProductViewController, animated: true)
            }
        }
    }
    
}

//MARK: - API Call -
extension SearchViewController {
    
    private func categoryListAPICall() {
        let param = [:] as [String : Any]
        startActivityIndicator()
        APIManager.shared.callRequestWithMultipartData(APIRouter.categoriesListAPI(param), arrImages: [], onSuccess: { (response) in
            self.stopActivityIndicator()
            if let data = response.data, response.success {
                self.categoryListArray.removeAll()
                for object in data.arrayValue {
                    self.categoryListArray.append(CategoryListModel.init(aDict: object))
                }
                self.searchProductTableView.reloadWithBottomToTopAnimation()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.stopActivityIndicator()
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
    private func searchListAPICall(searchText : String) {
        let param = [
                        SText.Parameter.search : searchText
                    ] as [String : Any]
        APIManager.shared.callRequestWithMultipartData(APIRouter.searchList(param), arrImages: [], onSuccess: { (response) in
            if response.success {
                self.searchProductArray.removeAll()
                if let data = response.data {
                    for object in data.arrayValue {
                        self.searchProductArray.append(SearchProductModel.init(aDict: object, searchText: searchText))
                    }
                }
                self.searchProductTableView.reloadData()
            } else {
                self.showAlert(withMessage: response.message ?? "")
            }
        }, onFailure: { (apiErrorResponse) in
            self.showAlert(withMessage: apiErrorResponse.message)
        })
    }
    
}

//MARK: - TextField Delegate -
extension SearchViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            isSearching = updatedText.trimmedLength > 0 ? true : false
            if isSearching {
                searchListAPICall(searchText: updatedText)
            } else {
                searchProductTableView.reloadData()
            }
        } else {
            isSearching = false
            searchProductTableView.reloadData()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isSearching = false
        searchProductTableView.reloadData()
        return true
    }
    
}

//MARK: - Helper Methods -
extension SearchViewController {
    
    private func prepareDutchLanguage() {
        navigationTitleLabel.text   = "Sök"
        searchTextField.placeholder = "Skriv vad du vill söka"
    }
    
    private func startActivityIndicator() {
        progressActivityIndicator.startAnimating()
        progressActivityIndicator.isHidden = false
    }
    
    private func stopActivityIndicator() {
        progressActivityIndicator.isHidden = true
    }
    
}
