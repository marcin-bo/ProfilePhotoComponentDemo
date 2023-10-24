//
//  ProfileIconView.swift
//  
//
//  Created by Marcin Borek on 23/10/2023.
//

import UIKit

public final class ProfileIconView: UIView {
    // MARK: Data
    private var profileIcon: ProfileIcon {
        didSet {
            updateView()
        }
    }
    
    // MARK: Subviews
    private lazy var contentView: UIView = {
        UIView()
    }()
    
    private lazy var gradientView: UIView = {
        UIView()
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        makeBackgroundImageView()
    }()
    
    private lazy var initialsLabel: UILabel = {
        makeInitialsLabel()
    }()
    
    // MARK: Vars
    private var gradientLayer: CAGradientLayer?
    private var cornerRadiusRatio: CGFloat = 0
    
    // MARK: Methods
    public required init(frame: CGRect, profileIcon: ProfileIcon) {
        self.profileIcon = profileIcon
        super.init(frame: frame)
        setupSubviews()
        updateView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        initialsLabel.font = UIFont.systemFont(ofSize: contentView.frame.height / 2, weight: .bold)
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        switch profileIcon {
        case .solid(_):
            contentView.layer.cornerRadius = contentView.frame.height * cornerRadiusRatio
        case .gradient(_):
            gradientLayer?.frame = contentView.bounds
            gradientLayer?.cornerRadius = contentView.frame.height * cornerRadiusRatio
        case .image(_):
            backgroundImageView.layer.cornerRadius = contentView.frame.height * cornerRadiusRatio
        }
    }
    
    public func update(profileIcon: ProfileIcon) {
        self.profileIcon = profileIcon
    }
}

// MARK: Methods for setting the view hierarchy
extension ProfileIconView {
    private func setupSubviews() {
        setupContentView()
        setupInitialsLabel()
        setupGradientView()
        setupBackgroundImageView()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func setupInitialsLabel() {
        contentView.addSubview(initialsLabel)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        initialsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        initialsLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        initialsLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    private func setupGradientView() {
        contentView.insertSubview(gradientView, belowSubview: initialsLabel)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func setupBackgroundImageView() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func updateView() {
        switch profileIcon {
        case .solid(let attributes):
            updateCornerRadiusRatio(shape: attributes.shape)
            enableSolidBackground(attributes)
            disableGradientView()
            disableCustomBackground()
        case .gradient(let attributes):
            updateCornerRadiusRatio(shape: attributes.shape)
            disableSolidBackground()
            enableGradientView(attributes)
            disableCustomBackground()
        case .image(let attributes):
            updateCornerRadiusRatio(shape: attributes.shape)
            disableSolidBackground()
            disableGradientView()
            enableCustomBackground(attributes)
        }
    }
    
    private func updateCornerRadiusRatio(shape: ProfileIcon.Shape) {
        cornerRadiusRatio = shape == .roundedSquare ? CornerRadiusRatio.roundedSquare : CornerRadiusRatio.circle
    }
    
    private func enableSolidBackground(_ attributes: ProfileIcon.SolidAttributes) {
        initialsLabel.text = attributes.initials
        contentView.backgroundColor = attributes.backgroundColor
    }
    
    private func disableSolidBackground() {
        contentView.backgroundColor = .clear
    }
    
    private func enableGradientView(_ attributes: ProfileIcon.GradientAttributes) {
        initialsLabel.text = attributes.initials
        gradientView.isHidden = false
        let gradientLayer = makeGradientLayer(startColor: attributes.startColor, endColor: attributes.endColor)
        gradientView.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    private func disableGradientView() {
        gradientView.isHidden = true
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
    private func enableCustomBackground(_ attributes: ProfileIcon.ImageAttributes) {
        initialsLabel.text = nil
        backgroundImageView.image = attributes.image
        backgroundImageView.isHidden = false
    }
    
    private func disableCustomBackground() {
        initialsLabel.isHidden = false
        backgroundImageView.isHidden = true
        backgroundImageView.image = nil
    }
}

// MARK: Factory methods for subviews
extension ProfileIconView {
    private func makeInitialsLabel() -> UILabel {
        let initialsLabel = UILabel()
        initialsLabel.numberOfLines = 1
        initialsLabel.adjustsFontSizeToFitWidth = true
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = .white
        return initialsLabel
    }
    
    private func makeBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func makeGradientLayer(startColor: UIColor, endColor: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor, endColor].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }
}

// MARK: Constants
extension ProfileIconView {
    private enum CornerRadiusRatio {
        /// Used to calculate layer corner radius.
        /// The value is a multiplier of view height:
        /// - 0.2 for square with rounded corners at 20% of profile photo height
        /// - 0.5 for circle
        static let circle: CGFloat = 0.5
        static let roundedSquare: CGFloat = 0.2
    }
}
