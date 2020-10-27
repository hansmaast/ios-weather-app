//
//  MapViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inspired by this:
//  https://stackoverflow.com/questions/34431459/ios-swift-how-to-add-pinpoint-to-map-on-touch-and-get-detailed-address-of-th

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var myLocation = Locations.shared.myLocation!
    
    let mapView = MKMapView()
    let tapAnnotation = MKPointAnnotation()
    let myPointAnnotation = MKPointAnnotation()
    
    let switchMapMode = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        setMyPointAnnotation()
        
        addGestureRecognizer()
        
        setupUISwitch()
        
        print("Map did load!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myLocation = Locations.shared.myLocation!
    }
    
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation = manager.location!.coordinate
        
        print("update location! \(myLocation)")
    }
}

extension MapViewController {
    
    func setupMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        ])
        
        centerMapToMyLocation()
    }
    
    func centerMapToMyLocation() {
        let span = MKCoordinateSpan.init(latitudeDelta: 1.50, longitudeDelta: 1.50)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController {
    
    func setMyPointAnnotation() {
        myPointAnnotation.coordinate = myLocation
        myPointAnnotation.title = UIDevice.current.name
        myPointAnnotation.subtitle = "Current location"
        mapView.addAnnotation(myPointAnnotation)
    }
    
}

extension MapViewController {
    
    func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard switchMapMode.isOn else { return }
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        Locations.shared.pinLocation = coordinate
        
        print("Touched: \(coordinate.latitude) / \(coordinate.longitude)")
        
        tapAnnotation.coordinate = coordinate
        mapView.addAnnotation(tapAnnotation)
    }
    
}

extension MapViewController {
    
    func setupUISwitch() {
        view.addSubview(switchMapMode)
        switchMapMode.translatesAutoresizingMaskIntoConstraints = false
        switchMapMode.backgroundColor = .darkGray
        switchMapMode.layer.borderColor = UIColor.white.cgColor
        switchMapMode.layer.borderWidth = 1.5
        switchMapMode.layer.cornerRadius = switchMapMode.frame.height / 2
        NSLayoutConstraint.activate([
            switchMapMode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            switchMapMode.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25)
        ])
        switchMapMode.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch!) {
        
        if (sender.isOn) {
            print("Switch is on!")
            mapView.removeAnnotation(myPointAnnotation)
        } else {
            print("Switch is off!")
            centerMapToMyLocation()
            mapView.addAnnotation(myPointAnnotation)
            mapView.removeAnnotation(tapAnnotation)
        }
        
    }
    
}
