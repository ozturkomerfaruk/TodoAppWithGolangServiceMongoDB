//
//  LoginRegisterView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 22.03.2023.
//

import UIKit

final class LoginRegisterView: BaseView {
    
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var forgottenPasswordLabel: UILabel!
    @IBOutlet private weak var SaveButtonOutlet: UIButton!
    @IBOutlet private weak var createNewAccountLabel: UILabel!
    @IBOutlet private weak var backIconImageView: UIImageView!
    
    private let gradientLayer = CAGradientLayer()
    private var isRegisterView = false
    private var isLoggedValue = true
    private var viewModel = LoginRegisterViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLoginRegisterView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Başlangıçta circleView görünür olmalı
        self.circleView.alpha = 1.0

        // Arka plan rengi animasyonu
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.circleView.backgroundColor = UIColor.systemBlue
        }, completion: nil)

        // Alpha değeri animasyonu
        UIView.animate(withDuration: 1.5, delay: 1.5, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.circleView.alpha = 0.0
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureBackgroundColor()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(title: "Warning!", message: "It cannot be empty!")
        } else {
            let parameter = [
                "username": usernameTextField.text!,
                "password": passwordTextField.text!,
            ] as [String : Any]
            
            if self.isRegisterView  {
                self.viewModel.registerUser(parameter: parameter)
                showAlert(title: "Successful!", message: "Successfully created user. You can login.")
                isRegisterView.toggle()
                loginLabel.text = "Login"
                forgottenPasswordLabel.isHidden = false
                backIconImageView.isHidden = true
                SaveButtonOutlet.setTitle("Login", for: .normal)
                createNewAccountLabel.text = "Create A New Account"
            } else {
                self.viewModel.loginUser(parameter: parameter)
            }
        }
        
    }
    
    @objc private func forgottenPassword() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "forgotPasswordView") as? ForgotPasswordView else { return }
        present(vc, animated: true)
    }
    
    @objc private func createNewAccount() {
        isRegisterView.toggle()
        if isRegisterView {
            loginLabel.text = "Register"
            forgottenPasswordLabel.isHidden = true
            SaveButtonOutlet.setTitle("Register", for: .normal)
            backIconImageView.isHidden = false
            createNewAccountLabel.text = "Back"
        } else {
            loginLabel.text = "Login"
            forgottenPasswordLabel.isHidden = false
            backIconImageView.isHidden = true
            SaveButtonOutlet.setTitle("Login", for: .normal)
            createNewAccountLabel.text = "Create A New Account"
        }
        
    }
    
}

extension LoginRegisterView {
    private func configureLoginRegisterView() {
        viewModel.delegate = self
        backIconImageView.isHidden = true
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleView.backgroundColor = .blue
        
        usernameTextField.disableAutocorrectionFeatures()
        passwordTextField.disableAutocorrectionFeatures()
        forgottenPasswordLabel.isUserInteractionEnabled = true 
        createNewAccountLabel.isUserInteractionEnabled = true
        let tapGestureForgottenPassword = UITapGestureRecognizer(target: self, action: #selector(forgottenPassword))
        forgottenPasswordLabel.addGestureRecognizer(tapGestureForgottenPassword)
        let tapGestureCreateNewAccount = UITapGestureRecognizer(target: self, action: #selector(createNewAccount))
        createNewAccountLabel.addGestureRecognizer(tapGestureCreateNewAccount)
        
        SaveButtonOutlet.layer.cornerRadius = 12
        
    }
    
    private func configureBackgroundColor() {
        // Gradient rengi
        let startColor = UIColor.systemBlue.cgColor
        let endColor = UIColor.black.cgColor
        
        // Gradient rengi ayarları
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        // Gradient animasyon ayarları
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.fromValue = [startColor, endColor]
        gradientAnimation.toValue = [endColor, startColor]
        gradientAnimation.duration = 2
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity
        
        // Gradient rengini view'a ekleme
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Gradient animasyonunu başlatma
        gradientLayer.add(gradientAnimation, forKey: "gradientAnimation")
    }
}

extension LoginRegisterView: LoginRegisterViewViewModelDelegate {
    func fetchLoaded(_ isLoggedValue: Bool) {
        print("loaded")
        self.isLoggedValue = isLoggedValue
        
        print(self.isLoggedValue)
        
        if self.isLoggedValue {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as?  TabBarController else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            showAlert(title: "Warning!", message: "Username or Password is incorrect!")
        }
    }
    
    func fetchFailed(error: Error) {
        print(error)
    }
    
    func preFetch() {
        print("pre")
    } 
}
