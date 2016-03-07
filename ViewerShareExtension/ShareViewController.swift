//
//  ShareViewController.swift
//  ViewerShareExtension
//
//  Created by bl4ckra1sond3tre on 2/25/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import MobileCoreServices

// We don't need the Compose View and tap post to share,
// so here inherit UIViewController.
class ShareViewController: UIViewController {// SLComposeServiceViewController {

    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var backgroundMaskView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup custom view.
        setup()
        
        // Get URL from context
        fetchURL()
    }
    
    private func setup() {
        alertView.layer.cornerRadius = 10.0
    }
    
    private func fetchURL() {
        // Flatten if let..else pyramids
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
            itemProvider = item.attachments?.first as? NSItemProvider where itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String)
            else {
                return
        }
        itemProvider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil) { [weak self](item, error) -> Void in
            self?.shareURL(item as? NSURL)
            self?.showAlertView()
        }
    }
    
    private func shareURL(url: NSURL?) {
        guard let url = url else { return }
        let userDefaults = NSUserDefaults(suiteName: "group.com.xspyhack.Viewer")
        userDefaults?.setURL(url, forKey: "com.xspyhack.Viewer.shareURL")
        userDefaults?.synchronize()
    }
    
    private func showAlertView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.backgroundMaskView.alpha = 0.5
            self.alertView.alpha = 1.0
            }) { (_) -> Void in
                self.hideAlertViewAfter(2.3)
        }
    }
    
    private func hideAlertViewAfter(delay: NSTimeInterval) {
        performSelector("hide", withObject: nil, afterDelay: delay)
    }
    
    @objc private func hideAlertView() {
        self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
    }
    
    // TODO: Share extension can't openURL, so this code will not work
    @IBAction func openTapped(sender: AnyObject) {
        let URLScheme = "Viewer://share"
        if let url = NSURL(string: URLScheme) {
            self.extensionContext?.openURL(url, completionHandler: { [weak self](finished) -> Void in
                self?.hideAlertView()
            })
        }
    }
}
