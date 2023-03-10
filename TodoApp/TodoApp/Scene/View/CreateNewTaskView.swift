//
//  CreateNewTaskView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class CreateNewTaskView: UIViewController {
    
    @IBOutlet private weak var backButtonOutlet: UIButton!
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var designCategoryButton: UIButton!
    @IBOutlet private weak var developmentCategoryButton: UIButton!
    @IBOutlet private weak var researchCategoryButton: UIButton!
    @IBOutlet private weak var dateTimeTextField: UITextField!
    @IBOutlet private weak var startTimeTextField: UITextField!
    @IBOutlet private weak var endTimeTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    
    
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private var currentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCreateNewTaskView()
    }
}

extension CreateNewTaskView: UITextFieldDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    private func configureCreateNewTaskView() {
        dateTimeTextField.addPaddingAndIcon(UIImage(systemName: "calendar")!, padding: 40, isLeftView: false)
        createDatePicker(for: dateTimeTextField)
    }
    
    private func createDatePicker(for textField: UITextField) {
        let datePicker = UIDatePicker()
        let toolbar = UIToolbar()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels // wheel stili burada ayarlanıyor
        textField.inputView = datePicker
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        
        textField.placeholder = "Select a date"
        textField.delegate = self // delegate ayarı yapıldı
    }

    // DatePicker
    @objc private func doneButtonTapped() {
        guard let textField = currentTextField else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        textField.text = dateFormatter.string(from: datePicker.date)
        textField.resignFirstResponder()
    }

    // klavyeyi kapatır
    @objc private func cancelButtonTapped() {
        guard let textField = currentTextField else { return }
        textField.resignFirstResponder()
    }

    // inputAccessoryView'ın frame'ini güncelleyerek toolbar'ın görünürlüğünü sağlar
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let inputAccessoryView = currentTextField?.inputAccessoryView {
            inputAccessoryView.frame.size.height = toolbar.frame.size.height
        }
    }

    // tüm karakter değişikliklerini engeller
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    // UITextFieldDelegate metodu, herhangi bir textfield'a tıklandığında currentTextField özelliğini günceller
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
}
