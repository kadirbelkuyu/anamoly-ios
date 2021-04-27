//
//  APIManager.swift
//  BaseProject
//
//  Created by MAC240 on 04/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import Foundation
import Alamofire


class APIManager {

    /// Custom header field
    var header  =   [
                        "Content-Type"      : "application/x-www-form-urlencoded",
                        "X-API-KEY"         : "99e1bb00b05ec7b10343b92815a2e7f4",
                        "X-APP-LANGUAGE"    : appLanguage.APIHeaderTitle,
                        "X-App-Language"    : appLanguage.APIHeaderTitle,
                        "X-APP-DEVICE"      : "ios",
                        "X-APP-VERSION"     : "1"
                    ]

    static let shared:APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    let sessionManager:SessionManager
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func setHeader() {
        header  =   [
                        "Content-Type"      : "application/x-www-form-urlencoded",
                        "X-API-KEY"         : "99e1bb00b05ec7b10343b92815a2e7f4",
                        "X-APP-LANGUAGE"    : appLanguage.APIHeaderTitle,
                        "X-APP-DEVICE"      : "ios",
                        "X-APP-VERSION"     : "1"
                    ]
    }
    
    /// Set Bearer token with this method
    func setToken(authorizeToken : String) {
        self.header["Authorization"] = "Bearer \(authorizeToken)"
    }
    
    /// Remove Bearer token with this method
    func removeAuthorizeToken() {
        self.header.removeValue(forKey: "Authorization")
    }
    
    func callRequest(path : String, onSuccess success: @escaping (_ response: BaseResponse) -> Void, onFailure failure: @escaping (_ error: APICallError) -> Void) {
        
        guard SApplication.shared.reachability.isReachable == true else {
            let apiError = APICallError(status: .offline)
            failure(apiError)
            return
        }

//        let path = router.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
//
//        var parameter = router.parameters
//        if router.parameters == nil {
//            parameter = [:]
//        }
//      
        print("Method \t : \(path)")
        print("Header \t : \(header)")
        print("Path \t : \(path)")

        self.sessionManager.request(path, method: .get, parameters: [:], encoding: URLEncoding.default, headers: header).responseJSON { response  in
            
            switch response.result {
            case .success:
                let apiResponse = BaseResponse(response: response)
                if apiResponse.success {
                    success(apiResponse)
                    print("Response \t : \(String(describing: apiResponse.data))")
                } else {
                    let apiError = APICallError(status: .failed)
                    apiError.message = apiResponse.message!
                    failure(apiError)
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                let apiError = APICallError(status: .failed)
                failure(apiError)
                break
            }
        }
        
    }
  
    func callRequestWithMultipartData(_ router: APIRouter, arrImages: [UIImage]?, onSuccess success: @escaping (_ response: BaseResponse) -> Void, onFailure failure: @escaping (_ error: APICallError) -> Void) {
        
        let path = router.path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        
        var parameter = router.parameters
        if router.parameters == nil {
            parameter = [:]
        }
        
//        let headers: HTTPHeaders = [
//             "Authorization": "your_access_token",  in case you need authorization header 
//            "Authorization": self.header["Authorization"]!,
//            "Content-type": "multipart/form-data"
//        ]
        
        print("Method \t : \(router.method)")
        print("Header \t : \(header)")
        print("Path \t : \(path ?? "")")
        print("Parameter \t : \(parameter ?? [:])")
        self.sessionManager.upload(multipartFormData: { multipartFormData in
            
            for image in arrImages! {
                if let imageData = image.pngData() {
                    if path ?? "" == BaseURL + "/index.php/rest/products/suggest" {
                        multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
                    } else {
                        multipartFormData.append(imageData, withName: "user_image", fileName: "user_image.png", mimeType: "image/png")
                    }
                }
            }
            
            for (key, value) in parameter! {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        },
        usingThreshold: UInt64.init(),
        to: path!,
        method: router.method,
        headers: header,
        encodingCompletion: { encodingResult  in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        let apiResponse = BaseResponse(response: response)
                        if apiResponse.success {
                            print("Response \t : \(String(describing: apiResponse.data))")
                            success(apiResponse)
                        } else {
                            print("Response \t : \(response)")
                            let apiResponse = BaseResponse(response: response)
                            if apiResponse.status == 108 || apiResponse.status == 106 || apiResponse.status == 105 {
                                success(apiResponse)
                            } else {
                                let apiError = APICallError(status: .failed)
                                apiError.message = apiResponse.message!
                                failure(apiError)
                            }
                        }
                        break
                    case .failure(let error):
                        print("Response \t : \(response)")
                        let apiError = APICallError(status: .failed)
                        failure(apiError)
                        print("Error: \(error)")
                        break
                    }
                })
                
//                upload.responseString { response in
//                    debugPrint(response)
//                    }
//                    .uploadProgress { progress in // main queue by default
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                }
                return
            case .failure(let encodingError):
                debugPrint(encodingError)
                let apiError = APICallError(status: .failed)
                failure(apiError)
            }
        })
        
    }
    
    //MARK:- Cancel Requests
    
    func cancelAllTasks() {
        self.sessionManager.session.getAllTasks { tasks in
            tasks.forEach {
                $0.cancel()
            }
        }
    }
    
    func cancelRequests(url: String) {
        self.sessionManager.session.getTasksWithCompletionHandler
            {
                (dataTasks, uploadTasks, downloadTasks) -> Void in
                
                self.cancelTasksByUrl(tasks: dataTasks     as [URLSessionTask], url: url)
                self.cancelTasksByUrl(tasks: uploadTasks   as [URLSessionTask], url: url)
                self.cancelTasksByUrl(tasks: downloadTasks as [URLSessionTask], url: url)
        }
    }
    
    private func cancelTasksByUrl(tasks: [URLSessionTask], url: String) {
        
        for task in tasks {
            if task.currentRequest?.url?.absoluteString == url {
                task.cancel()
            }
        }
    }
    
}
