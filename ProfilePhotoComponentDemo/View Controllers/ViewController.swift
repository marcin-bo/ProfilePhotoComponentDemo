//
//  ViewController.swift
//  ProfilePhotoComponentDemo
//
//  Created by Marcin Borek on 23/10/2023.
//

import UIComponents
import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addProfilePhotoComponentViewController()
    }
    
    private func addProfilePhotoComponentViewController() {
        let viewModel = ProfilePhotoComponentViewModel(
            title: makeWindowTitle(),
            defaultProfileIconShape: makeDefaultProfileIconShape(),
            initials: makeInitials(),
            currentProfileIcon: makeCurrentProfileIcon(),
            backgroundTypeTitles: makeBackgroundTypeTitles(),
            colorPickersTitles: makeColorPickersTitles(),
            defaultPickerColors: makeDefaultPickerColors()
        )
        
        let vc = ProfilePhotoComponentViewController(viewModel: viewModel)
        add(vc)
    }
}

// MARK: Factories
extension ViewController {
    private func makeWindowTitle() -> String {
        "Change Icon"
    }
    
    private func makeCurrentProfileIcon() -> ProfileIcon {
        // Here we could fetch the current icon from a repository
        ProfileIcon.gradient(
            ProfileIcon.GradientAttributes(
                initials: makeInitials(),
                startColor: .blue,
                endColor: .red,
                shape: .roundedSquare
            )
        )
    }

    private func makeDefaultPickerColors() -> DefaultPickerColors{
        DefaultPickerColors(solidColor: .blue, startColor: .blue, endColor: .purple)
    }
    
    private func makeDefaultProfileIconShape() -> ProfileIcon.Shape {
        .roundedSquare
    }
    
    private func makeInitials() -> String {
        "MB"
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
