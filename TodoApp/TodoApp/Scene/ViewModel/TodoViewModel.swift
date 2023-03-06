//
//  TodoViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 6.03.2023.
//

import Foundation

protocol HomePageViewModelProtocol {
    func fetchWeather(lat: Double, long: Double)
}

protocol HomePageViewModelDelegate: AnyObject {
    func fetchLoaded()
}

final class TodoViewModel {
    weak var delegate: HomePageViewModelDelegate?
    var todoModel: TodoModel?
    
    func denasdk() {
        Client.getTodos { models, error in
            if let todos = models {
                for todo in todos {
                    if let title = todo.title {
                        print(title)
                    }
                }
            } else {
                print("Error fetching todos: \(error?.localizedDescription ?? "unknown error")")
            }
        }
        
        let parameters = [
            "title": "1231w2",
            "content": "qweqwesd"
        ]
        
        Client.postTodo(parameters: parameters)
         
        Client.deleteTodo(withId: "64042729873fb619b7bf6a40")
    }
}
