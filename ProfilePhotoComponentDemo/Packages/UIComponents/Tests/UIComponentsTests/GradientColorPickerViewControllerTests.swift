//
//  GradientColorPickerViewControllerTests.swift
//  
//
//  Created by Marcin Borek on 25/10/2023.
//

@testable import UIComponents
import XCTest

final class GradientColorPickerViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersStartColorPickerView() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertEqual(sut.startColorPickerViewController!.titleLabel.text, "Start color")
        XCTAssertEqual(sut.startColorPickerViewController!.selectedColorView.currentColor, .green)
    }
    
    func test_viewDidLoad_rendersEndColorPickerView() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertEqual(sut.endColorPickerViewController!.titleLabel.text, "End color")
        XCTAssertEqual(sut.endColorPickerViewController!.selectedColorView.currentColor, .red)
    }
}

extension GradientColorPickerViewControllerTests {
    private func makeSUT() -> GradientColorPickerViewController {
        let didTapColorSelector: (UIColor) -> Void = { _ in }
        let startColorPickerViewModel: ColorPickerViewModelType = ColorPickerViewModel(title: "Start color", currentColor: .green, didTapColorSelector: didTapColorSelector)
        let endColorPickerViewModel: ColorPickerViewModelType = ColorPickerViewModel(title: "End color", currentColor: .red, didTapColorSelector: didTapColorSelector)
        
        let viewModel = GradientColorPickerViewModel(
            startColorPickerViewModel: startColorPickerViewModel,
            endColorPickerViewModel: endColorPickerViewModel)
        return GradientColorPickerViewController(viewModel: viewModel)
    }
}
