//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    lazy private var favoriteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Star-Outline"), style: .plain, target: self, action: #selector(onFavoriteBarButtonSelected(_:)))

    @objc var detailItem: YLPBusiness?
    
    private var _favorite: Bool = false
    private var isFavorite: Bool {
        get {
            return _favorite
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    }
    
    private func configureView() {
        guard let detailItem = detailItem else { return }
        
        thumbnailImage.image = UIImage(named: detailItem.thumbnail)
        categoriesLabel?.text = detailItem.categories
        nameLabel?.text = detailItem.name
        ratingLabel?.text = detailItem.rating.description + " (" + detailItem.reviewCount.description + " reviews)"
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: detailItem.price as NSNumber) {
            priceLabel.text = "\(formattedPrice)"
        }
    }
    
    func setDetailItem(newDetailItem: YLPBusiness) {
        guard detailItem != newDetailItem else { return }
        detailItem = newDetailItem
        //configureView()
    }
    
    private func updateFavoriteBarButtonState() {
        favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
    }
    
    @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
        _favorite.toggle()
        updateFavoriteBarButtonState()
    }
    
    @IBAction func GetDirections(_ sender: Any) {
        guard let item = detailItem else {
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(item.address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    if let coordinate = placemark.location?.coordinate {
                        let mkPlacemark = MKPlacemark(coordinate: coordinate)

                        let mapItem = MKMapItem(placemark: mkPlacemark)

                        mapItem.name = item.name

                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]

                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
