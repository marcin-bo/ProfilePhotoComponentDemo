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

public protocol ColorPickerViewModelType {
    // Output
    var title: String { get }
    var currentColor: UIColor { get set }
    var currentColorPublisher: Published<UIColor>.Publisher { get }
    
    // Input
    var didTapColorSelector: (UIColor) -> Void { get }
    func update(currentColor: UIColor)
}

public final class ColorPickerViewModel: ColorPickerViewModelType {
    // Output
    public let title: String
    @Published public var currentColor: UIColor
    public var currentColorPublisher: Published<UIColor>.Publisher { $currentColor }
    
    // Input
    public var didTapColorSelector: (UIColor) -> Void
    
    private var cancellable: AnyCancellable?
    
    public init(title: String, currentColor: UIColor, didTapColorSelector: @escaping (UIColor) -> Void) {
        self.title = title
        self.currentColor = currentColor
        self.didTapColorSelector = didTapColorSelector
    }
    
    public func update(currentColor: UIColor) {
        self.currentColor = currentColor
    }
}
