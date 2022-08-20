//
//  TitleTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    //MARK: - props
    static let cellId = "TitleTableViewCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "YouTube API"
        label.textColor = .white
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
}
//MARK: - setupViews
extension TitleTableViewCell {
    private func setupViews() {
        contentView.backgroundColor = .black
        contentView.addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
