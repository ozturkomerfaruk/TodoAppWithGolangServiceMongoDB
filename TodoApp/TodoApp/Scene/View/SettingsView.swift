//
//  SettingsView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 31.03.2023.
//

import UIKit

final class SettingsView: BaseView {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    var viewModel = SettingsViewViewModel()
    var model: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        emailTextField.disableAutocorrectionFeatures()
        if model!.mail!.isEmpty {
            emailTextField.text = ""
        } else {
            emailTextField.text = model?.mail
        }
    }
    
    @IBAction func saveYourMailAction(_ sender: Any) {
        if emailTextField.text!.isEmpty {
            showAlert(title: "Warning!", message: "Cannot be empty!")
        } else {
            let id = model?.id ?? ""
            let username = model?.username ?? ""
            let nameSurname = model?.mail ?? ""
            let password = model?.password ?? ""
            let mail = emailTextField.text ?? ""
            let profilImage = model?.profilImage ?? ""
            
            let param = [
                "id": id,
                "username": username,
                "nameSurname": nameSurname,
                "password": password,
                "mail": mail,
                "profilImage": profilImage
            ]
            
            viewModel.updateMail(parameters: param)
        }
    }

}

extension SettingsView: SettingsViewViewModelDelegate {
    func fetchLoaded(model: UserModel) {
        print(model)
    }
    
    func fetchFailed(error: Error) {
        print(String(describing: error))
    }
    
    func preFetch() {
        print("pre")
    }
    
    
}
