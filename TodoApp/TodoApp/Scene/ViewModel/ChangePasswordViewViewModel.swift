//
//  ChangePasswordViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 26.03.2023.
//

import Foundation

protocol ChangePasswordViewViewModelProtocol {
    func updateChangePassword(parameters: [String:Any])
}

protocol ChangePasswordViewViewModelDelegate: AnyObject {
    func fetchLoaded(model: BaseModelStatus)
    func fetchFailed(error: Error)
    func preFetch()
}

final class ChangePasswordViewViewModel {
    weak var delegate: ChangePasswordViewViewModelDelegate?
    
    func updateChangePassword(parameters: [String:Any]) {
        delegate?.preFetch()
        Client.putUpdateUserChangePassword(parameters: parameters) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.delegate?.fetchLoaded(model: model)
            }
        }
    }
    
}
