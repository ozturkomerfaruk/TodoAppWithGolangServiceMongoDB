//
//  LoginRegisterViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 22.03.2023.
//

import Foundation
import KeychainAccess

protocol LoginRegisterViewViewModelProtocol {
    func postInsert()
}

protocol LoginRegisterViewViewModelDelegate: AnyObject {
    func fetchLoaded(_ isLoggedValue: Bool)
    func fetchFailed(error: Error)
    func preFetch()
}

final class LoginRegisterViewViewModel {
    weak var delegate: LoginRegisterViewViewModelDelegate?
    private var isLoggedInValue = false

    func loginUser(parameter: [String: Any]) {
        self.delegate?.preFetch()
        Client.postLoginUser(parameters: parameter) { data, error in
            if let error {
                self.delegate?.fetchFailed(error: error)
                self.isLoggedInValue = false
            } else {
                if data?.status == 200 {
                    let keychain = Keychain(service: "tokenKeychainAccess")
                    keychain["tokenKeychainAccess"] = data?.token
                    keychain["userId"] = data?.userId
                    print("Giriş Yapıldı ve Token Oluşturuldu")
                    print(data?.token ?? "nil")
                    self.isLoggedInValue = true
                }
            }
            self.delegate?.fetchLoaded(self.isLoggedInValue)
        }
    }
    
    func registerUser(parameter: [String: Any]) {
        Client.postRegisterUser(parameters: parameter)
    }
}
