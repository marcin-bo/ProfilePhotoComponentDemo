//
//  SelectedColorView.swift
//  
//
//  Created by Marcin Borek on 23/10/2023.
//

import UIKit

final class SelectedColorView: UIView {
    var currentColor: UIColor {
        didSet {
            updateAppearance()
        }
    }
    
    private lazy var arrowImageView: UIImageView = {
        makeArrowImageView()
    }()
    
    required init(frame: CGRect, currentColor: UIColor) {
        self.currentColor = currentColor
        super.init(frame: frame)
        setupSubviews()
        updateAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
    }
}

// MARK: Methods for setting the view hierarchy and appearance
extension SelectedColorView {
    private func setupSubviews() {
        // arrowImageView
        addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultSpacing).isActive = true
        arrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.defaultSpacing).isActive = true
        arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultSpacing).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultSpacing).isActive = true
        arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func updateAppearance() {
        let borderColor: UIColor = calculateBorderAndTintColor(for: currentColor)
        layer.backgroundColor = currentColor.cgColor
        layer.borderWidth = Constants.borderViewWidth
        layer.borderColor = borderColor.cgColor
    }
}

// MARK: Factory methods for subviews
extension SelectedColorView {
    private func makeArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = calculateBorderAndTintColor(for: currentColor)
        return imageView
    }
    
    /// Calculates the border and image tint color
    ///
    /// TODO: Improve tint calculation for colors close to white to make the image more visible for the user.
    private func calculateBorderAndTintColor(for backgroundColor: UIColor) -> UIColor {
        backgroundColor == .white ? .black : .white
    }
}

// MARK: Constants
extension SelectedColorView {
    private enum Constants {
        static let defaultSpacing: CGFloat = 8
        static let borderViewWidth: CGFloat = 2
    }
}
