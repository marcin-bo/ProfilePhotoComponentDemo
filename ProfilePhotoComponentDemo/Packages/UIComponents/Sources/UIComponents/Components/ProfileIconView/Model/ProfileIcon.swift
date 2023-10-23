//
//  ProfileIcon.swift
//  
//
//  Created by Marcin Borek on 23/10/2023.
//

import struct CoreFoundation.CGFloat
import struct Foundation.URL
import class UIKit.UIColor
import class UIKit.UIImage

public enum ProfileIcon {
    case solid(SolidAttributes)
    case gradient(GradientAttributes)
    case image(ImageAttributes)
}

extension ProfileIcon {
    public typealias Initials = String
    
    public enum Shape {
        case circle
        case roundedSquare
    }
    
    public struct SolidAttributes {
        public let initials: Initials
        public let backgroundColor: UIColor
        public let shape: Shape
        
        public init(initials: Initials, backgroundColor: UIColor, shape: Shape) {
            self.initials = initials
            self.backgroundColor = backgroundColor
            self.shape = shape
        }
    }

    public struct GradientAttributes {
        public let initials: Initials
        public let startColor: UIColor
        public let endColor: UIColor
        public let shape: Shape
        
        public init(initials: Initials, startColor: UIColor, endColor: UIColor, shape: Shape) {
            self.initials = initials
            self.startColor = startColor
            self.endColor = endColor
            self.shape = shape
        }
    }

    public struct ImageAttributes {
        public let image: UIImage
        public let shape: Shape
        
        public init(image: UIImage, shape: Shape) {
            self.image = image
            self.shape = shape
        }
    }
}
