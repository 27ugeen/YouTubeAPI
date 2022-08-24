//
//  PlayerViewController.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 21/8/2022.
//

import UIKit

class PlayerViewController: UIViewController {
    //MARK: - props
    private let topBtnCell = PlayerShowHideTableViewCell.cellId
    private let videoCellId = PlayerVideoTableViewCell.cellId
    
    private let playlistId: String
    private let playerVM: PlayerViewModel
    
    var videoIdx: Int = 0 {
        didSet { tableView.reloadData() }
    }
    
    private var videos: [VideoItemsStub]? {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - init
    init(playerVM: PlayerViewModel, playlistId: String) {
        self.playerVM = playerVM
        self.playlistId = playlistId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideoArr()
        addGradient()
        setupViews()
    }
    //MARK: - subviews
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        //        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor(rgb: 0xE9408D).cgColor
        //        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - methods
    private func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(rgb: 0xEE4289).cgColor, UIColor(rgb: 0x630BF5).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.bounds
        tableView.backgroundColor = .clear
        wrapperView.layer.addSublayer(gradient)
    }
    
    private func getVideoArr() {
        playerVM.getVideos(playlistId) { videoArr in
            self.videos = videoArr
        }
    }
    
    private func playNextVideo() {
        if self.videoIdx < (self.videos?.count ?? 1) - 1 {
            self.videoIdx += 1
        } else {
            self.videoIdx = 0
        }
    }
    
    private func playPrevVideo() {
        if self.videoIdx > 0 {
            self.videoIdx -= 1
        } else {
            self.videoIdx = (self.videos?.count ?? 1) - 1
        }
    }
}
//MARK: - setupViews
extension PlayerViewController {
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        tableView.register(PlayerShowHideTableViewCell.self, forCellReuseIdentifier: topBtnCell)
        tableView.register(PlayerVideoTableViewCell.self, forCellReuseIdentifier: videoCellId)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapperView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
        ])
    }
}
//MARK: - UITableViewDataSource
extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let topBtnCell = tableView.dequeueReusableCell(withIdentifier: topBtnCell) as! PlayerShowHideTableViewCell
            topBtnCell.backgroundColor = .black
            topBtnCell.selectionStyle = .none
            return topBtnCell
        case 1:
            let videoCell = tableView.dequeueReusableCell(withIdentifier: videoCellId) as! PlayerVideoTableViewCell
            
            let v = self.videos?[self.videoIdx]
            
            videoCell.loadVideo(v?.videoId ?? "nil")
            videoCell.titleVideoLabel.text = "\(v?.videoTitle ?? "nil")"
            videoCell.viewsCountLabel.text = "\(v?.viewsCount ?? "nil") views"
            videoCell.nextVideoAction = {
                self.playNextVideo()
            }
            videoCell.prevVideoAction = {
                self.playPrevVideo()
            }
            videoCell.backgroundColor = .clear
            videoCell.selectionStyle = .none
            return videoCell
        default:
            return UITableViewCell()
        }
    }
}
//MARK: - UITableViewDelegate
extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        case 1:
            //TODO: - need to fix it!
            return UIScreen.main.bounds.height - 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("tap pl")
            self.navigationController?.dismiss(animated: true)
        }
    }
}
