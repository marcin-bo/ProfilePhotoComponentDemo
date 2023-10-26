//
//  BackgroundTypePickerViewModel.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

import Combine

protocol BackgroundTypePickerViewModelType {
    // Input
    var currentBackgroundType: BackgroundType { get set }
    var backgroundTypeTitles: BackgroundTypeTitles { get }
    
    // Output
    var currentBackgroundTypePublisher: Published<BackgroundType>.Publisher { get }
}

final class BackgroundTypePickerViewModel: BackgroundTypePickerViewModelType {
    // Output
    @Published var currentBackgroundType: BackgroundType
    let backgroundTypeTitles: BackgroundTypeTitles
    
    // Input
    var currentBackgroundTypePublisher: Published<BackgroundType>.Publisher { $currentBackgroundType }
    
    init(
        currentBackgroundType: BackgroundType,
        backgroundTypeTitles: BackgroundTypeTitles) {
        self.currentBackgroundType = currentBackgroundType
        self.backgroundTypeTitles = backgroundTypeTitles
    }
}
