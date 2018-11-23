//
//  MapViewController.swift
//  Weather
//
//  Created by 冨田悠斗 on 2018/11/02.
//  Copyright © 2018 kang haejoon. All rights reserved.
//

import UIKit
import MapKit
import GoogleMobileAds

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var myLocationManager:CLLocationManager!
    var pinByLongPress:MKPointAnnotation?
    var lon = 0.0
    var lat = 0.0
    
    //ads
    @IBOutlet weak var adsView: UIView!
    // Ads Unit ID
    let AdMobID = "ca-app-pub-3243383061950023/4668585209"
    // Ads Testing Unit ID
    let TEST_ID = "ca-app-pub-3940256099942544/2934735716"
    let AdMobTest : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager = CLLocationManager()
        myLocationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        myLocationManager.delegate = self
        
        //ads
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPoint(x:0, y:0)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        if AdMobTest {
            admobView.adUnitID = TEST_ID
        }else{
            admobView.adUnitID = AdMobID
        }
        admobView.rootViewController = self
        admobView.load(GADRequest())
        adsView.addSubview(admobView)
        self.view.addSubview(adsView)
        //ads
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
