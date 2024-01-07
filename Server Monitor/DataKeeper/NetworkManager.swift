//
//  RequestManager.swift
//  Sophia
//
//  Created by 孔维锐 on 8/5/23.
//

import Foundation
import Alamofire
import Starscream


/**
 在这里发起网络请求。
 */
class NetworkManager: ObservableObject {

    // Shared instance of the network manager
    static let shared = NetworkManager()
    
    init() {
    }
    

    /// Send a network request
    /// - Parameters:
    ///   - api: The API to request
    ///   - dict: Request parameters
    ///   - silent: Whether to make a silent(hide loading indicators) request
    ///   - timeout: Request timeout interval
    ///   - completion: Completion block for successful request
    ///   - err_completion: Completion block for failed request
    func sendRequest(path: String,  timeout: Int = 30, completion: @escaping (Data) -> Void, err_completion: @escaping () -> Void = {}) {

        AF.request(path, method: .get, headers: HTTPHeaders.default){ urlRequest in
            urlRequest.timeoutInterval = Double(timeout)
        }
        .validate(contentType: ["application/json"])
        .response{ response in
            switch response.result {
            case .success(let val):
                switch response.response!.statusCode{
                case 200..<300:
                    completion(val!)
                    //print("\(path)数据请求成功")
                default:
                    err_completion()
                    break
                }
              
            case .failure(let error):
                err_completion()
                print(error)
            }
        }
    }

    
    /// Convert Data to NSDictionary
    /// - Parameter data: The data to convert
    /// - Returns: The converted NSDictionary
    func convertDataToNSDictionary(data: Data) -> NSDictionary? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = jsonObject as? NSDictionary {
                return dictionary
            }
        } catch {
            print("Error converting data to NSDictionary: \(error)")
        }
        
        return nil
    }
    
    /// Convert Data to Dictionary
    /// - Parameter data: The data to convert
    /// - Returns: The converted dictionary
    func convertDataToDictionary(data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = jsonObject as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Error converting data to Dictionary: \(error)")
        }
        
        return nil
    }
}
