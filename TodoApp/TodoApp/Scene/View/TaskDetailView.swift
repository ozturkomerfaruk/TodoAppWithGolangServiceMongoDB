//
//  TaskDetailView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class TaskDetailView: UIViewController {
    
    var modelID: String?
    
    @IBOutlet private weak var backButtonOutlet: UIButton!
    @IBOutlet private weak var editOrSaveOutlet: UIBarButtonItem!
    private var isEditValue = true
    
    @IBOutlet private weak var taskImageView: UIImageView!
    @IBOutlet private weak var updateTaskPhotoButtonOutlet: UIButton!
    
    @IBOutlet private weak var taskTitleTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var fullDateTextField: UITextField!
    @IBOutlet private weak var progressPercentLabel: UILabel!
    @IBOutlet private weak var valueSlider: UISlider!
       
    @IBOutlet private weak var startTimeTextField: UITextField!
    @IBOutlet private weak var endTimeTextField: UITextField!
    @IBOutlet private weak var taskContentTextView: UITextView!
    
    private let datePickerDateTime = UIDatePicker()
    private let datePickerTime = UIDatePicker()
    private let toolbar = UIToolbar()
    private var currentTextField: UITextField!
    
    private var initialValues: [String: Any] = [:]
    
    var viewModel = TaskDetailViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetailView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.getTodoTask(id: self.modelID!)
        }
    }
    
    
    @IBAction func editOrSaveAction(_ sender: Any) {
        self.isEditValue.toggle()
        guard let button = navigationItem.rightBarButtonItem else {
            return
        }
        button.title = isEditValue ? "Edit" : "Save"
        updateTaskPhotoButtonOutlet.isHidden = isEditValue ? true : false
        
        self.taskTitleTextField.isEnabled = !isEditValue ? true : false
        self.fullDateTextField.isEnabled = !isEditValue ? true : false
        self.startTimeTextField.isEnabled = !isEditValue ? true : false
        self.endTimeTextField.isEnabled = !isEditValue ? true : false
        self.valueSlider.isEnabled = !isEditValue ? true : false
        self.taskContentTextView.isEditable = !isEditValue ? true : false
        self.categoryTextField.isEnabled = !isEditValue ? true : false
        
        self.taskTitleTextField.textColor = !isEditValue ? UIColor.black : UIColor.systemGray2
        self.fullDateTextField.textColor = !isEditValue ? UIColor.black : UIColor.systemGray2
        self.startTimeTextField.textColor = !isEditValue ? UIColor.black : UIColor.systemGray2
        self.endTimeTextField.textColor = !isEditValue ? UIColor.black : UIColor.systemGray2
        self.taskContentTextView.textColor = !isEditValue ? UIColor.black : UIColor.systemGray2
        self.categoryTextField.textColor = !isEditValue ? UIColor.black : UIColor.systemGray2
        
        if button.title != "Save" {
            if hasChanges() {
                let parameters = [
                    "id": modelID!,
                    "title": taskTitleTextField.text!,
                    "category": categoryTextField.text!,
                    "date": fullDateTextField.text!,
                    "startTime": startTimeTextField.text!,
                    "endTime": endTimeTextField.text!,
                    "content": taskContentTextView.text!,
                    "progress": valueSlider.value
                ] as [String : Any]
                //print(parameters)
                viewModel.putTodoUpdate(id: modelID!, parameters: parameters)
            } else {
                print("Bir değişiklik yapmadınız...")
            }
        }
    }
    
    @IBAction func valueSliderAction(_ sender: UISlider) {
        let step: Float = 10
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        progressPercentLabel.text = "\(Int(sender.value))%"
    }
}

extension TaskDetailView {
    private func configureTaskDetailView() {
        title = "Task Details"
        viewModel.delegate = self
        backButtonOutlet.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        taskImageView.layer.cornerRadius = taskImageView.frame.height / 2
        updateTaskPhotoButtonOutlet.layer.cornerRadius = updateTaskPhotoButtonOutlet.frame.height / 2
        updateTaskPhotoButtonOutlet.isHidden = true
        
        taskTitleTextField.isEnabled = false
        fullDateTextField.isEnabled = false
        startTimeTextField.isEnabled = false
        endTimeTextField.isEnabled = false
        valueSlider.isEnabled = false
        taskContentTextView.isEditable = false
        categoryTextField.isEnabled = false
        
        taskContentTextView.layer.borderWidth = 1
        taskContentTextView.layer.borderColor = UIColor.lightGray.cgColor
        taskContentTextView.layer.cornerRadius = 20
        taskContentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        createDatePicker(for: fullDateTextField, with: datePickerDateTime, placeholder: "Select a date")
        createDatePicker(for: startTimeTextField, with: datePickerTime, placeholder: "Start time")
        createDatePicker(for: endTimeTextField, with: datePickerTime, placeholder: "End time")
    }
    
    private func hasChanges() -> Bool {
        return initialValues["title"] as? String != taskTitleTextField.text ||
            initialValues["category"] as? String != categoryTextField.text ||
            initialValues["date"] as? String != fullDateTextField.text ||
            initialValues["startTime"] as? String != startTimeTextField.text ||
            initialValues["endTime"] as? String != endTimeTextField.text ||
            initialValues["content"] as? String != taskContentTextView.text ||
            initialValues["progress"] as? Float != valueSlider.value
    }

    
    @objc private func pressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension TaskDetailView: TaskDetailViewViewModelDelegate {
    func fetchLoaded() {
        DispatchQueue.main.async {
            let model = self.viewModel.getDetailModel()
            self.taskTitleTextField.text = model.title
            self.categoryTextField.text = model.category
            self.fullDateTextField.text = model.date
            self.progressPercentLabel.text = "\(model.progress ?? 0)%"
            self.valueSlider.value = Float(model.progress ?? 0)
            self.startTimeTextField.text = "\(model.startTime ?? "00.00 AM")"
            self.endTimeTextField.text = "\(model.endTime ?? "00.00 AM")"
            self.taskContentTextView.text = model.content
            
            self.initialValues = [
                "title": self.taskTitleTextField.text ?? "",
                "category": self.categoryTextField.text ?? "",
                "date": self.fullDateTextField.text ?? "",
                "startTime": self.startTimeTextField.text ?? "",
                "endTime": self.endTimeTextField.text ?? "",
                "content": self.taskContentTextView.text ?? "",
                "progress": self.valueSlider.value
            ]
        }
    }
    
    func afterPutTodo() {
        viewModel.getTodoTask(id: modelID!)
    }
    
    func fetchFailed(error: Error) {
        fatalError(String(describing: error))
    }
    
    func preFetch() {
        print("pre fetch")
    }
}

extension TaskDetailView: UITextFieldDelegate {
    private func createDatePicker(for textField: UITextField, with datePicker: UIDatePicker, placeholder: String) {
        
        if textField == fullDateTextField {
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
