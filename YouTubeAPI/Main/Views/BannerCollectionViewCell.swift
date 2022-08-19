//
//  BannerCollectionViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let itemId = "BannerCollectionViewCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - subviews
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bannerImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.backgroundColor = .white
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var playImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var chNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.text = "Eminem Music"
        textLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        textLabel.textColor = UIColor(rgb: 0x383838)
        return textLabel
    }()
    
    lazy var subscribersLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.text = "42424242 subscribers"
        textLabel.font = .systemFont(ofSize: 10, weight: .regular)
        textLabel.textColor = UIColor(rgb: 0x9D9D9D)
        return textLabel
    }()
}
//MARK: - setupViews
extension BannerCollectionViewCell {
    func setupViews() {
        contentView.addSubview(wrapperView)
        
        wrapperView.addSubview(bannerImgView)
        wrapperView.addSubview(playImgView)
        wrapperView.addSubview(chNameLabel)
        wrapperView.addSubview(subscribersLabel)
        
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            wrapperView.heightAnchor.constraint(equalToConstant: 152),
            
            bannerImgView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            bannerImgView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            bannerImgView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            bannerImgView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            
            playImgView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16),
            playImgView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 16),
            playImgView.widthAnchor.constraint(equalToConstant: 50),
            playImgView.heightAnchor.constraint(equalTo: playImgView.widthAnchor),
            
            chNameLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 10),
            chNameLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -32),
            
            subscribersLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 10),
            subscribersLabel.topAnchor.constraint(equalTo: chNameLabel.bottomAnchor, constant: 4)
        ])
    }
}
