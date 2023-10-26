//
//  ProfilePhotoComponentViewController.swift
//  
//
//  Created by Marcin Borek on 26/10/2023.
//

import Combine
import UIKit

public final class ProfilePhotoComponentViewController: UIViewController {
    private let viewModel: ProfilePhotoComponentViewModelType
    private var cancellable: AnyCancellable?
    
    var endColorPickerViewModel: ColorPickerViewModelType?
    var solidColorPickerViewModel: ColorPickerViewModelType?
    var startColorPickerViewModel: ColorPickerViewModelType?

    // MARK: Methods
    public init(viewModel: ProfilePhotoComponentViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addProfilePhotoPickerViewController(viewModel: viewModel)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        child.didMove(toParent: self)
    }
}

// MARK: ProfilePhotoPickerViewController
extension ProfilePhotoComponentViewController {
    private func addProfilePhotoPickerViewController(
        viewModel: ProfilePhotoComponentViewModelType
    ) {
        let vc = makeProfilePhotoPickerViewController(
            viewModel: viewModel
        )
        add(vc)
    }
    
    private func makeProfilePhotoPickerViewController(
        viewModel: ProfilePhotoComponentViewModelType
    ) -> ProfilePhotoPickerViewController {
        let viewModel = makeProfilePhotoPickerViewModel(
            viewModel: viewModel
        )
        return ProfilePhotoPickerViewController(viewModel: viewModel)
    }
    
    private func makeProfilePhotoPickerViewModel(
        viewModel: ProfilePhotoComponentViewModelType
    ) -> ProfilePhotoPickerViewModelType {
        let currentBackgroundType: BackgroundType = viewModel.currentProfileIcon.backgroundType
        
        let backgroundTypePickerViewModel = makeBackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType,
            backgroundTypeTitles: viewModel.backgroundTypeTitles
        )
        let solidColorPickerViewModel: ColorPickerViewModelType = {
            var currentColor: UIColor {
                if case .solid(let attributes) = viewModel.currentProfileIcon {
                    return attributes.backgroundColor
                } else {
                    return DefaultPickerColors.solidColor
                }
            }
            return makeColorPickerViewModel(
                title: viewModel.colorPickersTitles.solidColorTitle,
                currentColor: currentColor,
                pickerType: .solidColor
            )
        }()
        self.solidColorPickerViewModel = solidColorPickerViewModel
       
        let startColorPickerViewModel: ColorPickerViewModelType = {
            var currentColor: UIColor {
                if case .gradient(let attributes) = viewModel.currentProfileIcon {
                    return attributes.startColor
                } else {
                    return DefaultPickerColors.startColor
                }
            }
            return makeColorPickerViewModel(
                title: viewModel.colorPickersTitles.startColorTitle,
                currentColor: currentColor,
                pickerType: .startColor)
        }()
        self.startColorPickerViewModel = startColorPickerViewModel
        
        let endColorPickerViewModel = {
            var currentColor: UIColor {
                if case .gradient(let attributes) = viewModel.currentProfileIcon {
                    return attributes.endColor
                } else {
                    return DefaultPickerColors.endColor
                }
            }
            return makeColorPickerViewModel(
                title: viewModel.colorPickersTitles.endColorTitle,
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
            title: viewModel.title,
            defaultProfileIconShape: viewModel.defaultProfileIconShape,
            initials: viewModel.initials,
            currentProfileIcon: viewModel.currentProfileIcon,
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
extension ProfilePhotoComponentViewController {
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
extension ProfilePhotoComponentViewController {
    
    /// This singleton makes sure that there can only be one UIColorPickerViewController at all times
    /// It's fixes issues on Mac Catalyst with UIColorPickerViewController
    private final class ColorPickerSingleton {
        static let shared = UIColorPickerViewController()
    }
    
    private func openColorPicker(with currentColor: UIColor, for pickerType: PickerType) {
        let picker = ColorPickerSingleton.shared
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
extension ProfilePhotoComponentViewController {
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
extension ProfilePhotoComponentViewController {
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
