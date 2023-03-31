//
//  CustomCollectionViewCategoryCell.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 14.03.2023.
//

import UIKit

protocol CustomCollectionViewCategoryCellDelegate: AnyObject {
    func categoryName(name: String)
    func newCategoryName(name: String)
}

final class CustomCollectionViewCategoryCell: UICollectionViewCell {
    
    weak var delegate: CustomCollectionViewCategoryCellDelegate?
    
    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var backView: UIView!
    private var cornerRadius: CGFloat = 20.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    func configureCollectionViewCell(name: String) {
        categoryName.text = name
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        categoryName.addGestureRecognizer(tapGesture)
        categoryName.isUserInteractionEnabled = true
    }
    
    @objc private func labelTapped() {
        if categoryName.text == "Yeni Kategori" {
            let alertController = UIAlertController(title: "Yeni Kategori Ekle", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Kategori İsmi"
            }
            let addAction = UIAlertAction(title: "Ekle", style: .default) { (action) in
                if let categoryName = alertController.textFields?.first?.text {
                    self.delegate?.newCategoryName(name: categoryName)
                }
            }
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            if let viewController = delegate as? UIViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
            backView.backgroundColor = .tintColor
        } else {
            guard let collectionView = superview as? UICollectionView else { return }
            for cell in collectionView.visibleCells {
                if cell != self, let customCell = cell as? CustomCollectionViewCategoryCell {
                    if customCell.categoryName.text != "Yeni Kategori" {
                        customCell.backView.backgroundColor = .lightGray
                    }
                }
            }
            backView.backgroundColor = .tintColor
            self.delegate?.categoryName(name: categoryName.text ?? "")
        }
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        if categoryName.text == "Yeni Kategori" {
            backView.backgroundColor = .systemIndigo
        } else {
            backView.backgroundColor = .lightGray
        }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        categoryName.textColor = .white
    }

}
