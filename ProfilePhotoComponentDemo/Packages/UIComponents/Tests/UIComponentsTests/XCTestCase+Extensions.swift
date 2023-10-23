//
//  XCTestCase+Extensions.swift
//  
//
//  Created by Marcin Borek on 23/10/2023.
//

import SnapshotTesting
import XCTest

extension XCTestCase {
    func verifyView(
        _ view: UIView,
        viewName: String,
        stateName: String = "Default",
        isRecording: Bool = false) {
        let viewController = UIViewController()
        viewController.view.addSubview(view)
        let results = Self.devices.map { device in
            verifySnapshot(
                matching: viewController,
                as: .image(on: device.value),
                named: "\(stateName)-\(device.key)",
                record: isRecording,
                testName: viewName)
        }
        results.forEach { XCTAssertNil($0) }
    }
    
    /// Devices which are used in Snapshot tests
    private static let devices: [String: ViewImageConfig] = [
        "iPhoneX": .iPhoneX,
        "iPhoneSe": .iPhoneSe
    ]
}
