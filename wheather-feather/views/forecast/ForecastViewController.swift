//
//  ForecastViewController.swift
//  wheather-feather
//
//  Created by Hans Maast on 26/10/2020.
//  Inspired by this article:
//  https://medium.com/cleansoftware/quickly-implement-tableview-collectionview-programmatically-df12da694af9


import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    var properties: [TimeSerieProps] =  []
    
    let cellReuseId = "ForecastTableViewCell"
    
    var delegate: WeatherDataDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        properties = (delegate?.getPropertiesOfFirstTimeSerieData(for: .currentLocation))!
        
        setupTableView()
                
        print("Forecast did load!")
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
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ])
    }
    
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.getPropertiesOfFirstTimeSerieData(for: .currentLocation).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as! ForecastTableViewCell
        
        let data = properties[indexPath.row]
        
        switch data {
        case .Instant(let val):
            // cell.titleLabel.text = String(format: "%f", val.details!.air_temperature as! CVarArg)
            cell.timeLabel.text = "Now"
            if let temperature = val.details?.air_temperature {
                cell.infoLabel.text = "Temperature: \(temperature)"
            }
            return cell
        case .OneHour(let val):
            // cell.titleLabel.text = val.summary?.symbol_code
            cell.timeLabel.text = "Next hour"
            if let iconName = val.summary?.symbol_code {
                cell.forecastCellImage.image = UIImage(named: iconName)
            }
            return cell
        case .SixHours(let val):
            // cell.titleLabel.text = val.summary?.symbol_code
            cell.timeLabel.text = "Next 6 hours"
            if let iconName = val.summary?.symbol_code {
                cell.forecastCellImage.image = UIImage(named: iconName)
            }
            return cell
        case .TwelveHours(let val):
            // cell.titleLabel.text = val.summary?.symbol_code
            cell.timeLabel.text = "Next 12 hours"
            if let iconName = val.summary?.symbol_code {
                cell.forecastCellImage.image = UIImage(named: iconName)
            }
            return cell
        }
    }
    
}
