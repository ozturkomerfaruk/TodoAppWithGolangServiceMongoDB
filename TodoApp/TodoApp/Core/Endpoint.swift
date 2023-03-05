//
//  Endpoint.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import Foundation

enum EndPoints {
    static private let baseUrl = "http://localhost:8080"
    
    case getTodos
    case postTodo
    case deleteTodo(String)
    
    var stringValue: String {
        switch self {
        case .getTodos:
            return EndPoints.baseUrl + "/api/todos"
        case .postTodo:
            return EndPoints.baseUrl + "/api/todo"
        case .deleteTodo(let id):
            return EndPoints.baseUrl + "/api/todo/delete/\(id)"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
