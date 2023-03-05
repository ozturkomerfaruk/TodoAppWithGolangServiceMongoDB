//
//  Client.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import Foundation
import Alamofire

final class Client {
    static private func handleResponse<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        AF.request(urlString).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
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
    
    static func getTodos(completion: @escaping (TodoModelArray?, Error?) -> Void) {
        let urlString = EndPoints.getTodos.stringValue
        handleResponse(urlString: urlString, responseType: [TodoModel].self) { responseModel, error in
            completion(responseModel, error)
        }
    }
    
    static func postTodo(parameters: Parameters) {
        let urlString = EndPoints.postTodo.stringValue
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: TodoModel.self) { response in
                switch response.result {
                case .success(let data):
                    print("Success: \(data)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    static func deleteTodo(withId id: String) {
        let urlString = EndPoints.deleteTodo(id).stringValue
        AF.request(urlString, method: .delete)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    print("Success: \(response)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
