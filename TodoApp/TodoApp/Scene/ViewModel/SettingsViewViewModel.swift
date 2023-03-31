//
//  SettingsViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 31.03.2023.
//

import Foundation

protocol SettingsViewViewModelProtocol {
    func updateMail(parameters: [String:Any])
}

protocol SettingsViewViewModelDelegate: AnyObject {
    func fetchLoaded(model: UserModel)
    func fetchFailed(error: Error)
    func preFetch()
}

final class SettingsViewViewModel {
    weak var delegate: SettingsViewViewModelDelegate?
    
    func updateMail(parameters: [String:Any]) {
        delegate?.preFetch()
        
        Client.putUpdateUser(parameters: parameters) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.delegate?.fetchLoaded(model: model)
            }
        }
    }
}
