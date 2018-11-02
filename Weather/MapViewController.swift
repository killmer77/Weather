//
//  MapViewController.swift
//  Weather
//
//  Created by 冨田悠斗 on 2018/11/02.
//  Copyright © 2018 kang haejoon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var myLocationManager:CLLocationManager!
    var pinByLongPress:MKPointAnnotation?
    var lon = 0.0
    var lat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager = CLLocationManager()
        myLocationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        myLocationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    @IBAction func longPressMap(_ sender: Any) {
        if((sender as AnyObject).state != UIGestureRecognizer.State.began){
            return
        }
        if let pin = pinByLongPress{
            self.mapView.removeAnnotations([pin])
        }
        
        pinByLongPress = MKPointAnnotation()
        
        let location:CGPoint = (sender as AnyObject).location(in: mapView)
        let longPressedCoordinate:CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        self.lon = Double(longPressedCoordinate.longitude)
        self.lat = Double(longPressedCoordinate.latitude)
        print(longPressedCoordinate)
        pinByLongPress!.coordinate = longPressedCoordinate
        mapView.addAnnotation(pinByLongPress!)
    }
    
    @IBAction func done(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? ViewController {
            vc.fromMap = true
            vc.lon = self.lon
            vc.lat = self.lat
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation === mapView.userLocation {
            (annotation as? MKUserLocation)?.title = nil
            return nil
        } else {
            let identifier = "annotation"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
                return annotationView
            } else {
                let myPinIdentifier = "PinAnnotationIdentifier"
                let pinByLongPress = MKPointAnnotation()
                let annotationView = MKPinAnnotationView(annotation: pinByLongPress, reuseIdentifier: myPinIdentifier)
                annotationView.animatesDrop = true
                return annotationView
            }
        }
    }
}
