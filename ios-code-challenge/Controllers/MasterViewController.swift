//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: UITableViewController, CLLocationManagerDelegate {
    
    var detailViewController: DetailViewController?

    var locationManager = CLLocationManager()
    
    var businesses: [YLPBusiness] = []
    var tempbusinesses: [YLPBusiness]?
    
    lazy private var dataSource: NXTDataSource? = {
        guard let dataSource = NXTDataSource(objects: nil) else { return nil }
        
        dataSource.tableViewDidReceiveData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        
        dataSource.tableViewDidSelectCell = {
            //Open detail view
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
        dataSource.tableViewDidScrollToBottom = {
            //If scrolled to very bottom, load next batch of businesses
            self.loadMoreBusinesses()
        }
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        //Use location services to get location and use that for search by distance
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        determineMyCurrentLocation()
        
        //Load initial list of businesses
        loadMoreBusinesses()
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
    
    func loadMoreBusinesses() {
        //If a current location was found, use that location to load a list of businesses based on distance.
        if let location = locationManager.location {
            //To implement pagination, change limit to 50 and offset by the current number of results already obtained.
            //Sort by distance.
            let query = YLPSearchQuery(latitude: location.coordinate.latitude.description, longitude: location.coordinate.longitude.description, limit: "50", offset: dataSource?.objects.count.description ?? "0", sortby: "distance")
            
            AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
                guard let strongSelf = self,
                    let dataSource = strongSelf.dataSource,
                    let searchResults = searchResult?.businesses else {
                        return
                }
                
                //Append the results to the current list of businesses and set this list as data source for the table.
                self?.businesses.append(contentsOf: searchResults)
                dataSource.setObjects(self?.businesses);
                strongSelf.tableView.reloadData()
            })
        }
    }
    
    func determineMyCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
    }

}
