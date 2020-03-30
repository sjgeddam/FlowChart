//
//  LocationViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/29/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapKit: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Do any additional setup after loading the view.
    }
    

}

extension LocationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        if location != nil {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion.init(center: location!.coordinate, span: span)
            mapKit.setRegion(region, animated: true)
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!) { (placemarksArray, error) in

            if (placemarksArray?.count)! > 0 {

                let placemark = placemarksArray?.first
                
                self.locationLabel.text = placemark?.locality
            }
        }

    }
}
