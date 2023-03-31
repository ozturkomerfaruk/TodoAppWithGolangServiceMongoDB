//
//  TodoEndpoints.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import Foundation

enum TodoEndpoints {
    static private let baseTodoUrl = "http://localhost:8080/api/todo"
    
    case getTodoList
    case postInsert
    case deleteTodo(String)
    case deleteAll
    case detailTodoGetById(String)
    case update
    
    var stringValue: String {
        switch self {
        case .getTodoList:
            return TodoEndpoints.baseTodoUrl + "/todoList"
        case .postInsert:
            return TodoEndpoints.baseTodoUrl + "/insert"
        case .deleteTodo(let id):
            return TodoEndpoints.baseTodoUrl + "/delete/\(id)"
        case .deleteAll:
            return TodoEndpoints.baseTodoUrl + "/deleteAll"
        case .detailTodoGetById(let id):
            return TodoEndpoints.baseTodoUrl + "/detail/\(id)"
        case .update:
            return TodoEndpoints.baseTodoUrl + "/update"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
