//
//  GradientColorPickerViewController.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

import UIKit

final class GradientColorPickerViewController: UIViewController {
    // MARK: View model
    private var viewModel: GradientColorPickerViewModelType
    
    // MARK: References to child view controllers
    var startColorPickerViewController: ColorPickerViewController?
    var endColorPickerViewController: ColorPickerViewController?

    // MARK: Subviews
    lazy var stackView: UIStackView = {
        makeStackView()
    }()
    
    // MARK: Methods
    init(viewModel: GradientColorPickerViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: Methods for setting the view hierarchy
extension GradientColorPickerViewController {
    private func setupSubviews() {
        setupStackView()
        setupStartColorPickerView()
        setupEndColorPickerView()
        applySameWidthConditionForTitles()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupStartColorPickerView() {
        let vc = ColorPickerViewController(viewModel: viewModel.startColorPickerViewModel)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
        startColorPickerViewController = vc
    }
    
    private func setupEndColorPickerView() {
        let vc = ColorPickerViewController(viewModel: viewModel.endColorPickerViewModel)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
        endColorPickerViewController = vc
    }
    
    private func applySameWidthConditionForTitles() {
        guard let startColorPickerViewController = startColorPickerViewController,
              let endColorPickerViewController = endColorPickerViewController else {
            return
        }
        startColorPickerViewController.titleLabel.widthAnchor.constraint(equalTo: endColorPickerViewController.titleLabel.widthAnchor).isActive = true
    }
}

// MARK: Factory methods for subviews
extension GradientColorPickerViewController {
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Constants.defaultSpacing
        return stackView
    }
}

// MARK: Constants
extension GradientColorPickerViewController {
    private enum Constants {
        static let defaultSpacing: CGFloat = 16
    }
}
