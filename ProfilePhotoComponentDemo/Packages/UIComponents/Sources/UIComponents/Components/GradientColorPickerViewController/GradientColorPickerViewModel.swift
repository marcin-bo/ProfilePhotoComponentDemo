//
//  GradientColorPickerViewModel.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

protocol GradientColorPickerViewModelType {
    var startColorPickerViewModel: ColorPickerViewModelType { get set }
    var endColorPickerViewModel: ColorPickerViewModelType { get set }
}

final class GradientColorPickerViewModel: GradientColorPickerViewModelType {
    var startColorPickerViewModel: ColorPickerViewModelType
    var endColorPickerViewModel: ColorPickerViewModelType
    
    init(
        startColorPickerViewModel: ColorPickerViewModelType,
        endColorPickerViewModel: ColorPickerViewModelType
    ) {
        self.startColorPickerViewModel = startColorPickerViewModel
        self.endColorPickerViewModel = endColorPickerViewModel
    }
}
