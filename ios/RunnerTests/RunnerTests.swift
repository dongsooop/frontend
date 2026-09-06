import Flutter
import UIKit
import XCTest
@testable import Runner

class RunnerTests: XCTestCase {

  func testExample() {
    // If you add code to the Runner application, consider adding tests here.
    // See https://developer.apple.com/documentation/xctest for more information about using XCTest.
  }

}

@MainActor
final class HorizontalNativeAdLayoutTests: XCTestCase {
  func testVideoAndAdvertiserStayInsideTheAdAtSupportedWidths() throws {
    for width in [CGFloat(320), 343, 398, 600] {
      let adView = HorizontalNativeAdView()
      adView.frame = CGRect(x: 0, y: 0, width: width, height: 196)
      adView.setNeedsLayout()
      adView.layoutIfNeeded()

      let media = try XCTUnwrap(adView.mediaView)
      XCTAssertGreaterThanOrEqual(media.bounds.width, 120)
      XCTAssertGreaterThanOrEqual(media.bounds.height, 120)

      let assets: [UIView?] = [adView.mediaView, adView.headlineView, adView.advertiserView,
                              adView.iconView, adView.callToActionView, adView.adChoicesView]
      for asset in assets {
        let asset = try XCTUnwrap(asset)
        XCTAssertTrue(asset.isDescendant(of: adView))
        let frame = asset.convert(asset.bounds, to: adView)
        XCTAssertGreaterThan(frame.width, 0)
        XCTAssertGreaterThan(frame.height, 0)
        XCTAssertTrue(adView.bounds.insetBy(dx: -0.5, dy: -0.5).contains(frame),
                      "Asset outside ad at width \(width): \(frame)")
        XCTAssertFalse(asset.hasAmbiguousLayout)
      }
    }
  }
}
