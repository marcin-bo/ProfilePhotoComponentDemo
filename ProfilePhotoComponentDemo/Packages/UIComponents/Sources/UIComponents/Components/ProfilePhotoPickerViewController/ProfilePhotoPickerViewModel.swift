//
//  ProfilePhotoPickerViewModel.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

protocol ProfilePhotoPickerViewModelType {
    var title: String { get }
    var currentProfileIcon: ProfileIcon { get set }
    var backgroundTypePickerViewModel: BackgroundTypePickerViewModelType { get set }
    var solidColorPickerViewModel: ColorPickerViewModelType { get set }
    var gradientColorPickerViewModel: GradientColorPickerViewModelType { get set }
}

final class ProfilePhotoPickerViewModel: ProfilePhotoPickerViewModelType {
    let title: String
    var currentProfileIcon: ProfileIcon
    var backgroundTypePickerViewModel: BackgroundTypePickerViewModelType
    var solidColorPickerViewModel: ColorPickerViewModelType
    var gradientColorPickerViewModel: GradientColorPickerViewModelType
    
    init(
        title: String,
        currentProfileIcon: ProfileIcon,
        backgroundTypePickerViewModel: BackgroundTypePickerViewModelType,
        solidColorPickerViewModel: ColorPickerViewModelType,
        gradientColorPickerViewModel: GradientColorPickerViewModelType
    ) {
        self.title = title
        self.currentProfileIcon = currentProfileIcon
        self.backgroundTypePickerViewModel = backgroundTypePickerViewModel
        self.solidColorPickerViewModel = solidColorPickerViewModel
        self.gradientColorPickerViewModel = gradientColorPickerViewModel
    }
}
