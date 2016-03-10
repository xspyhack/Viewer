//
//  Uitls.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/10/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import Foundation

func iterateEnum<T: Hashable>(_: T.Type) -> AnyGenerator<T> {
    var i = 0
    return anyGenerator {
        let next = withUnsafePointer(&i) { UnsafePointer<T>($0).memory }
        return next.hashValue == i++ ? next : nil
    }
}