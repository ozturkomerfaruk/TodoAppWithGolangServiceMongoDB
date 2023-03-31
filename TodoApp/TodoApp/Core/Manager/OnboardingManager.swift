//
//  OnboardingManager.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 22.03.2023.
//

import Foundation

class OnboardingManager {
    static let shared = OnboardingManager()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
