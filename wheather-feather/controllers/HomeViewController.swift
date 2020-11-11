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
    
    init(pageIndex: Int, dayWithStartingIndex: [String:Int]) {
        self.pageIndex = pageIndex
        self.dayWithStartingIndex = dayWithStartingIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("Deinit 💣 💣 💣")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let pageIndex: Int
    let dayWithStartingIndex: [String:Int]
    
    let dayLabel = UILabel()
    let dayDateLabel = UILabel()
    let weatherInfoLabel = UILabel()
    let updatetAtLabel = UILabel()
    
    let homeImageView = UIImageView()
    let weatherIconView = UIImageView()
    
    var data: CurrentLocationWeather?
    
    lazy var dayIndex = dayWithStartingIndex.values.first
    lazy var timserie = CurrentLocationWeather.shared?.timeSeries![dayIndex!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        data = CurrentLocationWeather.shared
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        data = CurrentLocationWeather.shared
        
        view.backgroundColor = .white
        
        setupSwipeGestures()
        
        setupDayLabel()
        
        setupDayDateLabel()
        
        setupHomeImage()
        
        setupWeatherInfoLabel()
        
        setupUpdatedAtLabel()
        
        setupWeatherIcon()
        
        checkIfRain()
        
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
        
        let percipitaionAmount = timserie?.data.next_6_hours?.details?.precipitation_amount ?? 1
        
        print("Amount of rain: \(percipitaionAmount)")
        
        // Here we could f.ex say 1...percipitationAmout * 100,
        // And the droplets would be raltive to the amount of rain :)
        let relativeRain = Int(percipitaionAmount * 25)
        for n in 1...relativeRain {
            
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
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.preferredFramesPerSecond60, .curveEaseIn],
                       animations: {
                        self.view.backgroundColor = .yellow
                       })
        
    }
    
    func checkIfRain() {
        
        // Continue here..
        guard let dayIndex = dayWithStartingIndex.values.first else { return }
        
        if let timeserie = CurrentLocationWeather.shared?.getTimeSerieAt(index: dayIndex) {
            
            print("Timeserie data: \(timeserie.data.next_12_hours?.summary?.symbol_code)")
            
            if let symbolCode = timeserie.data.next_12_hours?.summary?.symbol_code {
             
                weatherIconView.image = UIImage(named: symbolCode)
                
                let nameOfDay = dayWithStartingIndex.keys.first!.lowercased()
                let summary = formatSummary(for: symbolCode)
                let summaryText = "\nHere's \(nameOfDay)'s summary:\n \(summary)"
                if symbolCode.contains("rain") {
                    homeImageView.image = UIImage(named: "umbrella")
                    weatherInfoLabel.text = "Don't forget your umbrella!\(summaryText)"
                    displayRainDrops()
                } else {
                    homeImageView.image = UIImage(named: "sun")
                    weatherInfoLabel.text = "No need for an umbrella today!\(summaryText)"
                    displaySunAnimation()
                }
                
            }
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
    
    func setupWeatherIcon() {
        
        view.addSubview(weatherIconView)
        weatherIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
            weatherIconView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
            weatherIconView.bottomAnchor.constraint(equalTo: updatetAtLabel.topAnchor, constant: Dimensions.shared.larger32 * -1),
            weatherIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func setupDayLabel() {
        
        view.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.text = dayWithStartingIndex.keys.first
        dayLabel.font = dayLabel.font.withSize(Dimensions.shared.larger32)
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.shared.large24 * 2),
            dayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupDayDateLabel() {
        
        if let date = convertIsoTo(date: self.timserie!.time) {
            dayDateLabel.text = getDateString(from: date)
        }
        
        view.addSubview(dayDateLabel)
        dayDateLabel.translatesAutoresizingMaskIntoConstraints = false
        //dayDateLabel.text = self.timserie?.time
        dayDateLabel.font = dayDateLabel.font.withSize(Dimensions.shared.small12)
        NSLayoutConstraint.activate([
            dayDateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: Dimensions.shared.medium16),
            dayDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    // TODO: Make sure it breaks the text!
    func setupWeatherInfoLabel() {
        
        view.addSubview(weatherInfoLabel)
        weatherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherInfoLabel.font = dayLabel.font.withSize(Dimensions.shared.large20)
        weatherInfoLabel.numberOfLines = 0
        weatherInfoLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            weatherInfoLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: Dimensions.shared.large24 * 2),
            weatherInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func setupUpdatedAtLabel() {
        view.addSubview(updatetAtLabel)
        updatetAtLabel.translatesAutoresizingMaskIntoConstraints = false
        if let updatedAt = data?.getUpdatedAt() {
            updatetAtLabel.text = "Updated at: \(updatedAt)"
        }
        updatetAtLabel.font = weatherInfoLabel.font.withSize(Dimensions.shared.small8)
        NSLayoutConstraint.activate([
            updatetAtLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.shared.small8 * -1),
            updatetAtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}
