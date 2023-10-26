//
//  ColorPickerViewModel.swift
//  
//
//  Created by Marcin Borek on 24/10/2023.
//

import Foundation
import class Combine.AnyCancellable
import struct Combine.Published
import class UIKit.UIColor

protocol ColorPickerViewModelType {
    // Output
    var title: String { get }
    var currentColor: UIColor { get set }
    var currentColorPublisher: Published<UIColor>.Publisher { get }
    
    // Input
    var didTapColorSelector: (UIColor) -> Void { get }
    func update(currentColor: UIColor)
}

final class ColorPickerViewModel: ColorPickerViewModelType {
    // Output
    let title: String
    @Published var currentColor: UIColor
    var currentColorPublisher: Published<UIColor>.Publisher { $currentColor }
    
    // Input
    var didTapColorSelector: (UIColor) -> Void
    
    private var cancellable: AnyCancellable?
    
    init(title: String, currentColor: UIColor, didTapColorSelector: @escaping (UIColor) -> Void) {
        self.title = title
        self.currentColor = currentColor
        self.didTapColorSelector = didTapColorSelector
    }
    
    func update(currentColor: UIColor) {
        self.currentColor = currentColor
    }
}
