//
//  Parse.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/8/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

struct Parse {
    
    static func HTMLEncode(inout string: String) {
        string = string.stringByReplacingOccurrencesOfString("<", withString: "&lt;")
        string = string.stringByReplacingOccurrencesOfString(">", withString: "&gt;")
    }
    
    static func HTMLDecode(inout string: String) {
        string = string.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
        string = string.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
    }
    
    static func parse(inout string: String) {
        highlighted(&string)
    }
    
    static func highlighted(inout string: String) {
        highlightHref(&string)
        highlightSrc(&string)
    }
    
    static func highlightHref(inout string: String) {
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
    
    static func highlightSrc(inout string: String) {
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
}