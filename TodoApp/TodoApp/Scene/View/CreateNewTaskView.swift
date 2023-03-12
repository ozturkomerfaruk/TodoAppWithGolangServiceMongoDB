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
    
    
    private let datePickerDateTime = UIDatePicker()
    private let datePickerTime = UIDatePicker()
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
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 20
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dateTimeTextField.addPaddingAndIcon(UIImage(systemName: "calendar")!, padding: 40, isLeftView: false)
        startTimeTextField.addPaddingAndIcon(UIImage(systemName: "clock")!, padding: 40, isLeftView: false)
        endTimeTextField.addPaddingAndIcon(UIImage(systemName: "clock")!, padding: 40, isLeftView: false)
        
        createDatePicker(for: dateTimeTextField, with: datePickerDateTime, placeholder: "Select a date")
        createDatePicker(for: startTimeTextField, with: datePickerTime, placeholder: "Start time")
        createDatePicker(for: endTimeTextField, with: datePickerTime, placeholder: "End time")
    }
    
    private func createDatePicker(for textField: UITextField, with datePicker: UIDatePicker, placeholder: String) {
        
        if textField == dateTimeTextField {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            textField.inputView = datePicker
        } else {
            datePicker.datePickerMode = .time
            datePicker.preferredDatePickerStyle = .wheels
            textField.inputView = datePicker
        }
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        textField.placeholder = placeholder
        textField.delegate = self
    }
    
    // DatePicker
    @objc private func doneButtonTapped() {
        guard let textField = currentTextField else { return }
        let dateFormatter = DateFormatter()
        if textField == startTimeTextField || textField == endTimeTextField {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            let calendar = datePickerTime.calendar
            let components = calendar!.dateComponents([.hour, .minute], from: datePickerTime.date)
            if let hour = components.hour, let minute = components.minute {
                print("hour: \(hour), minute: \(minute)")
                var timeString: String
                if hour >= 12 {
                    if hour > 12 {
                        timeString = String(format: "%d:%02d PM", hour - 12, minute)
                    } else {
                        timeString = String(format: "%d:%02d PM", hour, minute)
                    }
                } else {
                    timeString = String(format: "%d:%02d AM", hour, minute)
                }
                textField.text = timeString
            }
        } else {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            textField.text = dateFormatter.string(from: datePickerDateTime.date)
        }

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
