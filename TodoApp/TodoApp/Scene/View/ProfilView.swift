//
//  ProfilView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class ProfilView: UIViewController {
    @IBOutlet private weak var profilImageView: UIImageView!
    @IBOutlet private weak var updateProfilPhotoButtonOutlet: UIButton!
    @IBOutlet private weak var profilNameLabel: UILabel!
    @IBOutlet private weak var changePasswordStackView: UIStackView!
    @IBOutlet private weak var settingsStackView: UIStackView!
    @IBOutlet private weak var logoutStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureProfilView()
    }

}

extension ProfilView {
    private func configureProfilView() {
        profilImageView.image = UIImage(named: "cv")
        profilImageView.layer.cornerRadius = profilImageView.frame.height / 2
        updateProfilPhotoButtonOutlet.layer.cornerRadius = updateProfilPhotoButtonOutlet.frame.height / 2
        
        let tapGestureChangePassword = UITapGestureRecognizer(target: self, action: #selector(pressedChangePassword))
        let tapGestureSettings = UITapGestureRecognizer(target: self, action: #selector(pressedSettings))
        let tapGestureLogout = UITapGestureRecognizer(target: self, action: #selector(pressedLogout))
        
        changePasswordStackView.addGestureRecognizer(tapGestureChangePassword)
        settingsStackView.addGestureRecognizer(tapGestureSettings)
        logoutStackView.addGestureRecognizer(tapGestureLogout)
    }
    
    @objc private func pressedChangePassword() {
        print("şifre değiştirme ekranı")
    }
    
    @objc private func pressedSettings() {
        print("ayarlar ekranı")
    }
    @objc private func pressedLogout() {
        print("logout ekranı")
    }
}
