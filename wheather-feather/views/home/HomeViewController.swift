//
//  HomeViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inpired by this post: https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//

import UIKit

class HomeViewController: UIViewController {
    
    let titleLabel = UILabel()
    let textLabel = UILabel()
    let dateLabel = UILabel()
    let homeImageView = UIImageView()

    var delegate: WeatherDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("from delegate: \(delegate!.getHomeText())")
        
        setupTitleLabel()
        
        setupHomeImage()
        
        setupTextLabel()
        
        setupDateLabel()
        
        print("Home did load!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.setNeedsLayout()
    }
}


extension HomeViewController {
        
    func setupHomeImage() {
        
        view.addSubview(homeImageView)
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5),
            homeImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5),
            homeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            homeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let iconName = delegate!.getTwelveHourSummary(for: .currentLocation)!
        homeImageView.image = UIImage(named: iconName)
    }
    
    func setupTitleLabel() {
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = getNameOfDay(for: Date.init())
        titleLabel.font = titleLabel.font.withSize(Dimensions.shared.larger32)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.shared.large24 * 2),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTextLabel() {
        
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = delegate!.getHomeText()
        textLabel.font = titleLabel.font.withSize(Dimensions.shared.large20)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: Dimensions.shared.large24 * 2),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = delegate?.getUpdatedAt(for: .currentLocation)
        dateLabel.font = textLabel.font.withSize(Dimensions.shared.small12)
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.shared.small8 * -1),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}
