//
//  CustomCollectionViewCell.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var taskImageView: UIImageView!
    @IBOutlet private weak var taskTitle: UILabel!
    @IBOutlet private weak var taskDate: UILabel!
    
    func configureCustomCollectionViewCell(model: TodoTaskModel) {
        taskImageView.image = UIImage(systemName: "note.text")
        taskTitle.text = model.title
        taskDate.text = "\(model.startTime!) - \(model.endTime!)"
    }
}
