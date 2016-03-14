//
//  HelpViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/12/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messageLabel.text = NSLocalizedString("If you can't get syntax-highlighted source code of some web page in Safari, you can view in App.\n:D", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mailToMe(sender: AnyObject) {
        let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknow"
        let appBuild = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? "unknow"
        let systemName = UIDevice.currentDevice().systemName
        let systemVersion = UIDevice.currentDevice().systemVersion
        
        sendMailToRecipients(["xspyhack@gmail.com"], ccRecipients:[""], withSubject: NSLocalizedString("The Viewer Feeds", comment: "") + " - v\(appVersion) (\(appBuild)) (\(systemName) \(systemVersion))")
    }
    
    private func sendMailToRecipients(recipients: [String], ccRecipients: [String], withSubject subject: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setToRecipients(recipients)
            mailComposeViewController.setCcRecipients(ccRecipients)
            mailComposeViewController.setSubject(subject)
            mailComposeViewController.mailComposeDelegate = self
            
            presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            tv_print("This device can't send mail.")
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

// MARK: - MFMailComposeViewControllerDelegate

extension HelpViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultSent:
            tv_print("sent")
        case MFMailComposeResultFailed:
            tv_print("fail: " + error.debugDescription)
        case MFMailComposeResultCancelled:
            tv_print("canceled")
        default:
            break
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

