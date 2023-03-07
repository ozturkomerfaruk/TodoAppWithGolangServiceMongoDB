//
//  TabBarController.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor.systemBlue
        self.tabBar.unselectedItemTintColor = UIColor.gray
        
        if let items = self.tabBar.items {
            items[1].image = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            items[1].selectedImage = UIImage(named: "tab2")?.withRenderingMode(.alwaysOriginal)
            items[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .selected)
            items[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        }
    }

}
