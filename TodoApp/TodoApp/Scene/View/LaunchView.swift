//
//  LaunchView.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 22.03.2023.
//

import UIKit

final class LaunchView: BaseView {
    
    @IBOutlet private weak var lottieView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.setOnboardingValue()
    }
    
    private func configureView() {
        titleLabel.alpha = 0
        
        LottieManager.shared.playLottie(view: lottieView, lottieName: LottieNames.forLaunch.rawValue)
        UIView.animate(withDuration: 2.2) { [weak self] in
            guard let self = self else { return }
            self.titleLabel.alpha = 1
        }
    }
    
    private func setOnboardingValue() {
        if !OnboardingManager.shared.isNewUser() {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.5) { [weak self] in
                guard let self = self else { return }
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginRegisterView") as? UIViewController else { return }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.5) { [weak self] in
                guard let self = self else { return }
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "onboardingView") as? UIViewController else { return }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        LottieManager.shared.stopLottie()
    }
}
