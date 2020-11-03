//
//  HomeViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inpired by this post: https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    let titleLabel = UILabel()
    let textLabel = UILabel()
    let dateLabel = UILabel()
    let homeImageView = UIImageView()
    let resultViewController = UIViewController()
    
    var data: CurrentLocationWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationUpdated),
            name: WeatherDataNotifications.currentLocationUpdated,
            object: nil)
        
        data = CurrentLocationWeather.shared
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        setupTitleLabel()
        
        setupHomeImage()
        
        setupTextLabel()
        
        setupDateLabel()
        
        print("Home did load!")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        data = CurrentLocationWeather.shared
        
    }
    
    
}



extension HomeViewController {
    
    @objc func locationUpdated() {
        DispatchQueue.main.async {
            self.view.setNeedsLayout()
        }
    }
    
    // https://stackoverflow.com/questions/39764088/swipe-gesture-in-swift-3
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            print("Swipe Right")
        }
        else if gesture.direction == .left {
            print("Swipe Left")
        }
        else if gesture.direction == .up {
            print("Swipe Up")
            self.present(self, animated:true, completion:nil)
        }
        else if gesture.direction == .down {
            print("Swipe Down")
        }
    }
    
    func setupHomeImage() {
        
        view.addSubview(homeImageView)
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5),
            homeImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5),
            homeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            homeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        if let iconName = CurrentLocationWeather.shared.nextTwelveHours.summary?.symbol_code {
            homeImageView.image = UIImage(named: iconName)
        }
        
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
        textLabel.text = data!.getHomeText()
        textLabel.font = titleLabel.font.withSize(Dimensions.shared.large20)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: Dimensions.shared.large24 * 2),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = data!.getUpdatedAt()
        dateLabel.font = textLabel.font.withSize(Dimensions.shared.small12)
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.shared.small8 * -1),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}
