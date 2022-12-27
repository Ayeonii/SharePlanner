//
//  UIFont+Extensions.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import Foundation
import UIKit

enum CustomFontType: String {
    case primary = "NanumDdoBagDdoBag"
}

enum CustomFontWeight {
    case bold
    case medium
}

extension UIFont {
    static func appFont(_ type: CustomFontType = .primary, size : CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
}


