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
        addColorPickerViewController()
    }

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
                self?.colorPickerViewModel?.input.update(currentColor: color)
            }
        
        self.present(picker, animated: true, completion: nil)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
