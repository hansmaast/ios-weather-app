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
    
    let latLabel = UILabel()
    let lonLabel = UILabel()
    
    let stack = UIStackView()
    let imageView = UIImageView()
    
    override func layoutSubviews() {
    
        setupLabels()
        
        setupStackView()
        
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.2),
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 15.0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapForecastView {
    
    func setupStackView() {
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.spacing = 16.0
        stack.addArrangedSubview(latLabel)
        stack.addArrangedSubview(lonLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
        ])
    }
    
}

extension MapForecastView: MapForecastViewDelegate {
    func updateLabels(coor: CLLocationCoordinate2D) {
        setupLabels(coor: coor)
    }
    
    func setupLabels(coor: CLLocationCoordinate2D = Locations.shared.myLocation!) {
        latLabel.text = "Latitude: \(coor.latitude)"
        latLabel.font = latLabel.font.withSize(20)
        lonLabel.text = "Longitude \(coor.longitude)"
        lonLabel.font = lonLabel.font.withSize(20)
    }
    
}

protocol MapForecastViewDelegate {
    func updateLabels(coor: CLLocationCoordinate2D)
}
