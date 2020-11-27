
import UIKit

class ForecastTableViewCell: UITableViewCell {

    let timeLabel = UILabel()
    let forecastCellImage = UIImageView()
    let infoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupContentView()
        
        setupTimeLabel()
        
        setupCellImage()
        
        setupInfoLabel()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ForecastTableViewCell {
    
    private func setupContentView() {
        
        self.contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    private func setupTimeLabel() {
        
        self.contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = timeLabel.font.withSize(Dimensions.shared.medium16)
                NSLayoutConstraint.activate([
                    timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Dimensions.shared.medium16),
                    timeLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Dimensions.shared.medium16),
            
        ])

    }
    
    private func setupCellImage() {
        
        self.contentView.addSubview(forecastCellImage)
        forecastCellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastCellImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: Dimensions.shared.larger32 * -1),
            forecastCellImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: Dimensions.shared.larger32 * -1),
            forecastCellImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            forecastCellImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: Dimensions.shared.larger32 * -1)
        ])
        
    }
    
    private func setupInfoLabel() {
        self.contentView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = infoLabel.font.withSize(Dimensions.shared.large20)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Dimensions.shared.medium16),
            infoLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Dimensions.shared.small12),
        ])
        
        
        
    }
}
