//
//  AdManager.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 12/11/21.
//

import Foundation
import GoogleMobileAds
import UIKit

class AdManager: NSObject {
    var bannerView: GADBannerView!
    let testAdUnitID = "ca-app-pub-3940256099942544/2934735716"

    override init() {
        super.init()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = testAdUnitID
        bannerView.load(GADRequest())
    }

    /// Adds a banner to selected view and returns a reference to it
    func addBannerViewToTopOfView(_ controller: UIViewController) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = controller
        
        controller.view.addSubview(bannerView)
        controller.view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: controller.view,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: controller.view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}

extension AdManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
