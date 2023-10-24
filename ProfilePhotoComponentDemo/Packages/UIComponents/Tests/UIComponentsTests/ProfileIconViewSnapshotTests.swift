import UIComponents
import XCTest

final class ProfileIconViewSnapshotTests: XCTestCase {
    private let isRecording = false

    func test_renderSolidBackgroundInRoundedSquare() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = ProfileIconView(frame: frame, profileIcon: makeSolidProfileIcon())

        verifyView(
            view,
            viewName: "ProfileIconView",
            stateName: "solidRoundedSquare",
            isRecording: isRecording)
    }

    func test_renderGradientBackgroundInRoundedSquare() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = ProfileIconView(frame: frame, profileIcon: makeGradientProfileIcon())

        verifyView(
            view,
            viewName: "ProfileIconView",
            stateName: "gradientRoundedSquare",
            isRecording: isRecording)
    }

    func test_renderImageBackgroundInRoundedSquare() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = ProfileIconView(frame: frame, profileIcon: makeImageProfileIcon())

        verifyView(
            view,
            viewName: "ProfileIconView",
            stateName: "imageRoundedSquare",
            isRecording: isRecording)
    }
    
    func test_renderSolidBackgroundInCircle() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = ProfileIconView(frame: frame, profileIcon: makeSolidProfileIcon(isCircle: true))
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            view,
            viewName: "ProfileIconView",
            stateName: "solidCircle",
            isRecording: isRecording)
    }

    func test_renderGradientBackgroundInCircle() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = ProfileIconView(frame: frame, profileIcon: makeGradientProfileIcon(isCircle: true))
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            view,
            viewName: "ProfileIconView",
            stateName: "gradientCircle",
            isRecording: isRecording)
    }

    func test_renderImageBackgroundInCircle() {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = ProfileIconView(frame: frame, profileIcon: makeImageProfileIcon(isCircle: true))

        verifyView(
            view,
            viewName: "ProfileIconView",
            stateName: "imageCircle",
            isRecording: isRecording)
    }

    private func makeSolidProfileIcon(isCircle: Bool = false) -> ProfileIcon {
        let shape: ProfileIcon.Shape = isCircle ? .circle : .roundedSquare
        let attributes = ProfileIcon.SolidAttributes(initials: "MB", backgroundColor: .red, shape: shape)
        return .solid(attributes)
    }

    private func makeGradientProfileIcon(isCircle: Bool = false) -> ProfileIcon {
        let shape: ProfileIcon.Shape = isCircle ? .circle : .roundedSquare
        let attributes = ProfileIcon.GradientAttributes(initials: "MB", startColor: .red, endColor: .green, shape: shape)
        return .gradient(attributes)
    }

    private func makeImageProfileIcon(isCircle: Bool = false) -> ProfileIcon {
        let shape: ProfileIcon.Shape = isCircle ? .circle : .roundedSquare
        let image = UIImage(named: "forest", in: .module, compatibleWith: nil)!
        let attributes = ProfileIcon.ImageAttributes(image: image, shape: shape)
        return .image(attributes)
    }
}
