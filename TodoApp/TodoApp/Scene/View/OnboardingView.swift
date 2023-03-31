//
//  OnboardingView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 5.03.2023.
//

import UIKit

final class OnboardingView: BaseView {
    
    private let gradientLayer = CAGradientLayer()
    @IBOutlet private weak var letsStartOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        configureGradient()
        letsStartOutlet.layer.cornerRadius = 12
    }
    
    private func configureGradient() {
        gradientLayer.colors = [UIColor(red: 47/255, green: 117/255, blue: 254/255, alpha: 1).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction private func letsStartAction(_ sender: Any) {
        OnboardingManager.shared.setIsNotNewUser()
        
        OnboardingManager.shared.setIsNotNewUser()
        let vc = storyboard?.instantiateViewController(withIdentifier: "loginRegisterView") as! LoginRegisterView
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }
}
