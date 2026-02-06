//
//  ActorCollectionViewCell.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - ActorCollectionViewCell
class ActorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Hacer la imagen circular después de que se establezca el frame
        profileImageView.makeCircular()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // Profile Image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray5
        profileImageView.clipsToBounds = true
        
        // Name Label
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(with actor: Actor) {
        nameLabel.text = actor.name
        
        if let profileURL = actor.profileURL {
            profileImageView.loadImage(from: profileURL)
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .systemGray4
        }
    }
}
