//
//  TaskDetailViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 16.03.2023.
//

import Foundation
import Alamofire

protocol TaskDetailViewViewModelProtocol {
    func postInsert()
}

protocol TaskDetailViewViewModelDelegate: AnyObject {
    func fetchLoaded()
    func afterPutTodo()
    func fetchFailed(error: Error)
    func preFetch()
}

final class TaskDetailViewViewModel {
    weak var delegate: TaskDetailViewViewModelDelegate?
    private var detailModel: TodoTaskModel?
    
    func getTodoTask(id: String) {
        delegate?.preFetch()
        Client.getDetailTodoById(withId: id) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.delegate?.fetchLoaded()
                self.detailModel = model
            }
        }
    }
    
    func getDetailModel() -> TodoTaskModel {
        return self.detailModel!
    }
    
    func putTodoUpdate(id: String, parameters: Parameters) {
        delegate?.preFetch()
        
        Client.putUpdateTodo(parameters: parameters) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.detailModel = model
                self.delegate?.afterPutTodo()
            }
        }
    }
}
