//
//  Deeplinker.swift
//  ExponeaSDK
//
//  Created by Panaxeo on 10/01/2020.
//  Copyright © 2020 Exponea. All rights reserved.
//

import Foundation
import UIKit

final class UrlOpener: UrlOpenerType {
    func openBrowserLink(_ urlString: String) {
        guard let url = urlString.cleanedURL() else {
            Exponea.logger.log(.warning, message: "Provided url \"\(urlString)\" is invalid")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func openDeeplink(_ urlString: String) {
        guard let url = urlString.cleanedURL() else {
            Exponea.logger.log(.warning, message: "Provided url \"\(urlString)\" is invalid")
            return
        }
        let value = openUniversalLink(url, application: UIApplication.shared);
        Exponea.logger.log(.verbose, message: "\(Unmanaged.passUnretained(self).toOpaque()): Open Universal Link Response: \(String(describing: value))")
        // NOTE: disabling this as we don't want the app to be affected
        //        if value == false {
//            openURLSchemeDeeplink(url, application: UIApplication.shared)
//        }
    }

    private func openUniversalLink(_ url: URL, application: UIApplication) -> Bool {
        // Validate this is a valid URL, prevents NSUserActivity crash with invalid URL
        // only http/https is allowed
        // https://developer.apple.com/documentation/foundation/nsuseractivity/1418086-webpageurl
        // eg. MYDEEPLINK::HOME:SCREEN:1, exponea://deeplink
        guard url.absoluteString.isValidURL, url.scheme == "http" || url.scheme == "https" else {
            return false
        }
        // Simulate universal link user activity
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = url
        
        if (application.delegate == nil) {
            Exponea.logger.log(.error, message: "Appdelegate was nil, please double check app setup")
            return false
        }

        // Try and open the link as universal link
        let applicationResult = application.delegate?.application?(
            UIApplication.shared,
            continue: userActivity,
            restorationHandler: { _ in }
        )
        Exponea.logger.log(.verbose, message: "Universal Link Response: \(String(describing: applicationResult))")
        return applicationResult!
    }

    private func openURLSchemeDeeplink(_ url: URL, application: UIApplication) {
        // Open the deeplink, iOS will handle if deeplink to safari/other apps
        application.open(url, options: [:], completionHandler: { success in
            if !success { // If opening url using shared app failed, try opening using current app
                _ = application.delegate?.application?(UIApplication.shared, open: url, options: [:])
            }
        })
    }
}
