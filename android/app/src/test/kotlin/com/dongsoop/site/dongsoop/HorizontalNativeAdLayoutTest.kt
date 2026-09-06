package com.dongsoop.site.dongsoop

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Rect
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAdView
import java.io.File
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28], qualifiers = "mdpi")
@GraphicsMode(GraphicsMode.Mode.NATIVE)
class HorizontalNativeAdLayoutTest {
    @Test
    fun videoAndAdvertiserStayInsideTheAdAtSupportedWidths() {
        for (width in listOf(320, 343, 398, 600)) {
            val adView = LayoutInflater.from(RuntimeEnvironment.getApplication())
                .inflate(R.layout.horizontal_native_ad, null) as NativeAdView
            adView.findViewById<TextView>(R.id.horizontal_ad_headline).text =
                "학교 앞 새로운 카페를 만나보세요"
            adView.findViewById<TextView>(R.id.horizontal_ad_advertiser).text =
                "동숲 파트너 · 캠퍼스 라이프"
            adView.findViewById<TextView>(R.id.horizontal_ad_call_to_action).text = "자세히 보기"
            adView.measure(
                View.MeasureSpec.makeMeasureSpec(width, View.MeasureSpec.EXACTLY),
                View.MeasureSpec.makeMeasureSpec(196, View.MeasureSpec.EXACTLY)
            )
            adView.layout(0, 0, width, 196)

            val media = adView.findViewById<View>(R.id.horizontal_ad_media)
            val density = adView.resources.displayMetrics.density
            assertTrue("Video width at $width", media.width / density >= 120)
            assertTrue("Video height at $width", media.height / density >= 120)

            val rootBounds = Rect(0, 0, adView.width, adView.height)
            for (id in listOf(
                R.id.horizontal_ad_media,
                R.id.horizontal_ad_headline,
                R.id.horizontal_ad_advertiser,
                R.id.horizontal_ad_icon,
                R.id.horizontal_ad_call_to_action,
                R.id.horizontal_ad_choices
            )) {
                val asset = adView.findViewById<View>(id)
                val bounds = Rect(0, 0, asset.width, asset.height)
                adView.offsetDescendantRectToMyCoords(asset, bounds)
                assertTrue("Asset $id outside ad at width $width: $bounds", rootBounds.contains(bounds))
            }

            // A layout fixture, not a live ad or proof of AdMob Validator approval.
            val bitmap = Bitmap.createBitmap(width, 196, Bitmap.Config.ARGB_8888)
            adView.draw(Canvas(bitmap))
            val output = File("build/reports/native-ad-layout/android-$width.png")
            output.parentFile.mkdirs()
            output.outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
            bitmap.recycle()
            adView.destroy()
        }
    }
}
