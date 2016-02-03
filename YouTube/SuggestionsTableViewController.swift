//
//  SuggestionsTableViewController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/3/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

protocol SuggestionDelegate{
    func newSearch(string : String)
    func putTextOnSearchField(string : String)
}

class SuggestionsTableViewController: UITableViewController {
    var searchProvider = SearchResultsProvider()
    var strings : [String]?{
        didSet{
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                }
        }
    }
    var delegate : SuggestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(SuggestionsTableViewCell.self, forCellReuseIdentifier: "cellS")
        tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .clearColor()
        view.backgroundColor = .clearColor()
        tableView.backgroundColor = .clearColor()
    }
    func getSearchResults(string : String){
        searchProvider.getSearchSuggestions(string) { (strings) -> Void in
            self.strings = strings
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return strings?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellS", forIndexPath: indexPath) as! SuggestionsTableViewCell
        if strings?.count > indexPath.row{
            cell.titleLabelV.text = strings![indexPath.row]
        }
        cell.putTextButton.addTarget(self, action: "putTextinTextField:", forControlEvents: .TouchDown)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        delegate?.newSearch(strings![indexPath.row])
    }
    
    func putTextinTextField(sender : UIButton){
        if let cell = sender.superview?.superview as? SuggestionsTableViewCell{
            if let indexPath = tableView.indexPathForCell(cell){
                delegate?.putTextOnSearchField(strings![indexPath.row])
            }
        }
    }
    


}
