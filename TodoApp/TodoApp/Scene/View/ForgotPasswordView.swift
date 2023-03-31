//
//  ForgotPasswordView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 26.03.2023.
//

import UIKit

final class ForgotPasswordView: UIViewController {
    
    private var viewModel = ForgotPasswordViewViewModel()
    
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForgotPasswordView()
    }
    
    private func configureForgotPasswordView() {
        viewModel.delegate = self
        emailTextField.disableAutocorrectionFeatures()
    }
    
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        if !emailTextField.text!.isEmpty {
            let param = [
                "mail": emailTextField.text ?? "nil"
            ]
            viewModel.sendResetPasswordEmail(parameters: param)
            dismiss(animated: true)
        } else {
            print("Doldur tirrek")
        }
    }
}

extension ForgotPasswordView: ForgotPasswordViewViewModelDelegate {
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
