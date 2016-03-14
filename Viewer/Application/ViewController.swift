//
//  ViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/23/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator =  false
        webView.backgroundColor = UIColor.whiteColor()
        webView.hidden = true
        
        return webView
    }()
    
    private lazy var presentationTransitionManager: PresentationTransitionManager = {
        return PresentationTransitionManager()
    }()
    
    private var HTMLString: String?

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var outerButton: UIButton!
    @IBOutlet private weak var innerButton: UIButton!
    @IBOutlet private weak var backgroundView: UIView!
    
    @IBOutlet private weak var sourceItem: UIBarButtonItem!
    @IBOutlet private weak var actionItem: UIBarButtonItem!
    @IBOutlet private weak var textField: EdgesTextField!
    @IBOutlet private weak var loadingBottom: NSLayoutConstraint!
    
    private var viewingURLString: String? {
        didSet {
            self.textField.text = viewingURLString
        }
    }
    
    private var imageURLString: String? {
        didSet {
            if let URLString = imageURLString, url = NSURL(string: URLString) {
                loadingImage = true
                requestWithURL(url)
            }
        }
    }
    private var loadingImage = false
    private var shareImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        backgroundView.layer.cornerRadius = 50.0 / 2
        textField.layer.cornerRadius = 5.0
        
        view.addSubview(webView)
        view.bringSubviewToFront(backgroundView)
        view.bringSubviewToFront(innerButton)
        view.bringSubviewToFront(outerButton)
        
        AppearanceManager.configure()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSource" {
            let navigationController = segue.destinationViewController as? UINavigationController
            let vc = navigationController?.topViewController as? SourceViewController
            vc?.source = HTMLString
        } else if segue.identifier == "showSetting" {
            let navigationController = segue.destinationViewController as? UINavigationController

            navigationController?.modalPresentationStyle = .Custom
            navigationController?.transitioningDelegate = presentationTransitionManager
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Event
    
    @IBAction func action(sender: AnyObject) {
        startLoading()
        
        defer {
            if let shareImage = shareImage {
                let activityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
                presentViewController(activityViewController, animated: true, completion: nil)
            }
            
            stopLoading()
        }
        
        if shareImage == nil {
            guard let URLString = imageURLString,
                url = NSURL(string: URLString),
                imageData = NSData(contentsOfURL: url),
                image = UIImage(data: imageData)
                else {
                    stopLoading()
                    return
            }
            shareImage = image
        }
    }
    
    @IBAction func handleSwipeUp(sender: UISwipeGestureRecognizer) {
        setSettingViewHidden(false, animated: true)
    }

    @IBAction func handleSwipDown(sender: UISwipeGestureRecognizer) {
        setSettingViewHidden(true, animated: true)
    }
    
    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
        setSettingViewHidden(false, animated: true)
    }
    
    @objc private func handleApplicationDidBecomeActive(notification: NSNotification) {
        resetStatus()
        
        // Check user defaults
        let shareURLKey = "com.xspyhack.Viewer.shareURL"
        let userDefaults = NSUserDefaults(suiteName: "group.com.xspyhack.Viewer")
        let shareURL = userDefaults?.URLForKey(shareURLKey)
        
        if let shareURL = shareURL {
            userDefaults?.setURL(nil, forKey: shareURLKey)
            requestWithURL(shareURL)
        } else {
            let pasteBoard = UIPasteboard.generalPasteboard()
            if let url = pasteBoard.URL {
                requestWithURL(url)
            } else if let string = pasteBoard.string where string.hasPrefix("http://") || string.hasPrefix("https://") {
                if let url = NSURL(string: string) {
                    requestWithURL(url)
                }
            }
        }
    }
    
    // MARK: - Request
    
    private let kInstagramHost = "instagram.com"
    
    typealias Action = () -> Void
    typealias AsyncTask = (Action) -> Void

    private let switchToMainThread: AsyncTask = { (action) -> Void in
        dispatch_async(dispatch_get_main_queue(), action)
    }
    
    private func requestWithURL(url: NSURL) {
        viewingURLString = url.absoluteString
        
        switchToMainThread { [weak self] in
            self?.startLoading()
        }

        if url.host == kInstagramHost {
            loadingImage = false
            ElectromagneticOcean.fetchContentsOfURL(url) { [weak self](data, error) -> Void in
                if let data = data {
                    self?.fetchCompletionHandler(data)
                } else {
                    tv_print(error.debugDescription)
                    self?.switchToMainThread {[weak self] in
                        self?.stopLoading()
                    }
                }
            }
        } else {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    private func fetchCompletionHandler(data: NSData) {
        guard let HTMLString = String(data: data, encoding: NSUTF8StringEncoding) else { return }
        
        sourceItem.enabled = true
        
        // If now viewing instagram, get the picture only
        if let URLString = viewingURLString, url = NSURL(string: URLString) where url.host == kInstagramHost {
            switchToMainThread { [weak self] in
                self?.stopLoading()
            }
            imageURLString = Parse.captureImageURLString(HTMLString)
        } else {
            webView.loadHTMLString(HTMLString, baseURL: nil)
        }
        
        self.HTMLString = HTMLString
    }
    
    // MARK: - Private
    
    private func resetStatus() {
        loadingImage = false
        sourceItem.enabled = false
        actionItem.enabled = false
        webView.stopLoading()
    }
    
    // MARK: - Animation
    
    private let outerRotationAnimKey = "outer.rotation.z"
    private let innerRotationAnimKey = "inner.rotation.z"
    
    private func startLoading() {
        setSettingViewHidden(false, animated: true)
        
        let innerAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        innerAnim.duration = 0.5
        innerAnim.cumulative = true
        innerAnim.toValue = NSNumber(float: Float(M_PI) * -2.0)
        innerAnim.repeatCount = 66
        innerButton.layer.addAnimation(innerAnim, forKey: innerRotationAnimKey)
        
        let outerAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        outerAnim.duration = 0.5
        outerAnim.cumulative = true
        outerAnim.toValue = NSNumber(float: Float(M_PI) * 2.0)
        outerAnim.repeatCount = 66
        outerButton.layer.addAnimation(outerAnim, forKey: outerRotationAnimKey)
    }
    
    private func stopLoading() {
        setSettingViewHidden(true, animated: true)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.innerButton.layer.removeAnimationForKey(self.innerRotationAnimKey)
                self.outerButton.layer.removeAnimationForKey(self.outerRotationAnimKey)
        }
    }
    
    private func setSettingViewHidden(flag: Bool, animated: Bool) {
        if flag {
            loadingBottom.constant = -50
        } else {
            loadingBottom.constant = 25.0
        }
        
        if animated {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        resetStatus()
        
        guard var URLString = textField.text where URLString != ""
            else {
                webView.hidden = true
                return false
        }
        
        if URLString.hasPrefix("http://") || URLString.hasPrefix("https://") {
            
        } else {
            URLString = "http://" + URLString
        }

        if let url = NSURL(string: URLString ?? "http://www.blessingsoft.com") {
            requestWithURL(url)
        }
        
        return true
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoading()
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        webView.hidden = true
        stopLoading()
        messageLabel.text = NSLocalizedString("The Viewer can't open the page because the server can't be found.", comment: "")
        tv_print(error.debugDescription)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        actionItem.enabled = loadingImage
        webView.hidden = false
        
        // Get the contents of html
        webView.evaluateJavaScript("document.documentElement.outerHTML") { [weak self](results, error) -> Void in
            self?.HTMLString = results as? String
            self?.sourceItem.enabled = true
            self?.stopLoading()
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        webView.hidden = true
        stopLoading()
        tv_print(error.debugDescription)
    }
}
