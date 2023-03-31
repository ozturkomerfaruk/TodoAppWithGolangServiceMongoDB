//
//  UserLoginModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 20.03.2023.
//

import Foundation

struct UserLoginModel: Codable {
    let status: Int?
    let message, token, userId: String?
}
