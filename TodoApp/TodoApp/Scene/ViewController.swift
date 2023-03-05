//
//  ViewController.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let parameters = [
        "title": "1231w2",
        "content": "qweqwesd"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        Client.postTodo(parameters: self.parameters)
         
        Client.deleteTodo(withId: "64042729873fb619b7bf6a40")
    }
}

