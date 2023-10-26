//
//  BackgroundTypePickerViewModel.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

import Combine

public protocol BackgroundTypePickerViewModelType {
    // Input
    var currentBackgroundType: BackgroundType { get set }
    var backgroundTypeTitles: BackgroundTypeTitles { get }
    
    // Output
    var currentBackgroundTypePublisher: Published<BackgroundType>.Publisher { get }
}

public enum BackgroundType {
    case solid
    case gradient
    case image
}

public struct BackgroundTypeTitles {
    public let solidTitle: String
    public let gradientTitle: String
    public let imageTitle: String
    
    public init(solidTitle: String, gradientTitle: String, imageTitle: String) {
        self.solidTitle = solidTitle
        self.gradientTitle = gradientTitle
        self.imageTitle = imageTitle
    }
}

public final class BackgroundTypePickerViewModel: BackgroundTypePickerViewModelType {
    // Output
    @Published public var currentBackgroundType: BackgroundType
    public let backgroundTypeTitles: BackgroundTypeTitles
    
    // Input
    public var currentBackgroundTypePublisher: Published<BackgroundType>.Publisher { $currentBackgroundType }
    
    public init(
        currentBackgroundType: BackgroundType,
        backgroundTypeTitles: BackgroundTypeTitles) {
        self.currentBackgroundType = currentBackgroundType
        self.backgroundTypeTitles = backgroundTypeTitles
    }
}
