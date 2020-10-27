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
    
    let mapView = MKMapView()
    let tapAnnotation = MKPointAnnotation()
    var myLocation = Locations.shared.myLocation!
    
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
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        ])
        
        let span = MKCoordinateSpan.init(latitudeDelta: 1.50, longitudeDelta: 1.50)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController {
    
    func setMyPointAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        annotation.title = UIDevice.current.name
        annotation.subtitle = "Current location"
        mapView.addAnnotation(annotation)
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
        } else {
            print("Switch is off!")
            mapView.removeAnnotation(tapAnnotation)
        }
        
    }
    
}
