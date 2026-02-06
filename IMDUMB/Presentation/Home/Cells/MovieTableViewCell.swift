//
//  MovieTableViewCell.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - MovieTableViewCell
class MovieTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.backgroundColor = .secondarySystemBackground
        containerView.roundCorners(radius: 12)
        containerView.addShadow(opacity: 0.1, radius: 4, offset: CGSize(width: 0, height: 2))
        
        // Poster
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.roundCorners(radius: 8)
        posterImageView.backgroundColor = .systemGray5
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        
        // Rating
        ratingLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        ratingLabel.textColor = .systemYellow
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.rating))"
        
        // Cargar imagen de forma asíncrona
        posterImageView.loadImage(from: movie.posterURL)
    }
}
