//
//  EdgesTextField.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/23/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class EdgesTextField: UITextField {

    // placeholder position
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , 8, 0)
    }
    
    // text position
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , 8 , 0)
    }
}
