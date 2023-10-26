//
//  ProfilePhotoComponentViewModel.swift
//  
//
//  Created by Marcin Borek on 26/10/2023.
//

public protocol ProfilePhotoComponentViewModelType {
    var title: String { get }
    var defaultProfileIconShape: ProfileIcon.Shape { get }
    var initials: String { get }
    var currentProfileIcon: ProfileIcon { get }
    var backgroundTypeTitles: BackgroundTypeTitles { get }
    var colorPickersTitles: ColorPickersTitles { get }
    var defaultPickerColors: DefaultPickerColors { get }
}

public final class ProfilePhotoComponentViewModel: ProfilePhotoComponentViewModelType {
    // Output
    public let title: String
    public let defaultProfileIconShape: ProfileIcon.Shape
    public let initials: String
    public let currentProfileIcon: ProfileIcon
    public let backgroundTypeTitles: BackgroundTypeTitles
    public let colorPickersTitles: ColorPickersTitles
    public let defaultPickerColors: DefaultPickerColors
    
    public init(
        title: String,
        defaultProfileIconShape: ProfileIcon.Shape,
        initials: String,
        currentProfileIcon: ProfileIcon,
        backgroundTypeTitles: BackgroundTypeTitles,
        colorPickersTitles: ColorPickersTitles,
        defaultPickerColors: DefaultPickerColors
    ) {
        self.title = title
        self.defaultProfileIconShape = defaultProfileIconShape
        self.initials = initials
        self.currentProfileIcon = currentProfileIcon
        self.backgroundTypeTitles = backgroundTypeTitles
        self.colorPickersTitles = colorPickersTitles
        self.defaultPickerColors = defaultPickerColors
    }
}
