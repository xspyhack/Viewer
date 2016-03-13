//
//  ThemeViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 3/9/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case ShowStyle = "showStyle"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var scriptsArray: [ThemeHelper.Script] = {
        return ThemeHelper.Script.allValues
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = NSLocalizedString("Theme", comment: "")
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
        
        switch segueIdentifierForSegue(segue) {
        case .ShowStyle:
            let viewController = segue.destinationViewController as! StyleViewController
            if let indexPath = sender as? NSIndexPath {
                viewController.script = scriptsArray[indexPath.row]
            }
        }
    }
}

extension ThemeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScriptTableViewCellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = scriptsArray[indexPath.row].name
        return cell
    }
}

extension ThemeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 23
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        // Segue between two view controllers, not cell <-> view controller
        performSegueWithIdentifier(SegueIdentifier.ShowStyle, sender: indexPath)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return NSLocalizedString("If you selected theme(style) doesn't work well for some web page, maybe you need to try with anothers theme(style).", comment: "")
    }
}
