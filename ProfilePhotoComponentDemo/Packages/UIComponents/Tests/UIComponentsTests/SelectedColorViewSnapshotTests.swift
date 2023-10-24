//
//  SelectedColorView.swift
//  
//
//  Created by Marcin Borek on 24/10/2023.
//

@testable import UIComponents
import SnapshotTesting
import XCTest

final class SelectedColorViewSnapshotTests: XCTestCase {
    private let isRecording = false
    
    func test_forWhiteCurrentColor_shouldHaveBlackTintAndBorder() {
        let view = SelectedColorView(
            frame: CGRect(x: 0, y: 0, width: 44, height: 44),
            currentColor: .white
        )
        verifyView(
            view,
            viewName: "SelectedColorView",
            stateName: "forWhiteCurrentColor_shouldHaveBlackTintAndBorder",
            isRecording: isRecording)
    }
    
    func test_forBlackCurrentColor_shouldHaveWhiteTintAndBorder() {
        let view = SelectedColorView(
            frame: CGRect(x: 0, y: 0, width: 44, height: 44),
            currentColor: .black
        )
        verifyView(
            view,
            viewName: "SelectedColorView",
            stateName: "forBlackCurrentColor_shouldHaveWhiteTintAndBorder",
            isRecording: isRecording)
    }
    
    func test_forGreenCurrentColor_shouldHaveWhiteTintAndBorder() {
        let view = SelectedColorView(
            frame: CGRect(x: 0, y: 0, width: 44, height: 44),
            currentColor: .green
        )
        verifyView(
            view,
            viewName: "SelectedColorView",
            stateName: "forGreenCurrentColor_shouldHaveWhiteTintAndBorder",
            isRecording: isRecording)
    }
}

