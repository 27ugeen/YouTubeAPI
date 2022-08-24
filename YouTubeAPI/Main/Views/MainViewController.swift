//
//  MainViewController.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: - props
    private let bannerCellId = BannerTableViewCell.cellId
    private let plMidCellId = PlaylistTableViewCell.cellId
    private let plBotCellId = PlaylistTableViewCell.cellId
    
    private let mainVM: MainViewModel
    private let playerVM: PlayerViewModel
    
    private var pageIdx: Int?
    
    private var channels: [ChannelItemsStub]? {
        didSet { tableView.reloadData() }
    }
    
    private var playlistsMid: [PlaylistItemsStub]?
    
    private var playlistsBot: [PlaylistItemsStub]? {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - init
    init(viewModel: MainViewModel, playerVM: PlayerViewModel) {
        self.mainVM = viewModel
        self.playerVM = playerVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChannels()
        getPlaylists()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    //MARK: - subviews
    private lazy var botButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.backgroundColor = UIColor(rgb: 0xE9408D).cgColor
        btn.layer.cornerRadius = 20
        btn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btn.addTarget(self, action: #selector(botBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow_top")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - methods
    private func getPlaylists() {
        mainVM.getAllPlaylists(PlayListsId.avb.rawValue) { plMid in
            self.playlistsMid = plMid
            
            self.mainVM.getAllPlaylists(PlayListsId.vevo.rawValue) { plBot in
                self.playlistsBot = plBot
            }
        }
    }
    
    private func getChannels() {
        mainVM.getAllChannels() { data in
            self.channels = data
        }
    }
    
    private func configureNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.title = "YouTube API"
        navigationController.navigationBar.sizeToFit()
    }
    
    private func openPlayer() {
        self.navigationItem.title = "My Music"
        let plVC = PlayerViewController(playerVM: self.playerVM,
                                        playlistId: self.channels?[pageIdx ?? 0].playListId ?? "")
        plVC.changeTitleAction = {
            self.navigationItem.title = "YouTube API"
        }
        self.navigationController?.present(plVC, animated: true)
    }
    
    @objc func botBtnTapped() {
        print("botBtnTapped")
        self.openPlayer()
    }
}
//MARK: - setupViews
extension MainViewController {
    private func setupViews() {
        view.addSubview(botButton)
        
        view.addSubview(tableView)
        botButton.addSubview(arrowView)
        
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellId)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: plMidCellId)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: plBotCellId)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            botButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            botButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            botButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            botButton.heightAnchor.constraint(equalToConstant: 50),
            
            arrowView.centerXAnchor.constraint(equalTo: botButton.centerXAnchor),
            arrowView.centerYAnchor.constraint(equalTo: botButton.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 29),
            arrowView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bannerCell = tableView.dequeueReusableCell(withIdentifier: bannerCellId) as! BannerTableViewCell
        let plMidCell = tableView.dequeueReusableCell(withIdentifier: plMidCellId) as! PlaylistTableViewCell
        let plBotCell = tableView.dequeueReusableCell(withIdentifier: plBotCellId) as! PlaylistTableViewCell
        
        switch indexPath.row {
        case 0:
            bannerCell.model = self.channels
            bannerCell.goToPlayerAction = { idx in
                self.pageIdx = idx
                self.openPlayer()
            }
            return bannerCell
        case 1:
            plMidCell.selectionStyle = .none
            plMidCell.cPosition = .mid
            plMidCell.model = self.playlistsMid
            plMidCell.playlistTitleLabel.text = self.playlistsMid?[0].playlistTitle
            return plMidCell
        case 2:
            plBotCell.selectionStyle = .none
            plBotCell.cPosition = .bot
            plBotCell.model = self.playlistsBot
            plBotCell.playlistTitleLabel.text = self.playlistsBot?[0].playlistTitle
            return plBotCell
        default:
            return UITableViewCell()
        }
    }
}
//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 220
        case 1:
            return 184
        case 2:
            return 248
        default:
            return 0
        }
    }
}

