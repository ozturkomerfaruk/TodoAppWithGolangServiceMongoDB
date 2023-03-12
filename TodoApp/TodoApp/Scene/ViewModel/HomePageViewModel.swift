//
//  HomePageViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 6.03.2023.
//

import Foundation

protocol HomePageViewModelProtocol {
    func fetchAllTodos()
}

protocol HomePageViewModelDelegate: AnyObject {
    func fetchLoaded()
    func fetchFailed(error: Error)
    func preFetch()
}

final class HomePageViewModel {
    weak var delegate: HomePageViewModelDelegate?
    var todos = [TodoModel]()
    
    func fetchAllTodos() {
        self.delegate?.preFetch()
        Client.getTodos { models, error in
            if let todos = models {
                self.todos = todos
                self.delegate?.fetchLoaded()
            } else {
                self.delegate?.fetchFailed(error: error!)
            }
        }
    }
    
    func denasdk() {
        
        
        let parameters = [
            "title": "1231w2",
            "content": "qweqwesd"
        ]
        
        Client.postTodo(parameters: parameters)
        
        Client.deleteTodo(withId: "64042729873fb619b7bf6a40")
    }
}
