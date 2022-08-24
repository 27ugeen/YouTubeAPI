//
//  PlayerShowHideTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 22/8/2022.
//

import UIKit

class PlayerShowHideTableViewCell: UITableViewCell {
    // MARK: - props
    static let cellId = "PlayerShowHideTableViewCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor(rgb: 0xE9408D).cgColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow_bot")
        imageView.clipsToBounds = true
        return imageView
    }()
}
//MARK: - setupViews
extension PlayerShowHideTableViewCell {
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            arrowView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            arrowView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 29),
            arrowView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
