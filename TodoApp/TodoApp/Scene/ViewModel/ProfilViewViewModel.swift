//
//  ProfilViewViewModel.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 22.03.2023.
//

import Foundation

protocol ProfilViewViewModelProtocol {
    func postInsert()
}

protocol ProfilViewViewModelDelegate: AnyObject {
    func fetchLoaded()
    func fetchFailed(error: Error)
    func preFetch()
}

final class ProfilViewViewModel {
    weak var delegate: ProfilViewViewModelDelegate?
    private var isLoggedInValue = false
    private var userModel: UserModel?
    
    func userLogout() {
        self.delegate?.preFetch()
        DispatchQueue.main.async {
            Client.postLogoutUser()
        }
    }
    
    func fetchUserDetail() {
        delegate?.preFetch()
        Client.getDetailUserById() { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.userModel = model
                self.delegate?.fetchLoaded()
            }
        }
    }
    
    func getUserDetail() -> UserModel {
        return self.userModel ?? UserModel(id: "", username: "", password: "", mail: "", nameSurname: "", profilImage: nil)
    }
    
    func putTodoUpdate(parameters: [String:Any]) {
        delegate?.preFetch()
        
        Client.putUpdateUser(parameters: parameters) { [weak self] model, error in
            guard let self = self else { return }
            if let error {
                self.delegate?.fetchFailed(error: error)
            } else if let model = model {
                self.userModel = model
                self.delegate?.fetchLoaded()
            }
        } 
    }
    
    func prevUploadModel(nameSurname: String, profilImage: String) {
        let model = self.getUserDetail()
        print("aksdjkal")
        print(profilImage)
        // Güncelleme parametrelerini oluştur
        let parameter: [String: Any] = [
            "id": model.id ?? "",
            "username": model.username ?? "",
            "nameSurname": nameSurname == "" ? (model.nameSurname ?? "") : nameSurname,
            "password": model.password ?? "",
            "mail": model.mail ?? "",
            "profilImage": profilImage == "" ? (model.profilImage ?? "") : profilImage,
        ]
        
        // Güncelleme işlemini gerçekleştir
        self.putTodoUpdate(parameters: parameter)
    }
}
