//
//  DefaultPickerColors.swift
//  
//
//  Created by Marcin Borek on 26/10/2023.
//

import class UIKit.UIColor

public struct DefaultPickerColors {
    let solidColor: UIColor
    let startColor: UIColor
    let endColor: UIColor
    
    public init(solidColor: UIColor, startColor: UIColor, endColor: UIColor) {
        self.solidColor = solidColor
        self.startColor = startColor
        self.endColor = endColor
    }
}
