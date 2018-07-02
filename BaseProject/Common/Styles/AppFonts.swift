//
//  AppFonts.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 24/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import UIKit

struct CustomFontName {
    static let reguralFont = "Lato-Regular"
    static let mediumFont = "Lato-Medium"
    static let boldFont = "Lato-Bold"
    static let lightFont = "Lato-Light"
    static let semiBoldFont = "Lato-Semibold"
    static let thinFont = "Lato-Thin"
}


extension UIFont {
    
    static func regularFont(_ size: CGFloat) -> UIFont {
        let name = CustomFontName.reguralFont
        let customFont = UIFont(name: name, size: size)
        return customFont ?? systemFont(ofSize: size)
    }
    static func boldFont(_ size: CGFloat) -> UIFont {
        let name = CustomFontName.boldFont
        let customFont = UIFont(name: name, size: size)
        return customFont ?? systemFont(ofSize: size)
    }
    static func mediumFont(_ size: CGFloat) -> UIFont {
        let name = CustomFontName.mediumFont
        let customFont = UIFont(name: name, size: size)
        return customFont ?? systemFont(ofSize: size)
    }
    static func lightFont(_ size: CGFloat) -> UIFont {
        let name = CustomFontName.lightFont
        let customFont = UIFont(name: name, size: size)
        return customFont ?? systemFont(ofSize: size)
    }
    static func semiBoldFont(_ size: CGFloat) -> UIFont {
        let name = CustomFontName.semiBoldFont
        let customFont = UIFont(name: name, size: size)
        return customFont ?? systemFont(ofSize: size)
    }
    static func thinFont(_ size: CGFloat) -> UIFont {
        let name = CustomFontName.thinFont
        let customFont = UIFont(name: name, size: size)
        return customFont ?? systemFont(ofSize: size)
    }
}
