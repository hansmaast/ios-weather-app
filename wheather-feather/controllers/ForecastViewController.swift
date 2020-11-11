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
    
    let footer = UIView()
    
    let footerLabel = UILabel()
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFooter()
        
        setupTableView()
                
        print("Forecast did load!")
    }
    
    override func viewWillAppear(_ animated: Bool) {

        setupFooterLabel()
        
        DispatchQueue.global().async { [self] in
            if let props = SpecificLocationWeather.shared?.getPropertiesOfFirstTimeSerieData() {
                print("Weve got som props!!")
                properties = props
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - setupUI
extension ForecastViewController {
    
    private func setupTableView(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func setupFooter() {
        view.addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footer.widthAnchor.constraint(equalTo: view.widthAnchor),
            footer.heightAnchor.constraint(equalToConstant: 50),
            footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupFooterLabel() {

        footer.addSubview(footerLabel)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.font = footerLabel.font.withSize(Dimensions.shared.small12)
        NSLayoutConstraint.activate([
            footerLabel.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: Dimensions.shared.small12 * -1),
            footerLabel.leftAnchor.constraint(equalTo: footer.leftAnchor, constant: Dimensions.shared.small12),
        ])
        
        var lat: String
        var lon: String
        if let location = Locations.shared.specific {
            lat = getCoordString(coor: location.latitude)
            lon = getCoordString(coor: location.longitude)
        
            footerLabel.text = "Forecast for location \(lat) / \(lon)"
        }
    }
    
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.properties.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as! ForecastTableViewCell
        
        let data = properties[indexPath.row]
        
        switch data {
        case .Instant(let val):
            cell.timeLabel.text = "Now"
            if let temp = val.details?.air_temperature,
               let unit = CurrentLocationWeather.shared?.units?.air_temperature {
                cell.infoLabel.text = "Temperature: \(temp) \(unit)"
            }
        case .OneHour(let val):
            cell.timeLabel.text = "Next hour"
            if let iconName = val.summary?.symbol_code,
               let amount = val.details?.precipitation_amount,
               let unit = CurrentLocationWeather.shared?.units?.precipitation_amount {
                cell.forecastCellImage.image = UIImage(named: iconName)
                cell.infoLabel.text = "\(amount) \(unit)"
            }
        case .SixHours(let val):
            cell.timeLabel.text = "Next 6 hours"
            if let iconName = val.summary?.symbol_code,
               let amount = val.details?.precipitation_amount,
               let unit = CurrentLocationWeather.shared?.units?.precipitation_amount {
                cell.forecastCellImage.image = UIImage(named: iconName)
                cell.infoLabel.text = "\(amount) \(unit)"
            }
        case .TwelveHours(let val):
            cell.timeLabel.text = "Next 12 hours"
            if let iconName = val.summary?.symbol_code {
                cell.forecastCellImage.image = UIImage(named: iconName)
               
                cell.infoLabel.text = formatSummary(for: iconName)
                
            }
        }
        
        return cell
    }
    
}
