//
//  GenericClient.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 21.03.2023.
//

import Foundation
import Alamofire
import KeychainAccess

class GenericClient {
    static func handleResponse<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        var headers: HTTPHeaders = [:]
        let keychain = Keychain(service: "tokenKeychainAccess")
        let token = keychain["tokenKeychainAccess"]
        headers["Authorization"] = "Bearer \(token ?? "")"
        
        AF.request(urlString, method: .get, headers: headers).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            let body = String(data: data!, encoding: .utf8)
            //debugPrint(body! as NSString)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    static func performPostRequest<T: Decodable>(urlString: String, parameters: Parameters? = nil, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        let keychain = Keychain(service: "tokenKeychainAccess")
        let token = keychain["tokenKeychainAccess"]
        
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    print("Success")
                    completion(data, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    
    static func performDeleteRequest<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        let keychain = Keychain(service: "tokenKeychainAccess")
        let token = keychain["tokenKeychainAccess"]
        
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        AF.request(urlString, method: .delete, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    print("Success")
                    completion(data, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil, error)
                }
            }
    }
    
    static func performPutRequest<T: Decodable>(urlString: String, parameters: Parameters, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        let keychain = Keychain(service: "tokenKeychainAccess")
        let token = keychain["tokenKeychainAccess"]
        
        var headers: HTTPHeaders = [:]
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        AF.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    print("Success")
                    completion(data, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil, error)
                }
            }
    }
}
