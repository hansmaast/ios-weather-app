//
//  MapForecastView.swift
//  wheather-feather
//
//  Created by Hans Maast on 27/10/2020.
//
import Foundation
import UIKit
import CoreLocation

class MapForecastView: UIView {
    
    // TODO: Make the temp go bakc agin when the switch is off..
    
    let latLabel = UILabel()
    let lonLabel = UILabel()
    let tempLabel = UILabel()
    
    let stack = UIStackView()
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        
        print("Laying out..")
        
        //DispatchQueue.main.async { [self] in
            
            if let pinLocation = Locations.shared.pinLocation {
                setupLabels(coor: pinLocation)
            }
            else {
                setupLabels()
            }
            
            setupStackView()
            
            setupImageView()
            
        //}
        
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = Dimensions.shared.medium16
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - Dimensions.shared.medium16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Stack view
extension MapForecastView {
    
    func setupStackView() {
        
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = Dimensions.shared.medium16
        stack.addArrangedSubview(latLabel)
        stack.addArrangedSubview(lonLabel)
        stack.addArrangedSubview(tempLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor, constant: Dimensions.shared.larger32 * -1),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Dimensions.shared.medium16),
        ])
    }
}

// MARK: Labels
extension MapForecastView {
    
    func setupLabels(coor: CLLocationCoordinate2D = Locations.shared.myLocation!) {
        
        let latString = getCoordString(coor: coor.latitude)
        let lonString = getCoordString(coor: coor.longitude)
        
        latLabel.text = "Latitude: \(latString)"
        latLabel.font = latLabel.font.withSize(Dimensions.shared.large20)
        
        lonLabel.text = "Longitude \(lonString)"
        lonLabel.font = lonLabel.font.withSize(Dimensions.shared.large20)
        
        if let weatherData = getWeatherDataFromCache(fileName: .specificLocation)?.properties
        {
            if let temp = weatherData.timeseries[0].data.instant?.details?.air_temperature {
                let unit = weatherData.meta.units.air_temperature
                print("Temp: \(temp) \(unit)")
                
                tempLabel.text = "Temp: \(temp) \(unit)"
                tempLabel.font = lonLabel.font.withSize(Dimensions.shared.large20)
            }
        }
    }
}

// MARK: Image view
extension MapForecastView {
    
    func setupImageView(imageType: String = "rain") {
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.shared.small8),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Dimensions.shared.small8 * -1),
            imageView.widthAnchor.constraint(equalTo: heightAnchor, constant: Dimensions.shared.medium16 * -1),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.shared.larger32 * -1),
        ])
        
        if let weatherData = getWeatherDataFromCache(fileName: .specificLocation)?.properties.timeseries[0].data,
           let iconName = weatherData.next_6_hours?.summary?.symbol_code {
            print("Icon name: \(iconName)")
            imageView.image = UIImage(named: iconName)
        }
    }
}

protocol MapForecastViewDelegate {
    func getPointCoordinates(coords: CLLocationCoordinate2D) -> CLLocationCoordinate2D
}
