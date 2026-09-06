import GoogleMobileAds
import UIKit
import google_mobile_ads

final class HorizontalNativeAdFactory: NSObject, FLTNativeAdFactory {
  static let factoryId = "dongsoopHorizontalNativeAd"

  func createNativeAd(
    _ nativeAd: GADNativeAd,
    customOptions: [AnyHashable: Any]? = nil
  ) -> GADNativeAdView? {
    let adView = HorizontalNativeAdView()
    adView.populate(with: nativeAd)
    return adView
  }
}

/// The Flutter platform view is 196pt tall: 12 + 32 + 12 + 128 + 12.
/// All asset constraints terminate inside the GADNativeAdView itself.
final class HorizontalNativeAdView: GADNativeAdView {
  private let media = GADMediaView()
  private let headline = UILabel()
  private let advertiser = UILabel()
  private let icon = UIImageView()
  private let callToAction = UIButton(type: .system)
  private let choices = GADAdChoicesView()

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 196))
    backgroundColor = .white
    layer.cornerRadius = 8
    layer.borderWidth = 1
    layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor

    let badge = UILabel()
    badge.text = "광고"
    badge.font = .systemFont(ofSize: 11)
    badge.textAlignment = .center
    badge.textColor = UIColor(white: 0.33, alpha: 1)
    badge.backgroundColor = UIColor(white: 0.95, alpha: 1)
    badge.layer.cornerRadius = 3
    badge.clipsToBounds = true

    icon.contentMode = .scaleAspectFit
    media.contentMode = .scaleAspectFit
    media.backgroundColor = UIColor(white: 0.96, alpha: 1)
    headline.font = .boldSystemFont(ofSize: 14)
    headline.textColor = UIColor(white: 0.15, alpha: 1)
    headline.numberOfLines = 3
    headline.lineBreakMode = .byTruncatingTail
    advertiser.font = .systemFont(ofSize: 11)
    advertiser.textColor = UIColor(white: 0.33, alpha: 1)
    advertiser.numberOfLines = 2
    advertiser.lineBreakMode = .byTruncatingTail
    callToAction.titleLabel?.font = .boldSystemFont(ofSize: 13)
    callToAction.titleLabel?.adjustsFontSizeToFitWidth = true
    callToAction.titleLabel?.minimumScaleFactor = 0.77
    callToAction.setTitleColor(.white, for: .normal)
    callToAction.backgroundColor = UIColor(red: 0, green: 109 / 255, blue: 1, alpha: 1)
    callToAction.layer.cornerRadius = 6
    callToAction.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    // The SDK handles clicks on registered assets.
    callToAction.isUserInteractionEnabled = false

    let assetViews: [UIView] = [icon, badge, choices, media, headline, advertiser, callToAction]
    for view in assetViews {
      view.translatesAutoresizingMaskIntoConstraints = false
      addSubview(view)
    }

    NSLayoutConstraint.activate([
      icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      icon.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      icon.widthAnchor.constraint(equalToConstant: 32),
      icon.heightAnchor.constraint(equalToConstant: 32),
      badge.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
      badge.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
      badge.widthAnchor.constraint(equalToConstant: 32),
      badge.heightAnchor.constraint(equalToConstant: 20),
      choices.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      choices.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
      choices.widthAnchor.constraint(equalToConstant: 24),
      choices.heightAnchor.constraint(equalToConstant: 24),

      // A fixed 128pt square prevents compression below the 120pt video minimum.
      media.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      media.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
      media.widthAnchor.constraint(equalToConstant: 128),
      media.heightAnchor.constraint(equalToConstant: 128),
      media.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),

      headline.leadingAnchor.constraint(equalTo: media.trailingAnchor, constant: 12),
      headline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      headline.topAnchor.constraint(equalTo: media.topAnchor),
      headline.heightAnchor.constraint(equalToConstant: 52),
      advertiser.leadingAnchor.constraint(equalTo: headline.leadingAnchor),
      advertiser.trailingAnchor.constraint(equalTo: headline.trailingAnchor),
      advertiser.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 6),
      advertiser.heightAnchor.constraint(equalToConstant: 28),
      callToAction.leadingAnchor.constraint(equalTo: headline.leadingAnchor),
      callToAction.trailingAnchor.constraint(equalTo: headline.trailingAnchor),
      callToAction.topAnchor.constraint(equalTo: advertiser.bottomAnchor, constant: 6),
      callToAction.heightAnchor.constraint(equalToConstant: 36),
      callToAction.bottomAnchor.constraint(equalTo: media.bottomAnchor),
    ])

    mediaView = media
    headlineView = headline
    advertiserView = advertiser
    iconView = icon
    callToActionView = callToAction
    adChoicesView = choices
  }

  required init?(coder: NSCoder) {
    fatalError("Use init()")
  }

  func populate(with ad: GADNativeAd) {
    headline.text = ad.headline
    advertiser.text = ad.advertiser
    advertiser.isHidden = ad.advertiser?.isEmpty ?? true
    icon.image = ad.icon?.image
    icon.isHidden = ad.icon == nil
    callToAction.setTitle(ad.callToAction, for: .normal)
    callToAction.isHidden = ad.callToAction?.isEmpty ?? true
    media.mediaContent = ad.mediaContent
    // Register the ad only after every asset has been attached and populated.
    nativeAd = ad
  }
}
