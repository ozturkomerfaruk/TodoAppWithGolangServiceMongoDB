//
//  todoModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import Foundation

struct TodoModel: Codable {
    let id, title, content: String?
}

typealias TodoModelArray = [TodoModel]
