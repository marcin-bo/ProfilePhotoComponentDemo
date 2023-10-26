//
//  ViewController.swift
//  ProfilePhotoComponentDemo
//
//  Created by Marcin Borek on 23/10/2023.
//

import Combine
import UIComponents
import UIKit

final class ViewController: UIViewController {
    private var cancellable: AnyCancellable?
    
    var endColorPickerViewModel: ColorPickerViewModelType?
    var solidColorPickerViewModel: ColorPickerViewModelType?
    var startColorPickerViewModel: ColorPickerViewModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentProfileIcon: ProfileIcon = .gradient(
            ProfileIcon.GradientAttributes(
                initials: "MB",
                startColor: .blue,
                endColor: .red,
                shape: .roundedSquare
            )
        )
        
        let backgroundTypeTitles = makeBackgroundTypeTitles()
        let colorPickersTitles = makeColorPickersTitles()
        
        addProfilePhotoPickerViewController(
            title: "Change Icon",
            currentProfileIcon: currentProfileIcon,
            backgroundTypeTitles: backgroundTypeTitles,
            colorPickersTitles: colorPickersTitles
        )
    }
    
    private func makeBackgroundTypeTitles() -> BackgroundTypeTitles {
        BackgroundTypeTitles(solidTitle: "Solid", gradientTitle: "Gradient", imageTitle: "Image")
    }
    
    private func makeColorPickersTitles() -> ColorPickersTitles {
        ColorPickersTitles(
            solidColorTitle: "Background color",
            startColorTitle: "Start color",
            endColorTitle: "End color"
        )
    }
    
    struct ColorPickersTitles {
        let solidColorTitle: String
        let startColorTitle: String
        let endColorTitle: String
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        child.didMove(toParent: self)
    }
}

// MARK: ProfilePhotoPickerViewController
extension ViewController {
    private func addProfilePhotoPickerViewController(
        title: String,
        currentProfileIcon: ProfileIcon,
        backgroundTypeTitles: BackgroundTypeTitles,
        colorPickersTitles: ColorPickersTitles
    ) {
        let vc = makeProfilePhotoPickerViewController(
            title: title,
            currentProfileIcon: currentProfileIcon,
            backgroundTypeTitles: backgroundTypeTitles,
            colorPickersTitles: colorPickersTitles
        )
        add(vc)
    }
    
    private func makeProfilePhotoPickerViewController(
        title: String,
        currentProfileIcon: ProfileIcon,
        backgroundTypeTitles: BackgroundTypeTitles,
        colorPickersTitles: ColorPickersTitles
    ) -> ProfilePhotoPickerViewController {
        let viewModel = makeProfilePhotoPickerViewModel(
            title: title,
            currentProfileIcon: currentProfileIcon,
            backgroundTypeTitles: backgroundTypeTitles,
            colorPickersTitles: colorPickersTitles
        )
        return ProfilePhotoPickerViewController(viewModel: viewModel)
    }
    
    private func makeProfilePhotoPickerViewModel(
        title: String,
        currentProfileIcon: ProfileIcon,
        backgroundTypeTitles: BackgroundTypeTitles,
        colorPickersTitles: ColorPickersTitles
    ) -> ProfilePhotoPickerViewModelType {
        let currentBackgroundType: BackgroundType = currentProfileIcon.backgroundType
        
        let backgroundTypePickerViewModel = makeBackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType,
            backgroundTypeTitles: backgroundTypeTitles
        )
        let solidColorPickerViewModel: ColorPickerViewModelType = {
            var currentColor: UIColor {
                if case .solid(let attributes) = currentProfileIcon {
                    return attributes.backgroundColor
                } else {
                    return DefaultPickerColors.solidColor
                }
            }
            return makeColorPickerViewModel(
                title: colorPickersTitles.solidColorTitle,
                currentColor: currentColor,
                pickerType: .solidColor
            )
        }()
        self.solidColorPickerViewModel = solidColorPickerViewModel
       
