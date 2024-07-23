//
//  MVCServer.swift
//  FakeStore
//
//  Created by Abhishek on 23/07/24.
//

import Foundation
import Alamofire
import UIKit

class MVCServer: NSObject {
    
    // Computed property for the server URL
    var serverUrl: String {
        return baseURL
    }
    
    // Shared URLSession instance
    let sharedSession: URLSession = URLSession.shared
    
    // Show or hide network activity indicator and loading view
    func networkActivity(goingOn: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = goingOn
            goingOn ? Utility.showLoadingView() : Utility.hideLoadingView()
        }
    }
    
    // Create headers with or without token
//    func getHeaderWithToken(token: Bool, contentType: String = "application/x-www-form-urlencoded") -> HTTPHeaders {
//        if token {
//            return [
//                "Accept": "application/json",
//                "Authorization": "Bearer \(Access_token)"
//            ]
//        } else {
//            return [
//                "Accept": "application/json"
//            ]
//        }
//    }
    
    // Perform a network request with the given parameters
    func serviceRequestWithURL<T: Codable>(
        reqMethod: HTTPMethod,
        withUrl urlString: String,
        withParam postParam: [String: Any],
        expecting: T.Type,
        displayHud: Bool,
        includeToken: Bool,
        completion: @escaping (_ responseCode: Int, _ response: T?) -> Void
    ) {
        if displayHud {
            networkActivity(goingOn: true)
        }
        
        let requestURL = serverUrl + urlString
        print("Request URL:", requestURL)
        print("Parameters:", postParam)
        
        AF.request(requestURL, method: reqMethod, parameters: postParam, encoding: URLEncoding.default/*, headers: getHeaderWithToken(token: includeToken)*/)
            .responseDecodable(of: expecting) { response in
                if displayHud {
                    self.networkActivity(goingOn: false)
                }
                
                switch response.result {
                case .failure(let error):
                    print("Error:", error.localizedDescription)
                    
                    if let urlError = error.underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            SceneDelegate().sceneDelegate?.mainNav?.topViewController?.view.makeToast("Please, check your internet connection.", position: .top)
                        default:
                            break
                        }
                    }
                    completion(0, nil)
                    
                case .success(let result):
                    guard let httpResponse = response.response else {
                        completion(0, nil)
                        return
                    }
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        completion(1, result)
                    default:
                        completion(0, result)
                    }
                }
            }
    }
}
