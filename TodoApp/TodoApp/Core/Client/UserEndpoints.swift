//
//  UserEndpoints.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 20.03.2023.
//

import Foundation

enum UserEndpoints {
    static private let baseUserUrl = "http://localhost:8080/api/user"
    
    case postRegisterUser
    case postLoginUser
    case postLogoutUser
    case getUserDetail(String)
    case deleteUser(String)
    case deleteAllUser
    case getUserList
    case updateUser
    case changePassword
    case sendResetPasswordEmail
    case changePasswordDeeplink
    
    var stringValue: String {
        switch self {
        case .postRegisterUser:
            return UserEndpoints.baseUserUrl + "/register"
        case .postLoginUser:
            return UserEndpoints.baseUserUrl + "/login"
        case .postLogoutUser:
            return UserEndpoints.baseUserUrl + "/logout"
        case .getUserDetail(let id):
            return UserEndpoints.baseUserUrl + "/detail/\(id)"
        case .deleteUser(let id):
            return UserEndpoints.baseUserUrl + "/delete/\(id)"
        case .deleteAllUser:
            return UserEndpoints.baseUserUrl + "/deleteAll"
        case .getUserList:
            return UserEndpoints.baseUserUrl + "/userList"
        case .updateUser:
            return UserEndpoints.baseUserUrl + "/update"
        case .changePassword:
            return UserEndpoints.baseUserUrl + "/changePassword"
        case .sendResetPasswordEmail:
            return UserEndpoints.baseUserUrl + "/sendResetPasswordEmail"
        case .changePasswordDeeplink:
            return UserEndpoints.baseUserUrl + "/changePasswordDeeplink"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
