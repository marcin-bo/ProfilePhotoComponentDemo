//
//  UIView+Extensions.swift
//  
//
//  Created by Marcin Borek on 26/10/2023.
//

import class UIKit.UIView

extension UIView {
    func fadeIn() {
        guard self.isHidden else {
            return
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.alpha = 1.0
                self.isHidden = false
            },
            completion: nil
        )
    }
    
    func fadeOut() {
        guard !self.isHidden else {
            return
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.alpha = 0.0
                self.isHidden = true
            },
            completion: nil
        )
    }
}
