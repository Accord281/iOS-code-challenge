//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController?
    
    var businesses: [YLPBusiness] = []
    var tempbusinesses: [YLPBusiness]?
    
    lazy private var dataSource: NXTDataSource? = {
        guard let dataSource = NXTDataSource(objects: nil) else { return nil }
        
        dataSource.tableViewDidReceiveData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        
        dataSource.tableViewDidSelectCell = {
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        let query = YLPSearchQuery(location: "5550 West Executive Dr. Tampa, FL 33609")
        //Sample data for testing
        tempbusinesses = [
            YLPBusiness(attributes: [
                "identifier":"A123",
                "name": "Starbucks",
                "categories": "coffee,food",
                "rating": 4.5,
                "reviewCount": 7,
                "distance": 8.7,
                "price": 8.50,
                "thumbnail": "Starbucks",
                "address": "1508 N Westshore Blvd, Tampa, FL 33607"
            ]),
            YLPBusiness(attributes: [
                "identifier":"A125",
                "name": "Caribou",
                "categories": "coffee",
                "rating": 4.7,
                "reviewCount": 13,
                "distance": 8.9,
                "price": 6.30,
                "thumbnail": "Caribou",
                "address": "5003 E Fowler Ave, Tampa, FL 33617"
            ]),
            YLPBusiness(attributes: [
                "identifier":"A126",
                "name": "McDonalds",
                "categories": "coffee,food,restaurant",
                "rating": 3.5,
                "reviewCount": 17,
                "distance": 8.8,
                "price": 2.00,
                "thumbnail": "McDonalds",
                "address": "2101 E 13th Ave, Tampa, FL 33605"
            ])
        ]

        //sort by distance
        tempbusinesses?.sort(by: { $0.distance.decimalValue < $1.distance.decimalValue })
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
            guard let strongSelf = self,
                let dataSource = strongSelf.dataSource,
                let searchResults = strongSelf.tempbusinesses else {
                    return
            }
            self?.businesses = searchResults
            dataSource.setObjects(self?.businesses);
            strongSelf.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let navcontroller = segue.destination as? UINavigationController,
                let controller = navcontroller.topViewController as? DetailViewController else {
                return
            }
            let object = self.businesses[indexPath.row]
            controller.setDetailItem(newDetailItem: object)
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

}
