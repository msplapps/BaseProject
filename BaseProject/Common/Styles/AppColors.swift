//
//  AppColors.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 24/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import UIKit

struct CustomColors {
    static let red: String  = "#e74c3c"
    static let blue: String  = "#82ceac"
    static let lightBlue: String = "#ABE0F9"
    static let lightGreen: String = "#1abc9c"
    static let silverColor: String = "#bdc3c7"
    static let darkSilverColor: String = "#8395a7"
    
}

extension UIColor {
    
    static var appRedColor: UIColor {
        return UIColor(hexString: CustomColors.red)
    }
    
    static var appBlueColor: UIColor {
        return UIColor(hexString: CustomColors.blue)
    }
    
    static var applightBlueColor: UIColor {
        return UIColor(hexString: CustomColors.lightBlue)
    }
    
    static var appLightGreenColor: UIColor {
        return UIColor(hexString: CustomColors.lightGreen)
    }
    
    static var appSilverColor: UIColor {
        return UIColor(hexString: CustomColors.silverColor)
    }
    
    static var appDarkSilverColor: UIColor {
        return UIColor(hexString: CustomColors.darkSilverColor)
    }
    
}

extension UIColor {
    private convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
