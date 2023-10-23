import UIComponents
import XCTest

final class ProfileIconViewSnapshotTests: XCTestCase {
    private let isRecording = false

    func test_renderSolidBackgroundInRoundedSquare() {
        let widgetView = ProfileIconView(profileIcon: makeSolidProfileIcon())
        widgetView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            widgetView,
            viewName: "ProfileIconView",
            stateName: "solidRoundedSquare",
            isRecording: isRecording)
    }

    func test_renderGradientBackgroundInRoundedSquare() {
        let widgetView = ProfileIconView(profileIcon: makeGradientProfileIcon())
        widgetView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            widgetView,
            viewName: "ProfileIconView",
            stateName: "gradientRoundedSquare",
            isRecording: isRecording)
    }

    func test_renderImageBackgroundInRoundedSquare() {
        let widgetView = ProfileIconView(profileIcon: makeImageProfileIcon())
        widgetView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            widgetView,
            viewName: "ProfileIconView",
            stateName: "imageRoundedSquare",
            isRecording: isRecording)
    }
    
    func test_renderSolidBackgroundInCircle() {
        let widgetView = ProfileIconView(profileIcon: makeSolidProfileIcon(isCircle: true))
        widgetView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            widgetView,
            viewName: "ProfileIconView",
            stateName: "solidCircle",
            isRecording: isRecording)
    }

    func test_renderGradientBackgroundInCircle() {
        let widgetView = ProfileIconView(profileIcon: makeGradientProfileIcon(isCircle: true))
        widgetView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            widgetView,
            viewName: "ProfileIconView",
            stateName: "gradientCircle",
            isRecording: isRecording)
    }

    func test_renderImageBackgroundInCircle() {
        let widgetView = ProfileIconView(profileIcon: makeImageProfileIcon(isCircle: true))
        widgetView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        verifyView(
            widgetView,
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
