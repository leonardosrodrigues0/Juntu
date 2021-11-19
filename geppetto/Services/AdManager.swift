import Foundation
import GoogleMobileAds
import UIKit

class AdManager: NSObject {
    
    // MARK: - Static Properties
    
    static private let verticalMargins: CGFloat = 10
    static private let testAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let height: CGFloat = 50 + 2 * verticalMargins

    // MARK: - Properties
    
    private var bannerView: GADBannerView!
    
    // MARK: - Initializers

    override init() {
        super.init()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = Self.testAdUnitID
        bannerView.load(GADRequest())
    }
    
    // MARK: - Methods

    /// Adds a banner to selected view, or main view
    func addBannerViewToTopOfView(to view: UIView? = nil, _ controller: UIViewController) {
        let usedView = (view != nil ? view : controller.view)!

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = controller
        
        usedView.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: usedView.centerXAnchor),
            bannerView.topAnchor.constraint(equalTo: usedView.topAnchor, constant: +AdManager.verticalMargins/2)
        ])
    }
    
    /// Adds a banner to selected view, or main view
    func addBannerViewToBottomOfView(to view: UIView? = nil, _ controller: UIViewController) {
        let usedView = (view != nil ? view : controller.view)!

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = controller
        
        usedView.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: usedView.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: usedView.bottomAnchor, constant: -AdManager.verticalMargins/2)
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
        print("bannerViewWillDismissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
