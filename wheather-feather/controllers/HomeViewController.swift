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
            selector: #selector(self.renderLayout),
            name: WeatherDataNotifications.currentLocationFetchDone,
            object: nil)
        
        data = CurrentLocationWeather.shared
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        data = CurrentLocationWeather.shared
        
        checkIfRain()
        
        setupSwipeGestures()
        
        setupTitleLabel()
        
        setupHomeImage()
        
        setupTextLabel()
        
        setupDateLabel()
        
    }
    
    @objc func renderLayout() {
        DispatchQueue.main.async {
            self.viewWillAppear(true)
        }
        print("🌧 🔆 🌤")
    }
    
    
}



extension HomeViewController {
    
    func setupNotificationObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationUpdated),
            name: WeatherDataNotifications.currentLocationUpdated,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleErrorNotification(_:)),
            name: WeatherDataNotifications.fetchFailed,
            object: nil)
        
    }
    
    @objc func handleErrorNotification(_ notification: Notification) {
        
        if let err = notification.userInfo?["error"] as? Error {
            
            displayAlert(err, to: self)
            
        }
        
        
        
    }
    
    func displayRainDrops() {
        
        /**
         Droplets found here:
         Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
         */
        
        let maxX = UIScreen.main.bounds.maxX
        let minX = UIScreen.main.bounds.minX
        let maxY = UIScreen.main.bounds.maxY
        _ = UIScreen.main.bounds.minY
        
        // Here we could f.ex say 1...percipitationAmout * 100,
        // And the droplets would be raltive to the amount of rain :)
        for n in 1...100 {
            
            let randomRectSize = CGFloat.random(in: 5...25)
            
            let duration = randomRectSize / 15
            
            let rainDrop = UIImageView(frame: CGRect(x: CGFloat.random(in: minX...maxX),
                                                     y: 0,
                                                     width: randomRectSize,
                                                     height: randomRectSize))
            rainDrop.image = UIImage(named: "rainDrop")
            
            UIView.animate(withDuration: TimeInterval(duration),
                           delay: Double(n) * 0.01,
                           options: [.repeat, .preferredFramesPerSecond60, .curveEaseIn],
                           animations: {
                            
                            rainDrop.transform = CGAffineTransform(translationX: 0, y: maxY)
                            
                           })
            
            view.addSubview(rainDrop)
        }
    }
    
    
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
        }
        else if gesture.direction == .down {
            print("Swipe Down")
        }
    }
    
    func setupSwipeGestures(){
        
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
        
    }
    
    func displaySunAnimation() {
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options: [.repeat, .preferredFramesPerSecond60, .curveLinear],
                       animations: {
                        self.homeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                       })
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options: [.preferredFramesPerSecond60, .curveEaseIn],
                       animations: {
                        self.view.backgroundColor = .yellow
                       })
        
    }
    
    func checkIfRain() {
        
        
        
        if ((data?.isRainNextTwelveHours()) != nil) {
            homeImageView.image = UIImage(named: "umbrella")
            textLabel.text = "Don't forget your umbrella!"
            displayRainDrops()
        } else {
            homeImageView.image = UIImage(named: "sun")
            displaySunAnimation()
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
    
    // TODO: Make sure it breaks the text!
    func setupTextLabel() {
        
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = data?.getHomeText()
        textLabel.font = titleLabel.font.withSize(Dimensions.shared.large20)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: Dimensions.shared.large24 * 2),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = data?.getUpdatedAt()
        dateLabel.font = textLabel.font.withSize(Dimensions.shared.small12)
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.shared.small8 * -1),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}
