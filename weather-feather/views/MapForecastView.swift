

import Foundation
import UIKit
import CoreLocation

class MapForecastView: UIView {
        
    let latLabel = UILabel()
    let lonLabel = UILabel()
    let tempLabel = UILabel()
    
    let stack = UIStackView()
    let imageView = UIImageView()
    
    var temp: Float? = CurrentLocationWeather.shared?.instant?.details?.air_temperature
    var unit: String? = CurrentLocationWeather.shared?.units?.air_temperature
    var iconName: String? = CurrentLocationWeather.shared?.nextOneHour?.summary?.symbol_code
    
    override func layoutSubviews() {
        
        print("Laying out..")
        
        assignTemptAndIconName()
        
        setupLabels()
        
        setupStackView()
        
        setupImageView()
        
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
    
    func assignTemptAndIconName() {
        guard temp == nil,
              unit == nil,
              iconName == nil
        else { return }
        
        temp = CurrentLocationWeather.shared?.instant?.details?.air_temperature
        unit = CurrentLocationWeather.shared?.units?.air_temperature
        iconName = CurrentLocationWeather.shared?.nextOneHour?.summary?.symbol_code
        
    }
    
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
    
    func setupLabels(coor: CLLocationCoordinate2D = Locations.shared.specific!) {
        
        let latString = getCoordString(coor: coor.latitude)
        let lonString = getCoordString(coor: coor.longitude)
        
        latLabel.text = "Latitude: \(latString)"
        latLabel.font = latLabel.font.withSize(Dimensions.shared.large20)
        
        lonLabel.text = "Longitude \(lonString)"
        lonLabel.font = lonLabel.font.withSize(Dimensions.shared.large20)
        
        if let temp = self.temp,
           let unit = self.unit {
            tempLabel.text = "Temp: \(temp) \(unit)"
            tempLabel.font = lonLabel.font.withSize(Dimensions.shared.large20)
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
        
        if let iconName = self.iconName {
            imageView.image = UIImage(named: iconName)
        }
    }
}

protocol MapForecastViewDelegate {
    func getPointCoordinates(coords: CLLocationCoordinate2D) -> CLLocationCoordinate2D
}
