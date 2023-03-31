//
//  Client.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import Foundation
import Alamofire
import KeychainAccess

final class Client {
    static func getTodoList(completion: @escaping (TodoBaseModelToList?, Error?) -> Void) {
        let urlString = TodoEndpoints.getTodoList.stringValue
        GenericClient.handleResponse(urlString: urlString, responseType: TodoBaseModelToList.self) { responseModel, error in
            completion(responseModel, error)
        }
    }
    
    static func getDetailTodoById(withId id: String, completion: @escaping (TodoTaskModel?, Error?) -> Void) {
        let urlString = TodoEndpoints.detailTodoGetById(id).stringValue
        GenericClient.handleResponse(urlString: urlString,
                                     responseType: TodoBaseModelToCreate.self) { responseModel, error in
            completion(responseModel?.result, error)
        }
    }
    
    static func postInsert(parameters: Parameters, completion: @escaping (TodoTaskModel?, Error?) -> Void) {
        let urlString = TodoEndpoints.postInsert.stringValue
        GenericClient.performPostRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: TodoBaseModelToCreate.self) { model, error in
                completion(model?.result, error)
        }
    }
    
    static func deleteTodo(withId id: String, completion: @escaping (BaseModelStatus?, Error?) -> Void) {
        let urlString = TodoEndpoints.deleteTodo(id).stringValue
        GenericClient.performDeleteRequest(
            urlString: urlString,
            responseType: BaseModelStatus.self) { model, error in
                completion(model, error)
            }
    }
    
    static func deleteAll(withId id: String) {
        let urlString = TodoEndpoints.deleteAll.stringValue
        GenericClient.performDeleteRequest(
            urlString: urlString,
            responseType: BaseModelStatus.self) { model, error in
                print(model?.message ?? "nil")
            }
    }
    
    static func putUpdateTodo(parameters: Parameters, completion: @escaping (TodoTaskModel?, Error?) -> Void) {
        let urlString = TodoEndpoints.update.stringValue
        GenericClient.performPutRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: TodoTaskModel.self) { model, error in
                completion(model, error)
            }
    }
    
    static func postLoginUser(parameters: Parameters, completion: @escaping (UserLoginModel?, Error?) -> Void) {
        let urlString = UserEndpoints.postLoginUser.stringValue
        GenericClient.performPostRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: UserLoginModel.self) { model, error in
                completion(model, error)
            }
    }
    
    static func postRegisterUser(parameters: Parameters) {
        let urlString = UserEndpoints.postRegisterUser.stringValue
        GenericClient.performPostRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: UserLoginModel.self) { model, error in
                print(model?.message ?? "nil register")
            }
    }
    
    static func postLogoutUser() {
        let urlString = UserEndpoints.postLogoutUser.stringValue
        GenericClient.performPostRequest(
            urlString: urlString,
            parameters: nil,
            responseType: UserLoginModel.self) { model, error in
                print(model?.message ?? "nil logout")
            }
        let keychain = Keychain(service: "tokenKeychainAccess")
        keychain["tokenKeychainAccess"] = ""
        keychain["userId"] = ""
    }
    
    static func getDetailUserById(completion: @escaping (UserModel?, Error?) -> Void) {
        let keychain = Keychain(service: "tokenKeychainAccess")
        let id = keychain["userId"]
        let urlString = UserEndpoints.getUserDetail(id ?? "").stringValue
        GenericClient.handleResponse(urlString: urlString,
                                     responseType: UserBaseModel.self) { responseModel, error in
            completion(responseModel?.result, error)
        }
    }
    
    static func putUpdateUser(parameters: [String: Any], completion: @escaping (UserModel?, Error?) -> Void) {
        let urlString = UserEndpoints.updateUser.stringValue
        GenericClient.performPutRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: UserBaseModel.self) { model, error in
                completion(model?.result, error)
            }
    }
    
    static func putUpdateUserChangePassword(parameters: [String: Any], completion: @escaping (BaseModelStatus?, Error?) -> Void) {
        let urlString = UserEndpoints.changePassword.stringValue
        GenericClient.performPutRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: BaseModelStatus.self) { model, error in
                completion(model, error)
            }
    }
    
    static func postSendResetPasswordEmail(parameters: Parameters, completion: @escaping (BaseModelStatus?, Error?) -> Void) {
        let urlString = UserEndpoints.sendResetPasswordEmail.stringValue
        GenericClient.performPostRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: BaseModelStatus.self) { model, error in
                completion(model, error)
            }
    }
    
    static func postChangePasswordDeeplink(parameters: Parameters, completion: @escaping (BaseModelStatus?, Error?) -> Void) {
        let urlString = UserEndpoints.changePasswordDeeplink.stringValue
        GenericClient.performPostRequest(
            urlString: urlString,
            parameters: parameters,
            responseType: BaseModelStatus.self) { model, error in
                completion(model, error)
            }
    }
}
