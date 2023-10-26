//
//  ProfilePhotoPickerViewController.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

import class Combine.AnyCancellable
import UIKit

final class ProfilePhotoPickerViewController: UIViewController {
    // MARK: View model
    private var viewModel: ProfilePhotoPickerViewModelType
    
    // MARK: References to child view controllers
    var backgroundTypePickerViewController: BackgroundTypePickerViewController?
    var solidColorPickerViewController: ColorPickerViewController?
    var gradientColorPickerViewController: GradientColorPickerViewController?
    
    // MARK: Other data
    private var cancellables = Set<AnyCancellable>()

    // MARK: Subviews
    lazy var scrollView: UIScrollView = {
        makeScrollView()
    }()
    
    lazy var contentView: UIView = {
        UIView()
    }()
    
    lazy var stackView: UIStackView = {
        makeStackView()
    }()
    
    lazy var titleLabel: UILabel = {
        makeTitleLabel(title: viewModel.title)
    }()
    
    lazy var profileIconView: ProfileIconView = {
        makeProfileIconView(profileIcon: viewModel.currentProfileIcon)
    }()
    
    // MARK: Methods
    init(viewModel: ProfilePhotoPickerViewModelType) {
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
        setupAppearance()
        setupInitialState()
        bind()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupInitialState() {
        switch viewModel.backgroundTypePickerViewModel.currentBackgroundType {
        case .solid:
            gradientColorPickerViewController?.view.isHidden = true
        case .gradient:
            solidColorPickerViewController?.view.isHidden = true
        case .image:
            solidColorPickerViewController?.view.isHidden = true
            gradientColorPickerViewController?.view.isHidden = true
        }
    }
    
    private func bind() {
        bindBackgroundTypePicker()
        bindSolidColorPicker()
        bindGradientColorPicker()
    }
    
    private func bindBackgroundTypePicker() {
        viewModel
            .backgroundTypePickerViewModel
            .currentBackgroundTypePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] type in
                guard let strongSelf = self else { return }
                switch type {
                case .solid:
                    strongSelf.solidColorPickerViewController?.view.fadeIn()
                    strongSelf.gradientColorPickerViewController?.view.fadeOut()
                case .gradient:
                    strongSelf.solidColorPickerViewController?.view.fadeOut()
                    strongSelf.gradientColorPickerViewController?.view.fadeIn()
                case .image:
                    strongSelf.solidColorPickerViewController?.view.fadeOut()
                    strongSelf.gradientColorPickerViewController?.view.fadeOut()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSolidColorPicker() {
        viewModel
            .solidColorPickerViewModel
            .currentColorPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] color in
                guard let strongSelf = self else { return }
                let attributes = ProfileIcon.SolidAttributes(
                    initials: strongSelf.viewModel.initials,
                    backgroundColor: color,
                    shape: strongSelf.viewModel.defaultProfileIconShape
                )
                self?.profileIconView.profileIcon = .solid(attributes)
            }
            .store(in: &cancellables)
    }
    
    private func bindGradientColorPicker() {
        viewModel
            .gradientColorPickerViewModel
            .startColorPickerViewModel
            .currentColorPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] color in
                guard let strongSelf = self else { return }
                let attributes = ProfileIcon.GradientAttributes(
                    initials: strongSelf.viewModel.initials,
                    startColor: color,
                    endColor: strongSelf.viewModel.gradientColorPickerViewModel.endColorPickerViewModel.currentColor,
                    shape: strongSelf.viewModel.defaultProfileIconShape
                )
                self?.profileIconView.profileIcon = .gradient(attributes)
            }
            .store(in: &cancellables)
        
        viewModel
            .gradientColorPickerViewModel
            .endColorPickerViewModel
            .currentColorPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] color in
                guard let strongSelf = self else { return }
                let attributes = ProfileIcon.GradientAttributes(
                    initials: strongSelf.viewModel.initials,
                    startColor: strongSelf.viewModel.gradientColorPickerViewModel.startColorPickerViewModel.currentColor,
                    endColor: color,
                    shape: strongSelf.viewModel.defaultProfileIconShape
                )
                self?.profileIconView.profileIcon = .gradient(attributes)
            }
            .store(in: &cancellables)
    }
}

// MARK: Methods for setting the view hierarchy
extension ProfilePhotoPickerViewController {
    
    private func setupSubviews() {
        setupTitleLabel()
        setupScrollView()
        setupContentView()
        setupStackView()
        setupBackgroundTypePickerViewController()
        setupSolidColorPickerViewController()
        setupGradientColorPickerViewController()
        setupProfileIconView()
        applySameWidthConditionForColorPickerTitles()
    }
    
    private func setupBackgroundTypePickerViewController() {
        let vc = BackgroundTypePickerViewController(viewModel: viewModel.backgroundTypePickerViewModel)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
        backgroundTypePickerViewController = vc
    }
    
    private func setupSolidColorPickerViewController() {
        let vc = ColorPickerViewController(viewModel: viewModel.solidColorPickerViewModel)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
        solidColorPickerViewController = vc
    }
    
    private func setupGradientColorPickerViewController() {
        let vc = GradientColorPickerViewController(viewModel: viewModel.gradientColorPickerViewModel)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
        gradientColorPickerViewController = vc
    }
    
    private func applySameWidthConditionForColorPickerTitles() {
        guard let solidColorPickerViewController = solidColorPickerViewController,
              let startColorPickerViewController = gradientColorPickerViewController?.startColorPickerViewController else {
            return
        }
        solidColorPickerViewController.titleLabel.widthAnchor.constraint(
            equalTo: startColorPickerViewController.titleLabel.widthAnchor
        ).isActive = true
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.defaultSpacing).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.defaultSpacing).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupProfileIconView() {
        let containerView = UIView()
        stackView.addArrangedSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(profileIconView)
        profileIconView.translatesAutoresizingMaskIntoConstraints = false
        profileIconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileIconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileIconView.widthAnchor.constraint(equalToConstant: Constants.profilePhotoWidth).isActive = true
        profileIconView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
}

// MARK: Factory methods for subviews
extension ProfilePhotoPickerViewController {
    
    private func makeTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize, weight: .bold)
        titleLabel.text = title
        titleLabel.textColor = .label
        return titleLabel
    }
        
    private func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Constants.defaultSpacing
        return stackView
    }
    
    private func makeProfileIconView(profileIcon: ProfileIcon) -> ProfileIconView {
        ProfileIconView(frame: .zero, profileIcon: profileIcon)
    }
}

// MARK: Constants
extension ProfilePhotoPickerViewController {
    private enum Constants {
        static let defaultSpacing: CGFloat = 16
        static let profilePhotoWidth: CGFloat = 150
        static let titleLabelFontSize: CGFloat = 20
    }
}
