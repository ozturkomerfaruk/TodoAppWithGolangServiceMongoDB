//
//  TaskDetailView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class TaskDetailView: UIViewController {
    
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskDetailView()
    }
}

extension TaskDetailView {
    private func configureTaskDetailView() {
        title = "Task Details"
        backButtonOutlet.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
    
    @objc private func pressed() {
        navigationController?.popViewController(animated: true)
    }
}