        let startColorPickerViewModel: ColorPickerViewModelType = {
            var currentColor: UIColor {
                if case .gradient(let attributes) = currentProfileIcon {
                    return attributes.startColor
                } else {
                    return DefaultPickerColors.startColor
                }
            }
            return makeColorPickerViewModel(
                title: colorPickersTitles.startColorTitle,
                currentColor: currentColor,
                pickerType: .startColor)
        }()
        self.startColorPickerViewModel = startColorPickerViewModel
        
        let endColorPickerViewModel = {
            var currentColor: UIColor {
                if case .gradient(let attributes) = currentProfileIcon {
                    return attributes.endColor
                } else {
                    return DefaultPickerColors.endColor
                }
            }
            return makeColorPickerViewModel(
                title: colorPickersTitles.endColorTitle,
                currentColor: currentColor,
                pickerType: .endColor
            )
        }()
        self.endColorPickerViewModel = endColorPickerViewModel
        
        let gradientColorPickerViewModel = GradientColorPickerViewModel(
            startColorPickerViewModel: startColorPickerViewModel,
            endColorPickerViewModel: endColorPickerViewModel
        )
        
        return ProfilePhotoPickerViewModel(
            title: title,
            currentProfileIcon: currentProfileIcon,
            backgroundTypePickerViewModel: backgroundTypePickerViewModel,
            solidColorPickerViewModel: solidColorPickerViewModel,
            gradientColorPickerViewModel: gradientColorPickerViewModel
        )
    }
    
    private enum DefaultPickerColors {
        static let solidColor: UIColor = .blue
        static let startColor: UIColor = .blue
        static let endColor: UIColor = .purple
    }
}

// MARK: ColorPickerViewController
extension ViewController {
    private func makeColorPickerViewModel(
        title: String,
        currentColor: UIColor,
        pickerType: PickerType
    ) -> ColorPickerViewModelType {
        let didTapColorSelector: (UIColor) -> Void = { [weak self] currentColor in
            self?.openColorPicker(with: currentColor, for: pickerType)
        }
        let viewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: title,
            currentColor: currentColor,
            didTapColorSelector: didTapColorSelector
        )
        return viewModel
    }
}

enum PickerType {
    case endColor
    case solidColor
    case startColor
}

// MARK Opening UIColorPickerViewController
extension ViewController {
    private func openColorPicker(with currentColor: UIColor, for pickerType: PickerType) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = currentColor
        
        // Subscribing selectedColor property changes
        self.cancellable = picker.publisher(for: \.selectedColor)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] color in
                switch pickerType {
                case .endColor:
                    self?.endColorPickerViewModel?.update(currentColor: color)
                case .solidColor:
                    self?.solidColorPickerViewModel?.update(currentColor: color)
                case .startColor:
                    self?.startColorPickerViewModel?.update(currentColor: color)
                }
            }
        
        self.present(picker, animated: true, completion: nil)
    }
}

// MARK: BackgroundTypePickerViewController
extension ViewController {
    private func makeBackgroundTypePickerViewModel(
        currentBackgroundType: BackgroundType,
        backgroundTypeTitles: BackgroundTypeTitles
    ) -> BackgroundTypePickerViewModelType {
        BackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType,
            backgroundTypeTitles: backgroundTypeTitles
        )
    }
}

// MARK: GradientColorPickerViewController
extension ViewController {
    private func makeStartColorPickerViewModel(title: String, currentColor: UIColor) -> ColorPickerViewModelType {
        let didTapColorSelector: (UIColor) -> Void = { [weak self] currentColor in
            self?.openColorPicker(with: currentColor, for: .startColor)
        }
        let viewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: title,
            currentColor: currentColor,
            didTapColorSelector: didTapColorSelector
        )
        return viewModel
    }
    
    private func makeEndColorPickerViewModel(title: String, currentColor: UIColor) -> ColorPickerViewModelType {
        let didTapColorSelector: (UIColor) -> Void = { [weak self] currentColor in
            self?.openColorPicker(with: currentColor, for: .endColor)
        }
        let viewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: title,
            currentColor: currentColor,
            didTapColorSelector: didTapColorSelector
        )
        return viewModel
    }
}
