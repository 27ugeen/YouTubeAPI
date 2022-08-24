//
//  PlayListMidTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 20/8/2022.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    //MARK: - props
    static let cellId = "PlaylistTableViewCell"
    private let plItemId = PlaylistCollectionViewCell.itemId
    
    enum Position {
        case mid, bot
    }
    
    var cPosition: Position?
    
    var model: [PlaylistItemsStub]? {
        didSet { playlistCollectionView.reloadData() }
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    lazy var playlistTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Playlist Name"
        label.textColor = .white
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var playlistCollectionView: UICollectionView = {
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        
        collection.backgroundColor = .clear
        
        collection.isPagingEnabled = true
        
        return collection
    }()
    
}
//MARK: - setupViews
extension PlaylistTableViewCell {
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(playlistTitleLabel)
        contentView.addSubview(playlistCollectionView)
        
        playlistCollectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: plItemId)
        
        playlistCollectionView.dataSource = self
        playlistCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            playlistTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            playlistTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            playlistCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            playlistCollectionView.topAnchor.constraint(equalTo: playlistTitleLabel.bottomAnchor, constant: 19),
            playlistCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playlistCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
//MARK: - UICollectionViewDataSource
extension PlaylistTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: plItemId, for: indexPath) as? PlaylistCollectionViewCell else { return UICollectionViewCell() }
        
        let m = model?[indexPath.item]
        
        cell.playlistImgView.image = m?.playlistImg
        cell.videoNameLabel.text = m?.videoTitle
        
        let position: Position = cPosition ?? .mid
        switch position {
        case .mid:
            cell.viewsCountLabel.text = "\(m?.viewsCount ?? "nil") views"
            cell.playlistImgView.widthAnchor.constraint(equalToConstant: 160).isActive = true
            cell.playlistImgView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        case .bot:
            //TODO: - review contentMode
            cell.playlistImgView.contentMode = .center
            cell.viewsCountLabel.text = "\(m?.viewsCount ?? "nil") views"
            cell.playlistImgView.widthAnchor.constraint(equalToConstant: 135).isActive = true
            cell.playlistImgView.heightAnchor.constraint(equalToConstant: 134).isActive = true
        }
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension PlaylistTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let position: Position = cPosition ?? .mid
        switch position {
        case .mid:
            return CGSize(width: 160, height: 117)
        case .bot:
            return CGSize(width: 135, height: 181)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
