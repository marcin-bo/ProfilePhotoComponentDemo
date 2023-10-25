//
//  GradientColorPickerViewModel.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

public protocol GradientColorPickerViewModelType {
    var startColorPickerViewModel: ColorPickerViewModelType { get set }
    var endColorPickerViewModel: ColorPickerViewModelType { get set }
}

public final class GradientColorPickerViewModel: GradientColorPickerViewModelType {
    public var startColorPickerViewModel: ColorPickerViewModelType
    public var endColorPickerViewModel: ColorPickerViewModelType
    
    public init(
        startColorPickerViewModel: ColorPickerViewModelType,
        endColorPickerViewModel: ColorPickerViewModelType
    ) {
        self.startColorPickerViewModel = startColorPickerViewModel
        self.endColorPickerViewModel = endColorPickerViewModel
    }
}
