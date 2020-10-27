//
//  ForecastViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
   
    
    var titles: [String] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
    
    let cellReuseId = "ForecastTableViewCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: cellReuseId)
           tableView.tableFooterView = UIView()
           tableView.translatesAutoresizingMaskIntoConstraints = false
           return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        print("Forecast did load!")
    }
}

extension ForecastViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let locactionCoordinates = manager.location?.coordinate else {
            print("Could not get current location..")
            return
        }
        print("locations = \(locactionCoordinates.latitude) \(locactionCoordinates.longitude)")
    }
}

// MARK: - setupUI
extension ForecastViewController {
    
    private func setupTableView(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
    
}

// MARK: - Delegates && DataSource
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as! ForecastTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        return cell
    }
}
