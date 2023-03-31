//
//  CreateNewTaskViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 13.03.2023.
//

import Foundation
import Alamofire

protocol CreateNewTaskViewViewModelProtocol {
    func postInsert()
}

protocol CreateNewTaskViewViewModelDelegate: AnyObject {
    func fetchLoaded(model: TodoTaskModel)
    func fetchFailed(error: Error)
    func preFetch()
}

final class CreateNewTaskViewViewModel {
    weak var delegate: CreateNewTaskViewViewModelDelegate?
    var categoryList = ["Kişisel", "İş", "Eğitim", "Finans", "Sağlık", "Seyahat", "Yemek"]
    var createdModel: TodoTaskModel?
    
    func postInsert(parameters: Parameters) {
        delegate?.preFetch()
        Client.postInsert(parameters: parameters) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.delegate?.fetchLoaded(model: model)
                self.createdModel = model
            }
        }
        
    }
}
