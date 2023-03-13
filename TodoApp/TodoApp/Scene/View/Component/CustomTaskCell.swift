//
//  CustomTaskCell.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 13.03.2023.
//

import UIKit

final class CustomTaskCell: UICollectionViewCell {

    @IBOutlet private weak var todaysProgressView: UIView!
    @IBOutlet private weak var taskCountLabel: UILabel!
    @IBOutlet private weak var progressViewPercentValueLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!

    private let gradientLayer = CAGradientLayer()
    
    func configureCustomCell(count: String, percent: String) {
        taskCountLabel.text = count
        progressViewPercentValueLabel.text = percent
        
        setupBackground()
    }
    
    private func setupBackground() {
        let startColor = UIColor(red: 76/255, green: 191/255, blue: 238/255, alpha: 1).cgColor
        let endColor = UIColor(red: 26/255, green: 109/255, blue: 203/255, alpha: 1).cgColor
        
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = todaysProgressView.bounds
        todaysProgressView.layer.insertSublayer(gradientLayer, at: 0)
        todaysProgressView.layer.cornerRadius = 16
        todaysProgressView.layer.masksToBounds = true
    }
}
