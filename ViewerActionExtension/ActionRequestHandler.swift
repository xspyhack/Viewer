//
//  ActionRequestHandler.swift
//  ViewerActionExtension
//
//  Created by bl4ckra1sond3tre on 2/25/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        
        // Flatten if let..else pyramids
        // Here just get the first item, you can iterate all items
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
            itemProvider = item.attachments?.first as? NSItemProvider where itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList))
            else {
                return
        }
        itemProvider.loadItemForTypeIdentifier(String(kUTTypePropertyList), options: nil) { [unowned self](item, error) -> Void in
            let dictionary = item as! [String: AnyObject]
            self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [NSObject: AnyObject])
        }

        /*
        // This Apple simple example doesn't fucking work, 💩
        
        var found = false
        
        // Find the item containing the results from the JavaScript preprocessing.
        outer:
            for item: AnyObject in context.inputItems {
                let extItem = item as! NSExtensionItem
                if let attachments = extItem.attachments {
                    for itemProvider: AnyObject in attachments {
                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                            itemProvider.loadItemForTypeIdentifier(String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) in
                                let dictionary = item as! [String: AnyObject]
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [NSObject: AnyObject])
                                }
                                found = true
                            })
                            if found {
                                break outer
                            }
                        }
                    }
                }
        }
        
        if !found {
            self.doneWithResults(nil)
        }
        */
    }
    
    func itemLoadCompletedWithPreprocessingResults(javaScriptPreprocessingResults: [NSObject: AnyObject]) {
        // Here, do something, potentially asynchronously, with the preprocessing
        // results.
        
        let HTMLString = javaScriptPreprocessingResults["html"]
        if let _ = HTMLString as? String {
            // Here we can use map { $0 == "<" ? "&lt" : $0 }
            
            /*
            HTMLString = HTMLString.stringByReplacingOccurrencesOfString("<", withString: "&lt")
            HTMLString = HTMLString.stringByReplacingOccurrencesOfString(">", withString: "&gt")
            parse(&HTMLString)
            */
            
            // Load js & css
            let jsPath = NSBundle.mainBundle().pathForResource("rainbow.min", ofType: "js")
            let script = try! String(contentsOfFile: jsPath!, encoding: NSUTF8StringEncoding)
            let cssPath = NSBundle.mainBundle().pathForResource("github.min", ofType: "css")
            let style = try! String(contentsOfFile: cssPath!, encoding: NSUTF8StringEncoding)
        
            self.doneWithResults(["script": script, "style": style])
        
        } else {
            self.doneWithResults(["message": "Can't get the HTML source."])
        }
    }
    
    private func parse(inout string: String) {
        highlighted(&string)
    }
    
    private func highlighted(inout string: String) {
        highlightHref(&string)
        highlightSrc(&string)
    }
    
    private func highlightHref(inout string: String) {
        let pattern = "(?<=href=[\'\"]?)([^\'\"]+).*?(?=[\'\"])"
        let matcher: RegexHelper
        do {
            matcher = try RegexHelper(pattern)
        } catch {
            return
        }
        
        var hrefs = [String]()
        matcher.enumerateMatches(string) { (result) -> Void in
            if let result = result {
                let href = (string as NSString).substringWithRange(result.range)
                hrefs.append(href)
            }
        }
        
        for href in hrefs {
            let newHref = "<a href=\"" + href + "\" target=\"_blank\">" + href + "</a>"
            string = (string as NSString).stringByReplacingOccurrencesOfString(href, withString: newHref)
        }
    }
    
    private func highlightSrc(inout string: String) {
        let pattern = "(?<=src=[\'\"]?)([^\'\"]+).*?(?=[\'\"])"
        let matcher: RegexHelper
        do {
            matcher = try RegexHelper(pattern)
        } catch {
            return
        }
        
        var srcs = [String]()
        matcher.enumerateMatches(string) { (result) -> Void in
            if let result = result {
                let src = (string as NSString).substringWithRange(result.range)
                srcs.append(src)
            }
        }
        
        for src in srcs {
            let newSrc = "<a href=\"" + src + "\" target=\"_blank\">" + src + "</a>"
            string = (string as NSString).stringByReplacingOccurrencesOfString(src, withString: newSrc)
        }
    }
    
    func doneWithResults(resultsForJavaScriptFinalizeArg: [NSObject: AnyObject]?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            // Construct an NSExtensionItem of the appropriate type to return our
            // results dictionary in.
            
            // These will be used as the arguments to the JavaScript finalize()
            // method.
            
            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            
            let resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: String(kUTTypePropertyList))
            
            let resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            // Signal that we're complete, returning our results.
            self.extensionContext?.completeRequestReturningItems([resultsItem], completionHandler: nil)
        } else {
            // We still need to signal that we're done even if we have nothing to
            // pass back.
            self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
        }
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }

}
