//
//  ColorPickerViewControllerTests.swift
//  
//
//  Created by Marcin Borek on 24/10/2023.
//

@testable import UIComponents
import XCTest

final class ColorPickerViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersTitleLabel() {
        let sut = makeSUT(title: "Background color")
        
        _ = sut.view
        
        XCTAssertEqual(sut.titleLabel.text, "Background color")
    }
    
    func test_viewDidLoad_rendersSelectedColorView() {
        let sut = makeSUT(currentColor: .black)
        
        _ = sut.view
        
        XCTAssertEqual(sut.selectedColorView.currentColor, UIColor.black)
    }
    
    func test_viewDidLoad_setsTapGestureRecognizerOnSelectedColorView() {
        let sut = makeSUT()

        _ = sut.view

        XCTAssertEqual(sut.selectedColorView.gestureRecognizers?.count, 1)
    }
    
    func test_handleTap_callsViewModelHandler() {
        let expectation = self.expectation(description: "didTapColorSelector handler called")
        var callsCounter = 0
        let didTapColorSelector: (UIColor) -> Void = { color in
            expectation.fulfill()
            
            callsCounter += 1
            
            XCTAssertEqual(callsCounter, 1)
            XCTAssertEqual(color, .green)
        }
        let sut = makeSUT(currentColor: .green, didTapColorSelector: didTapColorSelector)
        
        _ = sut.view
        sut.handleTap()
        
        wait(for: [expectation], timeout: 0.1)
    }
}

// MARK: Helpers
extension ColorPickerViewControllerTests {
    private func makeSUT(
        title: String = "Background color",
        currentColor: UIColor = .black,
        didTapColorSelector: ((UIColor) -> Void)? = nil) -> ColorPickerViewController {
        let viewModel: ColorPickerViewModelType = ColorPickerViewModel(
            title: title,
            currentColor: currentColor,
            didTapColorSelector: didTapColorSelector ?? { _ in }
        )
        return ColorPickerViewController(viewModel: viewModel)
    }
}
