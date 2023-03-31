//
//  ProfilView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit
final class ProfilView: UIViewController {
    private var timer: Timer? // Zamanlayıcı nesnesi tanımlanıyor. TextField için
    @IBOutlet private weak var profilImageView: UIImageView!
    @IBOutlet private weak var updateProfilPhotoButtonOutlet: UIButton!
    @IBOutlet private weak var profilNameTextField: UITextField!
    @IBOutlet private weak var changePasswordStackView: UIStackView!
    @IBOutlet private weak var settingsStackView: UIStackView!
    @IBOutlet private weak var logoutStackView: UIStackView!
    
    private var viewModel = ProfilViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureProfilView()
    }
    
    @IBAction func updateProfilPhotoButtonAction(_ sender: Any) {
        self.showPhotoAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchUserDetail()
    }

}

extension ProfilView {
    private func configureProfilView() {
        viewModel.delegate = self
        profilNameTextField.delegate = self
        if self.profilImageView.image == nil {
            self.profilImageView.image = UIImage(named: "person")
        }
        self.profilNameTextField.textColor = UIColor.black
        if self.profilNameTextField.text == "" {
            self.profilNameTextField.placeholder = "İsminizi giriniz"
        }
        
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
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "changePasswordView") as? ChangePasswordView else { return }
        vc.userModel = viewModel.getUserDetail()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func pressedSettings() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "settingsView") as? SettingsView else { return }
        vc.model = viewModel.getUserDetail()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func pressedLogout() {
        print("logout ekranı")
        viewModel.userLogout()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "loginRegisterView") as?  UIViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension ProfilView: ProfilViewViewModelDelegate {
    func fetchLoaded() {
        let model = viewModel.getUserDetail()
        title = model.username
        profilNameTextField.text = model.nameSurname
        
        guard let image = model.profilImage, let imageData = Data(base64Encoded: image), let image = UIImage(data: imageData) else { return }
        self.profilImageView.image = image
    }
    
    func fetchFailed(error: Error) {
        print(error)
    }
    
    func preFetch() {
        print("pre")
    }
}

extension ProfilView: UITextFieldDelegate {
    // Klavye 'return' tuşuna basıldığında çağrılan fonksiyon
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Klavyeyi kapat
        return true
    }
    
    // TextField içindeki değer değiştiğinde çağrılan fonksiyon
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer?.invalidate() // Eğer zamanlayıcı çalışıyorsa, iptal et
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateUserDetails), userInfo: nil, repeats: false)
        return true
    }
    
    // TextField düzenlemesi bittiğinde çağrılan fonksiyon
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 3 saniye sonra updateUserDetails fonksiyonunu çağıracak zamanlayıcıyı başlat
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateUserDetails), userInfo: nil, repeats: false)
    }
    
    // Kullanıcı detaylarını güncelleme işlemini gerçekleştiren fonksiyon
    @objc func updateUserDetails() {
        self.viewModel.prevUploadModel(nameSurname: self.profilNameTextField.text ?? "", profilImage: "")
    }
}

extension ProfilView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Image Not Found!")
            return
        }
        profilImageView.image = image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            let base64String = imageData.base64EncodedString()
            print("Base64 String: \(base64String)")
            self.viewModel.prevUploadModel(nameSurname: self.profilNameTextField.text ?? "", profilImage: base64String)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    private func getPhoto(type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        self.profilImageView.isHidden = false
    }
    
    private func showPhotoAlert() {
        let alert = UIAlertController(title: "Take Photo From", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.getPhoto(type: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.getPhoto(type: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { action in
               self.profilImageView.image = UIImage(named: "person")
               
               guard let defaultImage = UIImage(named: "person"),
                     let imageData = defaultImage.jpegData(compressionQuality: 0.8) else { return }
               let base64String = imageData.base64EncodedString()
               print("Default Image Base64 String: \(base64String)")
               self.viewModel.prevUploadModel(nameSurname: self.profilNameTextField.text ?? "", profilImage: base64String)
           }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
