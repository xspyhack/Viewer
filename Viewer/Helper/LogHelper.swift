//
//  LogHelper.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/2/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

// tv = The Viewer
func tv_print<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

func tv_debugPrint<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}