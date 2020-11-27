//
//  MapViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inspired by this:
//  https://stackoverflow.com/questions/34431459/ios-swift-how-to-add-pinpoint-to-map-on-touch-and-get-detailed-address-of-th

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    var myLocation = Locations.shared.current
    
    let mapView = MKMapView()
    let mapForecastView = MapForecastView()
    
    let tapAnnotation = MKPointAnnotation()
    let myPointAnnotation = MKPointAnnotation()
    
    let switchMapMode = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationUpdated),
            name: WeatherDataNotifications.currentLocationUpdated,
            object: nil)
        
        setupMap()
        
        setupForecastView()
        
        setMyPointAnnotation()
        
        addGestureRecognizer()
        
        setupUISwitch()
        
        print("Map did load!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myLocation = Locations.shared.current
    }
    
}

// MARK: Map view
extension MapViewController {
    
    func setupMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        centerMapToMyLocation()
    }
    
    func centerMapToMyLocation() {
        let span = MKCoordinateSpan.init(latitudeDelta: 1.50, longitudeDelta: 1.50)
        let region = MKCoordinateRegion(center: myLocation!, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func locationUpdated() {
        
        myLocation = Locations.shared.current
        
        DispatchQueue.main.async {
            self.setMyPointAnnotation()
            self.mapForecastView.setNeedsLayout()
        }
    }
    
}

// MARK: Point annotation
extension MapViewController {
    
    func setMyPointAnnotation() {
        mapView.removeAnnotation(myPointAnnotation)
        myPointAnnotation.coordinate = myLocation!
        myPointAnnotation.title = UIDevice.current.name
        myPointAnnotation.subtitle = "Current location"
        mapView.addAnnotation(myPointAnnotation)
    }
    
}

// MARK: Gesture recognizer
extension MapViewController: UIGestureRecognizerDelegate {
    
    func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard switchMapMode.isOn else { return }
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        print("User interactive triggered!")
        
        print("Touched: \(coordinate.latitude) / \(coordinate.longitude)")
        Locations.shared.specific = coordinate
        self.tapAnnotation.coordinate = coordinate
        self.mapView.addAnnotation(self.tapAnnotation)
        
        fetchDataFrom(coordinates: coordinate, saveToCacheAs: .specificLocation) { error, data in
            
            if let error = error {
                
                displayAlert(error, to: self)
                return
                
            }
            
            print("👆Fetched data for pin location!")
            
            // Updates UI when fetching is finished...
            DispatchQueue.global(qos: .userInteractive).async {
                SpecificLocationWeather.shared?.updateWeatherData()
                
                self.mapForecastView.temp = SpecificLocationWeather.shared?.instant?.details?.air_temperature
                self.mapForecastView.unit = SpecificLocationWeather.shared?.units?.air_temperature
                self.mapForecastView.iconName = SpecificLocationWeather.shared?.nextOneHour?.summary?.symbol_code
                
                DispatchQueue.main.async {
                    // Updade forecast view
                    self.mapForecastView.setNeedsLayout()
                }
            }
        }
        
    }
}


// MARK: UISwitch
extension MapViewController {
    
    func setupUISwitch() {
        view.addSubview(switchMapMode)
        switchMapMode.translatesAutoresizingMaskIntoConstraints = false
        switchMapMode.backgroundColor = .darkGray
        switchMapMode.layer.borderColor = UIColor.white.cgColor
        switchMapMode.layer.borderWidth = 1.5
        switchMapMode.layer.cornerRadius = switchMapMode.frame.height / 2
        NSLayoutConstraint.activate([
            switchMapMode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.shared.large24),
            switchMapMode.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: Dimensions.shared.large24 * -1)
        ])
        switchMapMode.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch!) {
        
        if (sender.isOn) {
            print("Switch is on!")
            mapView.removeAnnotation(myPointAnnotation)
        }
        else {
            print("Switch is off!")
            
            Locations.shared.specific = myLocation
            
            SpecificLocationWeather.shared?.updateWeatherData()
            
            
            mapForecastView.temp = CurrentLocationWeather.shared?.instant?.details?.air_temperature
            mapForecastView.unit = CurrentLocationWeather.shared?.units?.air_temperature
            mapForecastView.iconName = CurrentLocationWeather.shared?.nextOneHour?.summary?.symbol_code
            
            centerMapToMyLocation()
            mapView.addAnnotation(myPointAnnotation)
            mapView.removeAnnotation(tapAnnotation)
            
            mapForecastView.setNeedsLayout()
        }
        
    }
    
}

// MARK: Forecast view
extension MapViewController {
    
    func setupForecastView() {
        
        view.addSubview(mapForecastView)
        NSLayoutConstraint.activate([
            mapForecastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.shared.small8 * -1),
            mapForecastView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
}

// MARK: Location manager
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation = manager.location!.coordinate
        
        print("update location! \(myLocation)")
    }
    
}
