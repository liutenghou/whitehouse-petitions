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
        
        //TODO: add loading animation
        var urlString:String = ""
        if navigationController?.tabBarItem.tag == 0{
            //recent
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        }else if navigationController?.tabBarItem.tag == 1{
            //popular
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString), let data = try? String(contentsOf: url){
            let json = JSON(parseJSON: data)
            if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                //we're good to go
                print(json["metadata"]["responseInfo"]["developerMessage"].stringValue)
                
                parse(json: json)
                return
            }
        }
        
        //error if reached
        
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
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "Problem loading feed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

