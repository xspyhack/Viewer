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
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator =  false
        webView.backgroundColor = UIColor.whiteColor()
        
        return webView
    }()
    
    private var HTMLString: String?

    @IBOutlet private weak var outerButton: UIButton!
    @IBOutlet private weak var innerButton: UIButton!
    @IBOutlet private weak var backgroundView: UIView!
    
    @IBOutlet private weak var sourceItem: UIBarButtonItem!
    @IBOutlet private weak var actionItem: UIBarButtonItem!
    @IBOutlet private weak var textField: EdgesTextField!
    @IBOutlet private weak var loadingBottom: NSLayoutConstraint!
    
    private var viewURLString: String? {
        
        didSet {
            self.textField.text = viewURLString
        }
    }
    
    private var imageURLString: String?
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
            vc?.HTMLString = HTMLString
        } else if segue.identifier == "showSetting" {
        }
    }
    
    // MARK: - Event
    
    @IBAction func action(sender: AnyObject) {
        startLoading()
        
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
        
        stopLoading()
        let activityViewController = UIActivityViewController(activityItems: [shareImage!], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func handleApplicationDidBecomeActive(notification: NSNotification) {
        reset()
        
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
            } else if let string = pasteBoard.string {
                let pattern = "^(http|https)://"
                let matcher: RegexHelper
                do {
                    matcher = try RegexHelper(pattern)
                } catch {
                    tv_print(error)
                    return
                }
                
                if matcher.isMatch(string) {
                    if let url = NSURL(string: string) {
                        requestWithURL(url)
                    }
                }
            }
        }
    }
    
    // MARK: - Request
    
    private let kInstagramHost = "instagram.com"
    
    private func requestWithURL(url: NSURL) {
        viewURLString = url.absoluteString
        
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            self?.startLoading()
        }
        
        if url.host == kInstagramHost {
            requestContentsOfURL(url)
        } else {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    private func requestContentsOfURL(url: NSURL) {
        loadingImage = false
        
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadRevalidatingCacheData, timeoutInterval: 30.0)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { [weak self](data, response, error) -> Void in
            if let data = data {
                self?.HTMLString = String(data: data, encoding: NSUTF8StringEncoding)
                self?.sourceItem.enabled = true
                self?.completionHandler()
            } else {
                tv_print(error.debugDescription)

                dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
                    self?.stopLoading()
                }
            }
        }
        dataTask.resume()
    }
    
    private func completionHandler() {
        guard let HTMLString = HTMLString else { return }
        
        if let URLString = viewURLString, url = NSURL(string: URLString) where url.host == "instagram.com" {
            let imageURLString = parse()

            dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
                self?.stopLoading()
            }
            
            if let imageURLString = imageURLString, url = NSURL(string: imageURLString) {
                loadingImage = true
                requestWithURL(url)
            }
        } else {
            webView.loadHTMLString(HTMLString, baseURL: nil)
        }
    }
    
    // MARK: - Private
    
    private func parse() -> String? {
        guard let HTMLString = HTMLString else { return nil }
        
        let pattern = "(?<=\"og:image\" content=\")(https://.+.(jpg|png))"
        let matcher: RegexHelper
        do {
            matcher = try RegexHelper(pattern)
        } catch {
            tv_print(error)
            return nil
        }
        
        imageURLString = matcher.firstCapture(HTMLString)
        return imageURLString
    }
    
    private func reset() {
        loadingImage = false
        sourceItem.enabled = false
        actionItem.enabled = false
        webView.stopLoading()
    }
    
    // MARK: - Animation
    
    private let outerRotationAnimKey = "outer.rotation.z"
    private let innerRotationAnimKey = "inner.rotation.z"
    
    private func startLoading() {
        loadingBottom.constant = 25.0
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        let innerAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        innerAnim.duration = 0.5
        innerAnim.cumulative = true
        innerAnim.toValue = NSNumber(float: Float(M_PI) * -2.0)
        innerAnim.repeatCount = 60
        innerButton.layer.addAnimation(innerAnim, forKey: innerRotationAnimKey)
        
        let outerAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        outerAnim.duration = 0.5
        outerAnim.cumulative = true
        outerAnim.toValue = NSNumber(float: Float(M_PI) * 2.0)
        outerAnim.repeatCount = 60
        outerButton.layer.addAnimation(outerAnim, forKey: outerRotationAnimKey)
    }
    
    private func stopLoading() {
        loadingBottom.constant = -50.0
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.innerButton.layer.removeAnimationForKey(self.innerRotationAnimKey)
                self.outerButton.layer.removeAnimationForKey(self.outerRotationAnimKey)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reset()
        
        guard var URLString = textField.text where URLString != "" else { return false }
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
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        actionItem.enabled = loadingImage
        // Get the contents of html, <html>contents</html>
        webView.evaluateJavaScript("document.all[0].innerHTML") { [weak self](results, error) -> Void in
            self?.HTMLString = results as? String
            self?.sourceItem.enabled = true
            self?.stopLoading()
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
    }
}
