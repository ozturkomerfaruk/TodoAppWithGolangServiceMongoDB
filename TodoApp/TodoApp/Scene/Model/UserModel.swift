//
//  UserModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 20.03.2023.
//

import Foundation

struct UserModel: Codable {
    let id, username, password, mail, nameSurname, profilImage: String?
}
