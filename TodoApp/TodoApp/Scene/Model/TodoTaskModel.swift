//
//  TodoTaskModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 13.03.2023.
//

import Foundation

struct TodoTaskModel: Codable {
    let id, title, category, date: String?
    let startTime, endTime, content: String?
    let progress: Int?
}
