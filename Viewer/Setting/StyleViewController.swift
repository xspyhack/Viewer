//
//  StyleViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/10/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import SafariServices

class StyleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var selectedIndexPath: NSIndexPath?
    
    var script: ThemeHelper.Script = .Default(.Github)
    
    private lazy var stylesArray: [ThemeHelper.Script.Style] = {
        return ThemeHelper.Script.Style.allValues
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let selectedIndexPath = selectedIndexPath {
            // Save selected style
            var themeHelper = ThemeHelper()
            let style = stylesArray[selectedIndexPath.row]
            themeHelper.resetScript(script, style)
            themeHelper.synchronize()
        }
    }
    
    private func showSafariViewController() {
        var URLString = ""
        switch script {
        case .Default:
            URLString = "https://github.com/xspyhack/viewer"
        case .Highlight:
            URLString = "https://github.com/isagalaev/highlight.js"
        case .Rainbow:
            URLString = "https://github.com/ccampbell/rainbow"
        }
        let safariController = SFSafariViewController(URL: NSURL(string: URLString)!)
        safariController.delegate = self
        presentViewController(safariController, animated: true, completion: nil)
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

extension StyleViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // section 0 : Style, section 1: License
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return stylesArray.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StyleTableViewCellIdentifier", forIndexPath: indexPath)
        
        if indexPath.section == 1 {
            cell.textLabel?.text = NSLocalizedString("License", comment: "")
            cell.accessoryType = .DisclosureIndicator
        } else {
            cell.textLabel?.text = stylesArray[indexPath.row].name
        }

        return cell
    }
}

extension StyleViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 23
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        switch script {
        case .Default:
            return "http://www.blessingsoft.com"
        case .Highlight:
            return "https://highlightjs.org"
        case .Rainbow:
            return "http://craig.is/making/rainbows"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            showSafariViewController()
            return
        }
        
        if selectedIndexPath == indexPath {
            return
        }
        if let selectedIndexPath = selectedIndexPath {
            let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)
            selectedCell?.accessoryType = .None
        }
        let selectingCell = tableView.cellForRowAtIndexPath(indexPath)
        selectingCell?.accessoryType = .Checkmark

        selectedIndexPath = indexPath
    }
}

extension StyleViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
