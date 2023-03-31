//
//  ChangePasswordView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 26.03.2023.
//

import UIKit

final class ChangePasswordView: UIViewController {
    
    
    @IBOutlet private weak var profilImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var oldPassword: UITextField!
    @IBOutlet private weak var newPassword: UITextField!
    @IBOutlet private weak var confirmPassword: UITextField!
    @IBOutlet private weak var changePasswordOutlet: UIButton!
    @IBOutlet private weak var forgotPasswordLabel: UILabel!
    
    var userModel: UserModel?
    var viewModel = ChangePasswordViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureChangePasswordView()
    }

    private func configureChangePasswordView() {
        self.viewModel.delegate = self
        self.oldPassword.disableAutocorrectionFeatures()
        self.newPassword.disableAutocorrectionFeatures()
        self.confirmPassword.disableAutocorrectionFeatures()
        
        guard let model = userModel, let image = model.profilImage, let imageData = Data(base64Encoded: image), let image = UIImage(data: imageData) else { return }
        self.profilImageView.image = image
        usernameLabel.text = model.username
        
        profilImageView.layer.cornerRadius = profilImageView.frame.height / 2
        changePasswordOutlet.layer.cornerRadius = 12
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGestureForgotPassword = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordSelector))
        forgotPasswordLabel.addGestureRecognizer(tapGestureForgotPassword)
    }
    
    @objc private func forgetPasswordSelector() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "forgotPasswordView") as? ForgotPasswordView else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func changePasswordAction(_ sender: Any) {
        if oldPassword.text!.isEmpty || newPassword.text!.isEmpty || confirmPassword.text!.isEmpty {
            print("Boş Olamaz!")
        } else {
            if newPassword.text == confirmPassword.text {
                let parameter: [String : Any] = [
                    "userId": userModel?.id ?? "",
                    "oldPassword": oldPassword.text ?? "",
                    "newPassword": newPassword.text ?? ""
                ]
                self.viewModel.updateChangePassword(parameters: parameter)
            } else {
                print("Şifreler eşleşmiyor.")
            }
        }
    }
}

extension ChangePasswordView: ChangePasswordViewViewModelDelegate {
    func fetchLoaded(model: BaseModelStatus) {
        print(model)
        oldPassword.text = ""
        newPassword.text = ""
        confirmPassword.text = ""
    }
    
    func fetchFailed(error: Error) {
        print(String(describing: error))
    }
    
    func preFetch() {
        print("pre")
    }
}
