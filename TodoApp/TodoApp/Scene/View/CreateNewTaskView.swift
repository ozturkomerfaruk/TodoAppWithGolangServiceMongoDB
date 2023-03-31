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
    
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    private var categoryName = String()
    
    @IBOutlet private weak var dateTimeTextField: UITextField!
    @IBOutlet private weak var startTimeTextField: UITextField!
    @IBOutlet private weak var endTimeTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var createTaskOutlet: UIButton!
    
    private let datePickerDateTime = UIDatePicker()
    private let datePickerTime = UIDatePicker()
    private let toolbar = UIToolbar()
    private var currentTextField: UITextField!
    
    var viewModel = CreateNewTaskViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCreateNewTaskView()
        viewModel.delegate = self
    }
    
    @IBAction private func createTaskAction(_ sender: Any) {
        if taskNameTextField.text!.isEmpty || categoryName.isEmpty || dateTimeTextField.text!.isEmpty || startTimeTextField.text!.isEmpty || endTimeTextField.text!.isEmpty || contentTextView.text!.isEmpty {
            print("Boş olamaz")
        } else {
            let parameters = [
                "title": taskNameTextField.text ?? "",
                "Category": categoryName,
                "Date": dateTimeTextField.text ?? "",
                "StartTime": startTimeTextField.text ?? "",
                "EndTime": endTimeTextField.text ?? "",
                "content": contentTextView.text ?? "",
                "progress": 0
            ] as [String : Any]
            viewModel.postInsert(parameters: parameters)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                guard let tabBarController = self.tabBarController else { return }
                tabBarController.selectedIndex = 0
                UIView.transition(with: tabBarController.view, duration: 1.0, options: [.transitionCrossDissolve], animations: {
                }, completion: nil)
            }
        }
    }
}

extension CreateNewTaskView {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.selectedIndex = 0

        UIView.transition(with: tabBarController.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
        }, completion: nil)
    }
    
    private func configureCreateNewTaskView() {
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.cornerRadius = 20
        contentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dateTimeTextField.addPaddingAndIcon(UIImage(systemName: "calendar")!, padding: 40, isLeftView: false)
        startTimeTextField.addPaddingAndIcon(UIImage(systemName: "clock")!, padding: 40, isLeftView: false)
        endTimeTextField.addPaddingAndIcon(UIImage(systemName: "clock")!, padding: 40, isLeftView: false)
        
        createDatePicker(for: dateTimeTextField, with: datePickerDateTime, placeholder: "Select a date")
        createDatePicker(for: startTimeTextField, with: datePickerTime, placeholder: "Start time")
        createDatePicker(for: endTimeTextField, with: datePickerTime, placeholder: "End time")
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "CustomCollectionViewCategoryCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewCategoryCell")
        categoryCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension CreateNewTaskView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomCollectionViewCategoryCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == viewModel.categoryList.count {
            // Son hücredeki işlemler burada yapılabilir
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewCategoryCell", for: indexPath) as! CustomCollectionViewCategoryCell
            cell.configureCollectionViewCell(name: "Yeni Kategori")
            cell.delegate = self
            return cell
        } else {
            // Diğer hücreler için bu kod çalışır
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewCategoryCell", for: indexPath) as! CustomCollectionViewCategoryCell
            cell.configureCollectionViewCell(name: viewModel.categoryList[indexPath.item])
            cell.delegate = self
            return cell
        }
    }
    
    func categoryName(name: String) {
        self.categoryName = name
    }
    
    func newCategoryName(name: String) {
        if viewModel.categoryList.last == "Yemek" {
            viewModel.categoryList.append(name)
        } else {
            viewModel.categoryList.removeLast()
            viewModel.categoryList.append(name)
        }
        categoryCollectionView.reloadData()
    }
}

extension CreateNewTaskView: CreateNewTaskViewViewModelDelegate {
    func fetchLoaded(model: TodoTaskModel) {
       
    }
    
    func fetchFailed(error: Error) {
        fatalError(String(describing: error))
    }
    
    func preFetch() {
        print("pre fetch")
    }
}

extension CreateNewTaskView: UITextFieldDelegate {
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
