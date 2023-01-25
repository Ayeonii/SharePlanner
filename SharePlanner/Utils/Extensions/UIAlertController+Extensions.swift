//
//  UIAlertController.swift
//  SharePlanner
//
//  Created by Ayeon on 2023/01/19.
//

import UIKit

extension UIAlertController {
    func setAlertColor(titleColor : UIColor, backgroundColor : UIColor) {
        self.view.tintColor = titleColor
        let subview = (self.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = backgroundColor
    }
    
    func setAlertBackgroundColor(_ color : UIColor) {
        let subview = (self.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = color
    }
}

extension UIAlertAction {
    func setTextColor(_ color : UIColor) {
        self.setValue(color, forKey: "titleTextColor")
    }
}
