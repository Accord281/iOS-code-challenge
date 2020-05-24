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

    @IBOutlet weak var mainStackView: UIStackView!
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
        guard let detailItem = detailItem else {
            mainStackView.isHidden = true
            return
        }
        
        guard let imageUrl = URL(string: detailItem.thumbnail),
            let data = try? Data(contentsOf: imageUrl) else { return }
        DispatchQueue.main.async {
            self.thumbnailImage.image = UIImage(data: data)
        }
        
        categoriesLabel?.text = detailItem.categories
        nameLabel?.text = detailItem.name
        ratingLabel?.text = detailItem.rating.description + " (" + detailItem.reviewCount.description + " reviews)"
        priceLabel.text = detailItem.price
        
        
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
        
        let latitude: CLLocationDegrees = CLLocationDegrees.init(Double(truncating: item.latitude))
        let longitude: CLLocationDegrees = CLLocationDegrees.init(Double(truncating: item.longitude))
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
        let mkPlacemark = MKPlacemark(coordinate: coordinate)

        let mapItem = MKMapItem(placemark: mkPlacemark)

        mapItem.name = item.name

        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]

        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
