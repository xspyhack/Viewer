//
//  SourceViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/23/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import WebKit

class SourceViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = UIColor.whiteColor()
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }()
    
    var HTMLString: String?
    
    var source: String?
    
    // `searchController` is set when the search button is clicked.
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        view.addSubview(webView)
        
        processHTMLString()

        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
        webView.loadHTMLString(HTMLString!, baseURL: url)
        
        setupSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func processHTMLString() {
        guard var source = source else { return }
        
        let document = "<!DOCTYPE html><html lang=\"en\" contenteditable=\"true\">"
        
        var head = "<head><meta charset=\"utf-8\"><title>The Viewer - View Source</title>"
        
        Parse.HTMLEncode(&source)
        Parse.highlighted(&source)
        
        var themeHelper = ThemeHelper.shareHelper
        themeHelper.script = .Highlight(style: .Github)
        if case .Default = themeHelper.script {
            head += "<script src=\"highlight.min.js\"></script>"
            head += "<script>hljs.initHighlightingOnLoad();</script>"
            head += "<link href=\"github.min.css\" rel=\"stylesheet\">"
        } else {
            head += "<link href=\"" + themeHelper.script.stylePath + themeHelper.script.style.rawValue + "\" rel=\"stylesheet\">"
            head += "<script src=\"" + themeHelper.script.scriptPath + "\"></script>"
            head += themeHelper.script.runScript
        }

        head += "</head>"
        
        let body = "<body style=\"width:100%;word-wrap:break-word;\"><pre><code class=\"html\" data-language=\"html\" style=\"font-size: 23px;\">"
        let foot = "</code></pre></body></html>"
        
        HTMLString = document + head + body + source + foot
    }

    private func setupSearchController() {
        let resultsViewController = storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        resultsViewController.allResults = HTMLString
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Configure the search controller's search bar. For more information on how to configure
        // search bars, see the "Search Bar" group under "Search".
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        
        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    deinit {
        searchController.view.removeFromSuperview()
    }
}

extension SourceViewController: WKNavigationDelegate {
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
    }
}
