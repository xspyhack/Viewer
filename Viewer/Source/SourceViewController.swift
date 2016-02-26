//
//  SourceViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/23/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController {

    var HTMLString: String?
    
    // `searchController` is set when the search button is clicked.
    var searchController: UISearchController!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = HTMLString
        
        setupSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func setupSearchController() {
        let resultsViewController = storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        resultsViewController.allResults = HTMLString
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Configure the search controller's search bar. For more information on how to configure
        // search bars, see the "Search Bar" group under "Search".
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        
        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    deinit {
        searchController.view.removeFromSuperview()
    }
}
