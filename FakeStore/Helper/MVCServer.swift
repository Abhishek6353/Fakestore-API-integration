//
//  MVCServer.swift
//  FakeStore
//
//  Created by Abhishek on 23/07/24.
//

import Foundation
import Alamofire
import UIKit

import Foundation
import Alamofire
import UIKit


class MVCServer: NSObject {
    
    let Access_token = ""
    
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
    func getHeaders(includeToken: Bool, contentType: String = "application/json") -> HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]
        
        if includeToken {
            headers["Authorization"] = "Bearer \(Access_token)"
        }
        
        headers["Content-Type"] = contentType
        return headers
    }
    
    // Perform a network request with the given parameters
    func serviceRequestWithURL<T: Codable>(
        reqMethod: HTTPMethod,
        withUrl urlString: String,
        withParam postParam: [String: Any],
        expecting: T.Type,
        displayHud: Bool,
        includeToken: Bool,
        completion: @escaping (_ responseCode: Int?, _ response: T?, _ error: NetworkError?) -> Void
    ) {
        if displayHud {
            networkActivity(goingOn: true)
        }
        
        let requestURL = serverUrl + urlString
        print("Request URL:", requestURL)
        print("Parameters:", postParam)
        
        let headers = getHeaders(includeToken: includeToken)
        
        AF.request(requestURL, method: reqMethod, parameters: postParam, encoding: URLEncoding.default, headers: headers)
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
                            completion(nil, nil, .noInternetConnection)
                        default:
                            completion(nil, nil, .unknownError(message: error.localizedDescription))
                        }
                    } else {
                        completion(nil, nil, .unknownError(message: error.localizedDescription))
                    }
                    
                case .success(let result):
                    guard let httpResponse = response.response else {
                        completion(nil, nil, .unknownError(message: "No response from server."))
                        return
                    }
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        completion(httpResponse.statusCode, result, nil)
                    case 401:
                        completion(httpResponse.statusCode, nil, .serverError(message: "Unauthorized access. Please log in again."))
                    case 403:
                        completion(httpResponse.statusCode, nil, .serverError(message: "Forbidden access."))
                    case 404:
                        completion(httpResponse.statusCode, nil, .serverError(message: "Resource not found."))
                    case 500...599:
                        completion(httpResponse.statusCode, nil, .serverError(message: "Server error occurred."))
                    default:
                        let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                        completion(httpResponse.statusCode, nil, .serverError(message: message))
                    }
                }
            }
    }
    
}



// Enum for network errors, providing localized descriptions
enum NetworkError: Error {
    case noInternetConnection
    case serverError(message: String)
    case decodingError
    case unknownError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection. Please check your network settings."
        case .serverError(let message):
            return "Server Error (\(message)"
        case .decodingError:
            return "Failed to decode the response. Please try again."
        case .unknownError(let message):
            return "Unknown Error: \(message)"
        }
    }
}
