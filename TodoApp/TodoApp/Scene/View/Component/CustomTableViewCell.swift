//
//  CustomTableViewCell.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    @IBOutlet private weak var taskImageView: UIImageView!
    @IBOutlet private weak var taskTitle: UILabel!
    @IBOutlet private weak var taskDate: UILabel!
    
    func configureCustomTableViewCell() {
        taskImageView.image = UIImage(systemName: "person")
        taskTitle.text = "Web Development"
        taskDate.text = "09:00 AM - 11:00 AM"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let customCellView = UIView()
        customCellView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = customCellView
    }
}
