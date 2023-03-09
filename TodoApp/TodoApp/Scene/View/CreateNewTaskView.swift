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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCreateNewTaskView()
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    private func configureCreateNewTaskView() {
        dateTimeTextField.addPaddingAndIcon(UIImage(systemName: "calendar")!, padding: 40, isLeftView: false)
        
        let dateFormatter = DateFormatter() //Bir DateFormatter tanımladık.
        dateFormatter.dateFormat = "dd-MM-yyyy" // Tarih formatımızın nasıl olacağını belirttik.
        dateTimeTextField.text = dateFormatter.string(from: datePicker.date) // Tarihi stringe çevirerek label'a yazdırdık.
        
        createDatePicker()
    }
    
    func createDatePicker() {
        
        //DatePicker'da oluşan tarihi textfield'a kaydetmek için kullancağımız butonu koyacağımız barı oluşturuyoruz.
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Barda bulunacak butonu oluşturduk.
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneButtonClicked))
        toolbar.setItems([doneButton], animated: true)
        
        //inputAccessoryView : Text field için sistem tarafından sunulan klavyeye aksesuar görünümü eklemek için kullanıyoruz. Bizde butonumuz için bir toolbar ekliyoruz.
        dateTimeTextField.inputAccessoryView = toolbar
        
        //inputAccessoryView : Text field için sistem tarafından sunulan klavyenin yerini alacak bir görünüm eklemek için kullanıyoruz. Bizde klavye yerine datePicker kullanıyoruz.
        dateTimeTextField.inputView = datePicker
        
        //DatePicker'ımızın modunu belirliyor. Tarih, saat, zamanlayıcı gibi.
        datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonClicked() {
        
        //Yazdıracağımız tarihin formatını belirliyoruz.
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        //Text field'a date picker'dan gelen değeri yazdırıyoruz.
        dateTimeTextField.text = formatter.string(from: datePicker.date)
        
        //Done butonuna bastıktan sonra klavyemizin kapanacağını söylüyruz.
        self.view.endEditing(true)
    }
}
