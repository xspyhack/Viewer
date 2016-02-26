//
//  RegexHelper.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/23/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

struct RegexHelper {
    let regex: NSRegularExpression
    
    init (_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }

    private func matches(input: String) -> [NSTextCheckingResult] {
        return regex.matchesInString(input, options: [], range: NSMakeRange(0, input.characters.count))
    }
    
    func isMatch(input: String) -> Bool {
        return matches(input).count > 0
    }
    
    func firstMatch(input: String) -> String? {
        let match = regex.firstMatchInString(input, options: [], range: NSMakeRange(0, input.characters.count))
        if let match = match {
            return (input as NSString).substringWithRange(match.range)
        } else {
            return nil
        }
    }
    
    func capture(input: String) -> [String]? {
        let matches = self.matches(input)
        var resutls: [String]?
    
        for match in matches {
            resutls?.append((input as NSString).substringWithRange(match.range))
        }
        return resutls
    }
    
    func enumerateMatches(input: String, usingBlock block: (NSTextCheckingResult?) -> Void) {
        regex.enumerateMatchesInString(input, options: [], range: NSMakeRange(0, input.characters.count)) { (result, flags, stop) -> Void in
            block(result)
        }
    }
    
    func firstCapture(input: String) -> String? {
        let matches = self.matches(input)
        if matches.count > 0 {
            return (input as NSString).substringWithRange(matches[0].range)
        } else {
            return nil
        }
    }
}