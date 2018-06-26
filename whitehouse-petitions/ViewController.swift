//
//  ViewController.swift
//  whitehouse-petitions
//
//  Created by Leo Liu on 6/25/18.
//  Copyright © 2018 hungryforcookies. All rights reserved.
//

import UIKit
import os.log
import SwiftyJSON

class ViewController: UITableViewController {
    
    //array of dictionaries for petitions
    var petitions = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"

        if let url = URL(string: urlString){
            if let data = try? String(contentsOf: url){ //try incase nothing returned
                let json = JSON(parseJSON: data)
                
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    //we're good to go
                    print(json["metadata"]["responseInfo"]["developerMessage"].stringValue)
                    
                    parse(json: json)
                }
            }
        }
        
    }
    
    func parse(json: JSON){
        for result in json["results"].arrayValue{
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let signatureCount = result["signatureCount"].stringValue //get it as string to put in dict
            let petition = ["title": title, "body": body, "signatureCount": signatureCount]
            
            petitions.append(petition)
        }
        
        tableView.reloadData()
    }
    
    //MARK:Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        
        return cell
    }


}

