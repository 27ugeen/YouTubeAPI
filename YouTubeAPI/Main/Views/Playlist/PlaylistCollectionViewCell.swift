//
//  PlayListMidCollectionViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 20/8/2022.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    // MARK: - props
    static let itemId = "PlaylistCollectionViewCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - subviews
    lazy var playlistImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = .white
        
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var videoNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 1
        textLabel.text = "Meteora"
        textLabel.font = .systemFont(ofSize: 17, weight: .medium)
        textLabel.textColor = .white
        return textLabel
    }()
    
    lazy var viewsCountLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.text = "42424242 views"
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = UIColor(rgb: 0x9D9D9D)
        return textLabel
    }()
}
//MARK: - setupViews
extension PlaylistCollectionViewCell {
    func setupViews() {
        contentView.addSubview(playlistImgView)
        contentView.addSubview(videoNameLabel)
        contentView.addSubview(viewsCountLabel)
        
        NSLayoutConstraint.activate([
            playlistImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistImgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
//            playlistImgView.widthAnchor.constraint(equalToConstant: 160),
//            playlistImgView.heightAnchor.constraint(equalToConstant: 70),
            
            videoNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoNameLabel.topAnchor.constraint(equalTo: playlistImgView.bottomAnchor, constant: 9),
            
            videoNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            viewsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewsCountLabel.topAnchor.constraint(equalTo: videoNameLabel.bottomAnchor, constant: 4),
            viewsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
