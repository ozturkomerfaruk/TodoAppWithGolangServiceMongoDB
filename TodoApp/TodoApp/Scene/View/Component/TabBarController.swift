//
//  TabBarController.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 7.03.2023.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        self.tabBar.tintColor = UIColor.systemBlue
        self.tabBar.unselectedItemTintColor = UIColor.gray
        
        if let items = self.tabBar.items {
            let format = UIGraphicsImageRendererFormat()
            format.scale = UIScreen.main.scale // Ekran ölçülerine göre ölçeklendirme yapar
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50), format: format)
            let circleImage = renderer.image { ctx in
                let circleRect = CGRect(x: 0, y: 0, width: 50, height: 50)
                ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
                ctx.cgContext.setLineWidth(2)
                ctx.cgContext.addEllipse(in: circleRect)
                ctx.cgContext.strokePath()
                
                let plusRect = CGRect(x: 0, y: 0, width: 10, height: 10)
                let plusPath = UIBezierPath()
                plusPath.move(to: CGPoint(x: plusRect.midX, y: plusRect.minY))
                plusPath.addLine(to: CGPoint(x: plusRect.midX, y: plusRect.maxY))
                plusPath.move(to: CGPoint(x: plusRect.minX, y: plusRect.midY))
                plusPath.addLine(to: CGPoint(x: plusRect.maxX, y: plusRect.midY))
                UIColor.blue.setStroke()
                plusPath.lineWidth = 2
                let plusBounds = plusPath.bounds
                let plusCenter = CGPoint(x: circleRect.midX - plusBounds.midX, y: circleRect.midY - plusBounds.midY)
                plusPath.apply(CGAffineTransform(translationX: plusCenter.x, y: plusCenter.y))
                plusPath.stroke()
                
                let image = UIImage(systemName: "plus")?.withTintColor(.blue)
                let imageRect = CGRect(x: circleRect.midX - 8, y: circleRect.midY - 8, width: 16, height: 16)
                image?.draw(in: imageRect)
            }.withRenderingMode(.alwaysOriginal)
            items[1].image = circleImage
            // Diğer özellikleri ayarlayın
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }

}
