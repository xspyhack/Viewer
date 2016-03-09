//
//  SettingViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/24/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: Choose syntax-highlight style
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sponsorship(sender: AnyObject) {
        if let url = NSURL(string: "alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/aex01834ritbtrlux7ogcbf") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            tv_print("error")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
