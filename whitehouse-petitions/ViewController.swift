//
//  ViewController.swift
//  whitehouse-petitions
//
//  Created by Leo Liu on 6/25/18.
//  Copyright © 2018 hungryforcookies. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UITableViewController {
    
    //array of dictionaries for petitions
    var petitions = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"

        if let url = URL(string: urlString){
            if let data = try? String(contentsOf: url){
                let json = JSON(parseJSON: data)
                
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    //we're good to go
                    print(json["metadata"]["responseInfo"]["developerMessage"])
                }
            }
        }
        
    }
    
    //MARK:Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Title goes here"
        cell.detailTextLabel?.text = "Subtitle goes here"
        
        return cell
    }


}

