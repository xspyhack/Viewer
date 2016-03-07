//
//  ResultsViewController.swift
//  Viewer
//
//  Created by bl4ckra1sond3tre on 2/24/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var allResults: String?
    var visibleResults: [String]?
    
    @IBOutlet weak var textView: UITextView!
    
    var filterString: String? {
        didSet {
            if let filterString = filterString where !filterString.isEmpty {
                filter(filterString)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.text = allResults
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func filter(pattern: String) {
        guard let allResults = allResults else { return }
        
        let matcher: RegexHelper
        do {
            matcher = try RegexHelper(pattern)
        } catch {
            tv_print(error)
            return
        }
        
        let attributedString = NSMutableAttributedString(string: allResults)
        
        matcher.enumerateMatches(allResults) { (result) -> Void in
            if let result = result {
                let attributes: [String: AnyObject] = [
                    NSBackgroundColorAttributeName: UIColor.yellowColor(),
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
                ]
                
                attributedString.addAttributes(attributes, range: result.range )
            }
        }
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange(0, allResults.characters.count))
        
        textView.attributedText = attributedString
    }
}

extension ResultsViewController: UISearchResultsUpdating {
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // updateSearchResultsForSearchController(_:) is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
        if !searchController.active {
            return
        }
        
        filterString = searchController.searchBar.text
    }
}
