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
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
        dataSource.tableViewDidScrollToBottom = {
            self.loadMoreBusinesses()
        }
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        determineMyCurrentLocation()
        
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
        let currentLocation = locationManager.location
        var locationString: String = "5550 West Executive Dr. Tampa, FL 33609"
        
        var query: YLPSearchQuery
        
        if let location = currentLocation {
            locationString = location.coordinate.latitude.description + "," + location.coordinate.longitude.description
            query = YLPSearchQuery(latitude: location.coordinate.latitude.description, longitude: location.coordinate.longitude.description, limit: "50", offset: dataSource?.objects.count.description ?? "0", sortby: "distance")
        } else {
            query = YLPSearchQuery(location: locationString)
        }
        
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
            guard let strongSelf = self,
                let dataSource = strongSelf.dataSource,
                let searchResults = searchResult?.businesses.sorted(by: { $0.distance.decimalValue < $1.distance.decimalValue }) else {
                    return
            }
            self?.businesses.append(contentsOf: searchResults)
            dataSource.setObjects(self?.businesses);
            strongSelf.tableView.reloadData()
        })
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
