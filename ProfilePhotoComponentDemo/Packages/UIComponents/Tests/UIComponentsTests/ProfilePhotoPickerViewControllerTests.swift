//
//  ProfilePhotoPickerViewControllerTests.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

@testable import UIComponents
import XCTest

final class ProfilePhotoPickerViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersTitleLabel() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertEqual(sut.titleLabel.text, "Change Icon")
    }
    
    // TODO: Add to ProfileIcon conformance to Equatable to run the below test
//    func test_viewDidLoad_rendersProfileIconView() {
//        let sut = makeSUT()
//
//        _ = sut.view
//
//        XCTAssertEqual(sut.profileIconView.profileIcon, "Change Icon")
//    }
    
    func test_viewDidLoad_rendersBackgroundTypePickerViewController() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertEqual(sut.backgroundTypePickerViewController!.backgroundTypeSegmentedControl.numberOfSegments, 3)
    }
    
    func test_viewDidLoad_rendersGradientColorPickerViewController() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertEqual(
            sut.gradientColorPickerViewController!.startColorPickerViewController!.titleLabel.text,
            "Start color"
        )
        XCTAssertEqual(
            sut.gradientColorPickerViewController!.startColorPickerViewController!.selectedColorView.currentColor,
            .green
        )
    }

    func test_viewDidLoad_rendersSolidColorPickerViewController() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertEqual(sut.solidColorPickerViewController!.titleLabel.text, "Background color")
        XCTAssertEqual(sut.solidColorPickerViewController!.selectedColorView.currentColor, UIColor.green)
    }
}

extension ProfilePhotoPickerViewControllerTests {
    private func makeSUT() -> ProfilePhotoPickerViewController {
        let viewModel = makeProfilePhotoPickerViewModel()
        return ProfilePhotoPickerViewController(viewModel: viewModel)
    }
    
    private func makeProfilePhotoPickerViewModel() -> ProfilePhotoPickerViewModelType {
        let currentProfileIcon: ProfileIcon = .solid(
            ProfileIcon.SolidAttributes(
                initials: "MB",
                backgroundColor: .blue,
                shape: .roundedSquare
            )
        )
        
        let currentBackgroundType: BackgroundType = .solid
        let backgroundTypePickerViewModel = makeBackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType
        )
        let solidColorPickerViewModel = makeSolidColorPickerViewModel()
        let gradientColorPickerViewModel = makeGradientColorPickerViewModel()
        
        return ProfilePhotoPickerViewModel(
            title: "Change Icon",
            currentProfileIcon: currentProfileIcon,
            backgroundTypePickerViewModel: backgroundTypePickerViewModel,
            solidColorPickerViewModel: solidColorPickerViewModel,
            gradientColorPickerViewModel: gradientColorPickerViewModel
        )
    }
    
    private func makeBackgroundTypePickerViewModel(
        currentBackgroundType: BackgroundType = .gradient
    ) -> BackgroundTypePickerViewModelType {
        BackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType,
            backgroundTypeTitles: makeBackgroundTypeTitles()
        )
    }
    
    private func makeSolidColorPickerViewModel() -> ColorPickerViewModelType {
        let didTapColorSelector: (UIColor) -> Void = { _ in }
        let viewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: "Background color",
            currentColor: .green,
            didTapColorSelector: didTapColorSelector
        )
        return viewModel
    }
    
    private func makeBackgroundTypeTitles() -> BackgroundTypeTitles {
        BackgroundTypeTitles(solidTitle: "Solid", gradientTitle: "Gradient", imageTitle: "Image")
    }
    
    private func makeGradientColorPickerViewModel() -> GradientColorPickerViewModelType {
        let didTapColorSelector1: (UIColor) -> Void = { _ in }
        let startColorPickerViewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: "Start color",
            currentColor: .green,
            didTapColorSelector: didTapColorSelector1
        )
        
        let didTapColorSelector2: (UIColor) -> Void = { _ in }
        let endColorPickerViewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: "End color",
            currentColor: .red,
            didTapColorSelector: didTapColorSelector2
        )
        
        return GradientColorPickerViewModel(
            startColorPickerViewModel: startColorPickerViewModel,
            endColorPickerViewModel: endColorPickerViewModel
        )
    }
}
