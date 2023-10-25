//
//  BackgroundTypePickerViewController.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

import UIKit

public final class BackgroundTypePickerViewController: UIViewController {
    private let viewModel: BackgroundTypePickerViewModelType
    
    lazy var backgroundTypeSegmentedControl: UISegmentedControl = {
        makeBackgroundTypeSegmentedControl(
            currentBackgroundType: viewModel.currentBackgroundType,
            backgroundTypeTitles: viewModel.backgroundTypeTitles
        )
    }()

    public init(viewModel: BackgroundTypePickerViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setCurrentBackgroundType()
    }
    
    private func setCurrentBackgroundType() {
        switch viewModel.currentBackgroundType {
        case .solid:
            backgroundTypeSegmentedControl.selectedSegmentIndex = 0
        case .gradient:
            backgroundTypeSegmentedControl.selectedSegmentIndex = 1
        case .image:
            backgroundTypeSegmentedControl.selectedSegmentIndex = 2
        }
    }
}

// MARK: Methods for setting the view hierarchy
extension BackgroundTypePickerViewController {
    
    private func setupSubviews() {
        view.addSubview(backgroundTypeSegmentedControl)
        backgroundTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        backgroundTypeSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundTypeSegmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: Factory methods for subviews
extension BackgroundTypePickerViewController {
    
    private func makeBackgroundTypeSegmentedControl(
        currentBackgroundType: BackgroundType,
        backgroundTypeTitles: BackgroundTypeTitles
    ) -> UISegmentedControl {
        
        let action1 = UIAction(title: backgroundTypeTitles.solidTitle) { [weak self] _ in
            print("Solid selected")
            self?.viewModel.didUpdateBackgroundType(.solid)
        }
        let action2 = UIAction(title: backgroundTypeTitles.gradientTitle) { [weak self] _ in
            print("Gradient selected")
            self?.viewModel.didUpdateBackgroundType(.gradient)
        }
        let action3 = UIAction(title: backgroundTypeTitles.imageTitle) { [weak self] _ in
            print("Image selected")
            self?.viewModel.didUpdateBackgroundType(.image)
        }
        
        return UISegmentedControl(items: [action1, action2, action3])
    }
}