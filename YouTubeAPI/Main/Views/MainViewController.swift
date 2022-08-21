//
//  MainViewController.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 19/8/2022.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: - props
    private let titleCellId = TitleTableViewCell.cellId
    private let bannerCellId = BannerTableViewCell.cellId
    private let plMidCellId = PlaylistTableViewCell.cellId
    private let plBotCellId = PlaylistTableViewCell.cellId
    
    private let mainVM: MainViewModel
    
    private var channels: [ChannelItemsStub]? {
        didSet { tableView.reloadData() }
    }
    
    private var playlists: [PlaylistItemsStub]? {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - init
    init(viewModel: MainViewModel) {
        self.mainVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        overrideUserInterfaceStyle = .dark
        
        setupViews()
        
        getChannels()
        getPlaylist()
    }
    //MARK: - subviews
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - methods
    private func getPlaylist() {
        mainVM.getAllPlaylists(PlayListsId.vevo.rawValue) { pl in
            self.playlists = pl
        }
    }
    
    private func getChannels() {
        mainVM.getAllChannels() { data in
            self.channels = data
        }
    }
}
//MARK: - setupViews
extension MainViewController {
    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: titleCellId)
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellId)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: plMidCellId)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: plBotCellId)

        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: titleCellId) as! TitleTableViewCell
        let bannerCell = tableView.dequeueReusableCell(withIdentifier: bannerCellId) as! BannerTableViewCell
        let plMidCell = tableView.dequeueReusableCell(withIdentifier: plMidCellId) as! PlaylistTableViewCell
        let plBotCell = tableView.dequeueReusableCell(withIdentifier: plBotCellId) as! PlaylistTableViewCell
        
        switch indexPath.row {
        case 0:
            return titleCell
        case 1:
            bannerCell.model = self.channels
            return bannerCell
        case 2:
            plMidCell.selectionStyle = .none
            plMidCell.cPosition = .mid
            plMidCell.model = self.playlists
            plMidCell.playlistTitleLabel.text = self.playlists?[0].playlistTitle
            return plMidCell
        case 3:
            plBotCell.selectionStyle = .none
            plBotCell.cPosition = .bot
            plBotCell.model = self.playlists
            plBotCell.playlistTitleLabel.text = self.playlists?[0].playlistTitle
            return plBotCell
        default:
            return bannerCell
        }
    }
}
//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 42
        case 1:
            return 200
        case 2:
            return 184
        case 3:
            return 248
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row > 2 {
//            self.goToDailyDetailAction?(indexPath.row - 3)
//        }
//    }
}

