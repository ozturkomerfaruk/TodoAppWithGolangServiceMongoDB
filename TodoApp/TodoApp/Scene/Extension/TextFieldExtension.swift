//
//  TextFieldExtension.swift
//  TodoApp
//
//  Created by Ömer Faruk Öztürk on 9.03.2023.
//

import UIKit.UITextField

extension UITextField {
    func addPaddingAndIcon(_ image: UIImage, padding: CGFloat,isLeftView: Bool) {
        let frame = CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height)
        
        let outerView = UIView(frame: frame)
        let iconView  = UIImageView(frame: frame)
        iconView.image = image
        iconView.contentMode = .center
        outerView.addSubview(iconView)
        
        if isLeftView {
            leftViewMode = .always
            leftView = outerView
        } else {
            rightViewMode = .always
            rightView = outerView
        }
    }
    
    func disableAutocorrectionFeatures() {
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        smartQuotesType = .no
        smartDashesType = .no
        smartInsertDeleteType = .no
    }
}
