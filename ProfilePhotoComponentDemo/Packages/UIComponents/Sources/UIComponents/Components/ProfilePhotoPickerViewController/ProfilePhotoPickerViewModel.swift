//
//  ProfilePhotoPickerViewModel.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

public protocol ProfilePhotoPickerViewModelType {
    var title: String { get }
    var currentProfileIcon: ProfileIcon { get set }
    var backgroundTypePickerViewModel: BackgroundTypePickerViewModelType { get set }
    var solidColorPickerViewModel: ColorPickerViewModelType { get set }
    var gradientColorPickerViewModel: GradientColorPickerViewModelType { get set }
}

public final class ProfilePhotoPickerViewModel: ProfilePhotoPickerViewModelType {
    public let title: String
    public var currentProfileIcon: ProfileIcon
    public var backgroundTypePickerViewModel: BackgroundTypePickerViewModelType
    public var solidColorPickerViewModel: ColorPickerViewModelType
    public var gradientColorPickerViewModel: GradientColorPickerViewModelType
    
    public init(
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
