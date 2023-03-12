//
//  TaskDetailView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class TaskDetailView: UIViewController {
    
    var todoModel: TodoModel?
    
    @IBOutlet private weak var backButtonOutlet: UIButton!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var taskNameLabel: UILabel!
    @IBOutlet private weak var fullDateLabel: UILabel!
    @IBOutlet private weak var progressPercentLabel: UILabel!
    @IBOutlet private weak var taskDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetailView()
    }
}

extension TaskDetailView {
    private func configureTaskDetailView() {
        title = "Task Details"
        backButtonOutlet.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        taskNameLabel.text = todoModel?.title
        taskDescriptionTextView.text = todoModel?.content
    }
    
    @objc private func pressed() {
        navigationController?.popViewController(animated: true)
    }
}
