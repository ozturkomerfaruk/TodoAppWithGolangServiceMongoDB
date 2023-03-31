//
//  TodoBaseModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import Foundation

struct TodoBaseModelToList: Codable {
    let status: Int?
    let message: String?
    let count: Int?
    let progressPercent: Double?
    let countToday: Int?
    let progressPercentToday: Double?
    let result: [TodoTaskModel]?
}

struct TodoBaseModelToCreate : Codable {
    let status: Int?
    let message: String?
    let result: TodoTaskModel?
}

struct BaseModelStatus: Codable {
    let status: Int?
    let message: String?
}

struct UserBaseModel : Codable {
    let status: Int?
    let message: String?
    let result: UserModel?
}
