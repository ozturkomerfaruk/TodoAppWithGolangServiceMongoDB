//
//  ForgotPasswordViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 27.03.2023.
//

import Foundation

protocol ForgotPasswordViewViewModelProtocol {
    func sendResetPasswordEmail(parameters: [String:Any])
}

protocol ForgotPasswordViewViewModelDelegate: AnyObject {
    func fetchLoaded(model: BaseModelStatus)
    func fetchFailed(error: Error)
    func preFetch()
}

final class ForgotPasswordViewViewModel {
    weak var delegate: ForgotPasswordViewViewModelDelegate?
    
    func sendResetPasswordEmail(parameters: [String:Any]) {
        delegate?.preFetch()
        
        Client.postSendResetPasswordEmail(parameters: parameters) { [weak self] model, error in
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
