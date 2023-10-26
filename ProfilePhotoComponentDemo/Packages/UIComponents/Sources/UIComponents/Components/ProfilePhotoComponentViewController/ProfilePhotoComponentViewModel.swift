//
//  ProfilePhotoComponentViewModel.swift
//  
//
//  Created by Marcin Borek on 26/10/2023.
//

public protocol ProfilePhotoComponentViewModelType {
    var title: String { get }
    var currentProfileIcon: ProfileIcon { get }
    var backgroundTypeTitles: BackgroundTypeTitles { get }
    var colorPickersTitles: ColorPickersTitles { get }
}

public final class ProfilePhotoComponentViewModel: ProfilePhotoComponentViewModelType {
    // Output
    public let title: String
    public let currentProfileIcon: ProfileIcon
    public let backgroundTypeTitles: BackgroundTypeTitles
    public let colorPickersTitles: ColorPickersTitles
    
    public init(
        title: String,
        currentProfileIcon: ProfileIcon,
        backgroundTypeTitles: BackgroundTypeTitles,
        colorPickersTitles: ColorPickersTitles
    ) {
        self.title = title
        self.currentProfileIcon = currentProfileIcon
        self.backgroundTypeTitles = backgroundTypeTitles
        self.colorPickersTitles = colorPickersTitles
    }
}
