//
//  AppExtensions.swift
//  BaseProject
//
//  Created by Santhosh Marripelli on 23/02/18.
//  Copyright © 2018 Santhosh Marripelli. All rights reserved.
//

import Foundation
import UIKit
extension String {
    public func getRestAPIName(_ baseURL: String) -> String {
        let filter = getFilters(self, baseURL) ?? ""
        let quoteBaseURL = baseURL + filter
        if let startPoint = self.range(of: quoteBaseURL)?.upperBound {
            let text = String(self[startPoint...])
            return getNameByFilters(text) ?? self
        }
        return self
    }
    private func getFilters(_ url: String, _ baseURL: String) -> String? {
        let string = url.replacingOccurrences(of: baseURL, with: "")
        let array = string.components(separatedBy: "/")
        guard let filter = array.first else {
            return nil
        }
        return filter + "/"
    }
    private func getNameByFilters(_ text: String) -> String? {
        if text.contains("/") {
            return text.components(separatedBy: "/").first
        } else if text.contains("?") {
            return text.components(separatedBy: "?").first
        } else if text.contains("&") {
            return  text.components(separatedBy: "&").first
        }
        return text
    }
}


//////////Fonts ///////////////
extension UILabel {
    
    public func setReguralFont(size: CGFloat) {
        self.font = UIFont.regularFont(size)
    }
    public func setBoldFontFont(size: CGFloat) {
        self.font = UIFont.boldFont(size)
    }
    public func setMediumFont(size: CGFloat) {
        self.font = UIFont.mediumFont(size)
    }
    public func setLightFont(size: CGFloat) {
        self.font = UIFont.lightFont(size)
    }
    public func setSemiBoldFont(size: CGFloat) {
        self.font = UIFont.semiBoldFont(size)
    }
    public func setThinFont(size: CGFloat) {
        self.font = UIFont.thinFont(size)
    }
    
}

extension UITextField {
    public func setReguralFont(size: CGFloat) {
        self.font = UIFont.regularFont(size)
    }
    public func setBoldFontFont(size: CGFloat) {
        self.font = UIFont.boldFont(size)
    }
    public func setMediumFont(size: CGFloat) {
        self.font = UIFont.mediumFont(size)
    }
    public func setLightFont(size: CGFloat) {
        self.font = UIFont.lightFont(size)
    }
    public func setSemiBoldFont(size: CGFloat) {
        self.font = UIFont.semiBoldFont(size)
    }
    public func setThinFont(size: CGFloat) {
        self.font = UIFont.thinFont(size)
    }
}

extension UIButton {
    public func setReguralFont(size: CGFloat) {
        self.titleLabel?.font = UIFont.regularFont(size)
    }
    public func setBoldFontFont(size: CGFloat) {
        self.titleLabel?.font = UIFont.boldFont(size)
    }
    public func setMediumFont(size: CGFloat) {
        self.titleLabel?.font = UIFont.mediumFont(size)
    }
    public func setLightFont(size: CGFloat) {
        self.titleLabel?.font = UIFont.lightFont(size)
    }
    public func setSemiBoldFont(size: CGFloat) {
        self.titleLabel?.font = UIFont.semiBoldFont(size)
    }
    public func setThinFont(size: CGFloat) {
        self.titleLabel?.font = UIFont.thinFont(size)
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
