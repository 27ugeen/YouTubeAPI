//
//  BannerTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    //MARK: - props
    static let cellId = "BannerTableViewCell"
    private let bannerItemId = BannerCollectionViewCell.itemId
    
    var model: [ChannelItemsStub]? {
        didSet { carouselCollectionView.reloadData() }
    }
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            carouselCollectionView.reloadData()
        }
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
    private lazy var carouselCollectionView: UICollectionView = {
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.sectionInset = .zero
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: carouselLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    //MARK: - methods
    private func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
    }
    
    @objc private func autoScroll() {
//        print("timer fire!")
        //TODO: - looks like pice of shit... need fix logic or remove to mainVC
        for cell in carouselCollectionView.visibleCells {
            let cIndexPath: IndexPath? = carouselCollectionView.indexPath(for: cell)
            if ((cIndexPath?.row)! < (model?.count ?? 1) - 1){
                let nIndexPath: IndexPath?
                nIndexPath = IndexPath.init(row: (cIndexPath?.row)! + 1, section: (cIndexPath?.section)!)
                
                carouselCollectionView.scrollToItem(at: nIndexPath!, at: .right, animated: true)
            } else {
                let nIndexPath: IndexPath?
                nIndexPath = IndexPath.init(row: 0, section: (cIndexPath?.section)!)
                carouselCollectionView.scrollToItem(at: nIndexPath!, at: .left, animated: true)
            }
            
        }
    }
}
//MARK: - setupViews
extension BannerTableViewCell {
    private func setupViews() {
        contentView.backgroundColor = .black
        contentView.addSubview(carouselCollectionView)
        
        carouselCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: bannerItemId)
        
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            carouselCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carouselCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carouselCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 5),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
//MARK: - UICollectionViewDataSource
extension BannerTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = model?.count ?? 1
        return model?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerItemId, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.chNameLabel.text = model?[indexPath.item].channelTittle ?? "Title channel"
        cell.subscribersLabel.text = "\(model?[indexPath.item].subscribers ?? "0") subscribers"
        
        return cell
    }
}
//MARK: - UICollectionViewDelegate

extension BannerTableViewCell: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension BannerTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width - 32
        return CGSize(width: collectionWidth, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellPadding = (collectionView.frame.width - (collectionView.frame.width - 32)) / 2
        return UIEdgeInsets(top: 17, left: cellPadding, bottom: 0, right: cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width - (collectionView.frame.width - 32)
    }
}
