import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var gradientContainerView: UIView!
    
    private var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientContainerView.bounds
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemPurple.withAlphaComponent(0.3).cgColor,
            UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradient.frame = gradientContainerView.bounds
        
        gradient.cornerRadius = 5
        
        self.gradientLayer = gradient
        
        gradientContainerView.layer.insertSublayer(gradient, at: 0)
    }
}
