//
//  LottieManager.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 30.03.2023.
//

import UIKit
import Lottie

enum LottieNames: String {
    case forLaunch = "forLaunch"
    case forIndicator = "forIndicator"
}

class LottieManager {
    
    static let shared = LottieManager()
    private var granted: Bool?
    
    private var animationView: LottieAnimationView!
    
    init(){}
    
    func playLottie(view: UIView, lottieName: String) {
        granted = true
        animationView = .init(name: lottieName)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.15
        view.addSubview(animationView)
        animationView.play()
    }
    
    func stopLottie() {
        animationView.stop()
    }
}
