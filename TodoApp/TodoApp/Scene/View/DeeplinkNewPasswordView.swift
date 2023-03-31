//
//  DeeplinkNewPasswordView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 29.03.2023.
//

import UIKit

final class DeeplinkNewPasswordView: UIViewController {
    
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var changePasswordOutlet: UIButton!
    
    var viewModel = DeeplinkNewPasswordViewViewModel()
    var mail = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }
    
    @IBAction private func changePasswordAction(_ sender: Any) {
        if newPasswordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty {
            print("Boş Olamaz")
        } else {
            if newPasswordTextField.text == confirmPasswordTextField.text {
                let param = [
                    "mail": self.mail,
                    "newPassword": confirmPasswordTextField.text ?? ""
                ]
                viewModel.changePasswordDeeplink(parameters: param)
                let vc = storyboard?.instantiateViewController(withIdentifier: "loginRegisterView") as! LoginRegisterView
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                present(vc, animated: true, completion: nil)
            } else {
                print("Şifreler aynı olmalı")
            }
        }
    }
    
}

extension DeeplinkNewPasswordView: DeeplinkNewPasswordViewViewModelDelegate {
    func fetchLoaded(model: BaseModelStatus) {
        print(model)
    }
    
    func fetchFailed(error: Error) {
        print(String(describing: error))
    }
    
    func preFetch() {
        print("pre")
    }
}
