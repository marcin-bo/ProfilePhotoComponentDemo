//
//  ColorPickerViewController.swift
//  
//
//  Created by Marcin Borek on 24/10/2023.
//

import class Combine.AnyCancellable
import UIKit

public final class ColorPickerViewController: UIViewController {
    // MARK: View model
    private var viewModel: ColorPickerViewModelType
    
    // MARK: Subviews
    lazy var stackView: UIStackView = {
        makeStackView()
    }()
    
    lazy var titleLabel: UILabel = {
        makeTitleLabel(title: viewModel.output.title)
    }()
    
    lazy var selectedColorView: SelectedColorView = {
        makeSelectedColorView()
    }()
    
    // MARK: Other data
    private var cancellable: AnyCancellable?
    
    // MARK: Methods
    public init(viewModel: ColorPickerViewModelType) {
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
        setupTapGestureRecognizer()
        bind()
    }
    
    private func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectedColorView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        viewModel.input.didTapColorSelector(viewModel.output.currentColor)
    }
    
    private func bind() {
        self.cancellable = viewModel
            .output
            .currentColorPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] color in
                self?.selectedColorView.currentColor = color
            }
    }
}

// MARK: Methods for setting the view hierarchy
extension ColorPickerViewController {
    private func setupSubviews() {
        setupStackView()
        setupTitleLabel()
        setupSelectedColorView()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSelectedColorView() {
        stackView.addArrangedSubview(selectedColorView)
        selectedColorView.translatesAutoresizingMaskIntoConstraints = false
        selectedColorView.widthAnchor.constraint(equalToConstant: Constants.selectedColorViewWidth).isActive = true
        selectedColorView.widthAnchor.constraint(equalTo: selectedColorView.heightAnchor, multiplier: 1).isActive = true
    }
}

// MARK: Factory methods for subviews
extension ColorPickerViewController {
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Constants.defaultSpacing
        return stackView
    }
    
    private func makeTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize, weight: .semibold)
        titleLabel.text = title
        titleLabel.textColor = .label
        return titleLabel
    }
    
    private func makeSelectedColorView() -> SelectedColorView {
        SelectedColorView(frame: .zero, currentColor: viewModel.output.currentColor)
    }
}

// MARK: Constants
extension ColorPickerViewController {
    private enum Constants {
        static let defaultSpacing: CGFloat = 16
        static let selectedColorViewWidth: CGFloat = 40
        static let titleLabelFontSize: CGFloat = 16
    }
}
