//
//  LocationViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/29/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapKit: MKMapView!
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(true,animated:false)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Do any additional setup after loading the view.
    }
    
    func plotClinicPoints() {
        var count = 0
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Women Clinic"
        request.region = mapKit.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            for item in response.mapItems.prefix(3) {
                let label = UILabel(frame: CGRect(x: 20, y: 160 + count * 40, width: 375, height: 35))
                label.textAlignment = .left
                label.font = UIFont (name: "ReemKufi-Regular", size: 25)
                label.text = item.name
                self.view.addSubview(label)
                count += 1
                let placemark = item.placemark
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                self.mapKit.addAnnotation(annotation)
            }
        }
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
        plotClinicPoints()
    }
}
