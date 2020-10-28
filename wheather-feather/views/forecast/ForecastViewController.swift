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
    
    var data: [Container] = []
    
    let cellReuseId = "ForecastTableViewCell"
    
    var delegate: WeatherDataDelegate?
    
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
        
        let data = delegate?.getPropertiesOfFirstTimeSerieData(for: .currentLocation)[indexPath.row]
        
        
        switch data! {
        case .Instant(let val):
            // cell.titleLabel.text = String(format: "%f", val.details!.air_temperature as! CVarArg)
            cell.titleLabel.text = "Now"
            return cell
        case .OneHour(let val):
            // cell.titleLabel.text = val.summary?.symbol_code
            cell.titleLabel.text = "Next hour"
            return cell
        case .SixHours(let val):
            // cell.titleLabel.text = val.summary?.symbol_code
            cell.titleLabel.text = "Next 6 hours"
            return cell
        case .TwelveHours(let val):
            // cell.titleLabel.text = val.summary?.symbol_code
            cell.titleLabel.text = "Next 12 hours"
            return cell
        }
    }
    
}
