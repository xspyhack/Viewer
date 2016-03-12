//
//  SettingViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/24/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowTheme = "showTheme"
        case ShowHelp = "showHelp"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: Choose syntax-highlight style
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func sponsorship() {
        if let url = NSURL(string: "alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/aex01834ritbtrlux7ogcbf") {
            UIApplication.sharedApplication().openURL(url)
        } else {
            tv_print("error")
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCellIdentifier", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Theme"
        case 1:
            cell.textLabel?.text = "Help"
        case 2:
            cell.textLabel?.text = "Sponsorship Developer"
        default:
            break
        }
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 23
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        switch indexPath.row {
        case 0:
            // Segue between two view controllers, not cell <-> view controller
            performSegueWithIdentifier(SegueIdentifier.ShowTheme, sender: indexPath)
        case 1:
            performSegueWithIdentifier(SegueIdentifier.ShowHelp, sender: indexPath)
        case 2:
            sponsorship()
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 99
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerLabel = UILabel()
        footerLabel.numberOfLines = 0
        footerLabel.text = "> Technology is innocent.\n\nv1.0.2"
        footerLabel.font = UIFont.systemFontOfSize(12)
        footerLabel.textAlignment = .Center
        footerLabel.textColor = UIColor(red: 23 / 255.0, green: 87 / 255.0, blue: 134 / 255.0, alpha: 1.0)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 99))
        
        footerView.addSubview(footerLabel)
        
        // Auto Layout
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: footerLabel, attribute: .CenterX, relatedBy: .Equal, toItem: footerView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        let centerY = NSLayoutConstraint(item: footerLabel, attribute: .CenterY, relatedBy: .Equal, toItem: footerView, attribute: .CenterY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([centerX, centerY])

        return footerView
    }
}
