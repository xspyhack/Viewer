//
//  ElectromagneticOcean.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/12/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

struct ElectromagneticOcean {
    typealias ComplectionHandler = (NSData?, NSError?) -> Void
    
    static func fetchContentsOfURL(url: NSURL, complectionHandler: ComplectionHandler) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadRevalidatingCacheData, timeoutInterval: 30.0)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            defer {
                complectionHandler(data, error)
            }
        }
        dataTask.resume()
    }
}