//
//  JHSTopItemTableViewController.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation
import UIKit

class JHSTopItemTableViewController: UITableViewController {

    private var keys: Array<String> = Array<String>()
    
    var topEmojis: Array<JHSHash> = Array<JHSHash>()
    var topDomains: Array<JHSHash> = Array<JHSHash>()
    var topHashTags: Array<JHSHash> = Array<JHSHash>()
    
    let myIdentifier = "ItemCell"

    @IBOutlet var topItemTablevView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if (self.topEmojis.count > 0) {
            self.keys.append("e");
        }

        if (self.topDomains.count > 0) {
            self.keys.append("d");
        }
        
        if (self.topHashTags.count > 0) {
            self.keys.append("h");
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.keys.count;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let key = self.keys[section]
        
        if (key == "d") {
            return self.topDomains.count
        }
        else if (key == "e") {
            return self.topEmojis.count
        }
        else if (key == "h") {
            return self.topHashTags.count
        }
        
        return 0;
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        if (cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.myIdentifier)
        }

        let key = self.keys[indexPath.section]
        var hash:JHSHash
        
        if (key == "d") {
            hash = self.topDomains[indexPath.row];
        }
        else if (key == "e") {
            hash = self.topEmojis[indexPath.row];
        }
        else {
            hash = self.topHashTags[indexPath.row];
        }
        
        cell?.textLabel?.text = hash.text + " (" + String(describing: hash.count) + ")";

        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let key = self.keys[section]
        
        if (key == "d") {
            return "Top Domains";
        }
        else if (key == "e") {
            return "Top Emojis";
        }
        else {
            return "Top Hash Tags";
        }
    }
}
