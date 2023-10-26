//
//  BackgroundTypePickerViewControllerTests.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

@testable import UIComponents
import XCTest

final class BackgroundTypePickerViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersSegmentedControl() {
        let sut = makeSUT(backgroundTypeTitles: makeBackgroundTypeTitles())
        
        _ = sut.view
        
        XCTAssertEqual(sut.backgroundTypeSegmentedControl.numberOfSegments, 2)
        XCTAssertEqual(sut.backgroundTypeSegmentedControl.titleForSegment(at: 0), "Solid")
        XCTAssertEqual(sut.backgroundTypeSegmentedControl.titleForSegment(at: 1), "Gradient")
        // XCTAssertEqual(sut.backgroundTypeSegmentedControl.titleForSegment(at: 2), "Image")
    }

    func test_viewDidLoad_whenSolidIsCurrentBackground_setsSolidInSegmentedControl() {
        let sut = makeSUT(currentBackgroundType: .solid, backgroundTypeTitles: makeBackgroundTypeTitles())
        
        _ = sut.view
        
        XCTAssertEqual(sut.backgroundTypeSegmentedControl.selectedSegmentIndex, 0)
    }
    
    func test_viewDidLoad_whenGradientIsCurrentBackground_setsGradientInSegmentedControl() {
        let sut = makeSUT(currentBackgroundType: .gradient, backgroundTypeTitles: makeBackgroundTypeTitles())
        
        _ = sut.view
        
        XCTAssertEqual(sut.backgroundTypeSegmentedControl.selectedSegmentIndex, 1)
    }
    
    // TODO: unit test commented out since I decided to not to support images in profile icons yet
//    func test_viewDidLoad_whenImageIsCurrentBackground_setsImageInSegmentedControl() {
//        let sut = makeSUT(currentBackgroundType: .image, backgroundTypeTitles: makeBackgroundTypeTitles())
//
//        _ = sut.view
//
//        XCTAssertEqual(sut.backgroundTypeSegmentedControl.selectedSegmentIndex, 2)
//    }
    
    // TODO: Test binding behaviour
}

extension BackgroundTypePickerViewControllerTests {
    private func makeSUT(
        currentBackgroundType: BackgroundType = .gradient,
        backgroundTypeTitles: BackgroundTypeTitles
    ) -> BackgroundTypePickerViewController {
        let viewModel: BackgroundTypePickerViewModelType = BackgroundTypePickerViewModel(
            currentBackgroundType: currentBackgroundType,
            backgroundTypeTitles: backgroundTypeTitles
        )
        return BackgroundTypePickerViewController(viewModel: viewModel)
    }
    
    private func makeBackgroundTypeTitles() -> BackgroundTypeTitles {
        BackgroundTypeTitles(solidTitle: "Solid", gradientTitle: "Gradient", imageTitle: "Image")
    }
}
