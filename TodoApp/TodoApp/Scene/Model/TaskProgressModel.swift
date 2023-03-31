//
//  TaskProgressModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 17.03.2023.
//

import Foundation

struct TaskProgressModel: Codable {
    let isTitleToday: Bool
    let taskCount: Int?
    let progressPercent: Double?
}
