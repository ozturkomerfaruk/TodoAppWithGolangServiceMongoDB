//
//  DeeplinkNewPasswordViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 29.03.2023.
//

import Foundation

protocol DeeplinkNewPasswordViewViewModelProtocol {
    func changePasswordDeeplink(parameters: [String:Any])
}

protocol DeeplinkNewPasswordViewViewModelDelegate: AnyObject {
    func fetchLoaded(model: BaseModelStatus)
    func fetchFailed(error: Error)
    func preFetch()
}

final class DeeplinkNewPasswordViewViewModel {
    weak var delegate: DeeplinkNewPasswordViewViewModelDelegate?
    
    func changePasswordDeeplink(parameters: [String:Any]) {
        Client.postChangePasswordDeeplink(parameters: parameters) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.delegate?.fetchLoaded(model: model)
                print(model)
            }
        }
    }
}
