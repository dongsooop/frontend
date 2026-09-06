package com.dongsoop.site.dongsoop

import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.AdChoicesView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class HorizontalNativeAdFactory(private val inflater: LayoutInflater) : NativeAdFactory {
    companion object {
        const val FACTORY_ID = "dongsoopHorizontalNativeAd"
    }

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = inflater.inflate(R.layout.horizontal_native_ad, null) as NativeAdView
        val media = adView.findViewById<MediaView>(R.id.horizontal_ad_media)
        val headline = adView.findViewById<TextView>(R.id.horizontal_ad_headline)
        val advertiser = adView.findViewById<TextView>(R.id.horizontal_ad_advertiser)
        val icon = adView.findViewById<ImageView>(R.id.horizontal_ad_icon)
        val callToAction = adView.findViewById<TextView>(R.id.horizontal_ad_call_to_action)

        headline.text = nativeAd.headline
        advertiser.text = nativeAd.advertiser
        advertiser.visibility = if (nativeAd.advertiser.isNullOrEmpty()) View.INVISIBLE else View.VISIBLE
        callToAction.text = nativeAd.callToAction
        callToAction.visibility = if (nativeAd.callToAction.isNullOrEmpty()) View.INVISIBLE else View.VISIBLE
        icon.setImageDrawable(nativeAd.icon?.drawable)
        icon.visibility = if (nativeAd.icon == null) View.GONE else View.VISIBLE
        media.setImageScaleType(ImageView.ScaleType.FIT_CENTER)
        nativeAd.mediaContent?.let { media.mediaContent = it }

        // Every registered asset is a descendant of this same NativeAdView.
        adView.mediaView = media
        adView.headlineView = headline
        adView.advertiserView = advertiser
        adView.iconView = icon
        adView.callToActionView = callToAction
        adView.adChoicesView = adView.findViewById<AdChoicesView>(R.id.horizontal_ad_choices)
        adView.setNativeAd(nativeAd)
        return adView
    }
}
