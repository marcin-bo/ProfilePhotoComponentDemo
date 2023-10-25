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
    
    var colorPickerViewModel: ColorPickerViewModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientColorPickerViewController()
        // addBackgroundTypePickerViewController()
        // addColorPickerViewController()
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
        child.didMove(toParent: self)
    }
}

// MARK: ColorPickerViewController
extension ViewController {
    private func addColorPickerViewController() {
        let didTapColorSelector: (UIColor) -> Void = { [weak self] currentColor in
            self?.openColorPicker(with: currentColor)
        }
        let viewModel: ColorPickerViewModelType = ColorPickerViewModel(title: "Background color", currentColor: .green, didTapColorSelector: didTapColorSelector)
        let vc = ColorPickerViewController(viewModel: viewModel)
        add(vc)
        
        self.colorPickerViewModel = viewModel
    }

    func openColorPicker(with currentColor: UIColor) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = currentColor
        
        //  Subscribing selectedColor property changes.
        self.cancellable = picker.publisher(for: \.selectedColor)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] color in
                self?.colorPickerViewModel?.update(currentColor: color)
            }
        
        self.present(picker, animated: true, completion: nil)
    }
}

// MARK: BackgroundTypePickerViewController
extension ViewController {
    private func addBackgroundTypePickerViewController() {
        let vc = makeBackgroundTypePickerViewController (
            currentBackgroundType: .gradient,
            didUpdateBackgroundType: nil
        )
        add(vc)
    }
    
    private func makeBackgroundTypePickerViewController(
        currentBackgroundType: BackgroundType = .gradient,
        didUpdateBackgroundType: ((BackgroundType) -> Void)? = nil
    ) -> BackgroundTypePickerViewController {
        let viewModel: BackgroundTypePickerViewModelType = BackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType,
            backgroundTypeTitles: makeBackgroundTypeTitles(),
            didUpdateBackgroundType: didUpdateBackgroundType ?? { _ in }
        )
        return BackgroundTypePickerViewController(viewModel: viewModel)
    }
    
    private func makeBackgroundTypeTitles() -> BackgroundTypeTitles {
        BackgroundTypeTitles(solidTitle: "Solid", gradientTitle: "Gradient", imageTitle: "Image")
    }
}

// MARK: GradientColorPickerViewController
extension ViewController {
    private func addGradientColorPickerViewController() {
        let didTapColorSelector1: (UIColor) -> Void = { currentColor in
            print("Did tap start color selector \(currentColor)")
        }
        let startColorPickerViewModel: ColorPickerViewModelType = ColorPickerViewModel(title: "Start color", currentColor: .green, didTapColorSelector: didTapColorSelector1)
        
        let didTapColorSelector2: (UIColor) -> Void = { currentColor in
            print("Did tap end color selector \(currentColor)")
        }
        let endColorPickerViewModel: ColorPickerViewModelType = ColorPickerViewModel(title: "End color", currentColor: .red, didTapColorSelector: didTapColorSelector2)
        
        let viewModel = GradientColorPickerViewModel(
            startColorPickerViewModel: startColorPickerViewModel,
            endColorPickerViewModel: endColorPickerViewModel)
        let vc = GradientColorPickerViewController(viewModel: viewModel)
        add(vc)
    }
}
