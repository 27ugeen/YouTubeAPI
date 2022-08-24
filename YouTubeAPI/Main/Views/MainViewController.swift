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
    private let btnBotCellId = PlayerShowHideTableViewCell.cellId
    
    private let mainVM: MainViewModel
    private let playerVM: PlayerViewModel
    
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

        setupViews()
        
        getChannels()
        getPlaylists()
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
}
//MARK: - setupViews
extension MainViewController {
    private func setupViews() {
        overrideUserInterfaceStyle = .dark
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(tableView)
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: titleCellId)
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellId)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: plMidCellId)
        tableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: plBotCellId)
        tableView.register(PlayerShowHideTableViewCell.self, forCellReuseIdentifier: btnBotCellId)

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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: titleCellId) as! TitleTableViewCell
        let bannerCell = tableView.dequeueReusableCell(withIdentifier: bannerCellId) as! BannerTableViewCell
        let plMidCell = tableView.dequeueReusableCell(withIdentifier: plMidCellId) as! PlaylistTableViewCell
        let plBotCell = tableView.dequeueReusableCell(withIdentifier: plBotCellId) as! PlaylistTableViewCell
        let btnBotCell = tableView.dequeueReusableCell(withIdentifier: btnBotCellId) as! PlayerShowHideTableViewCell
        
        switch indexPath.row {
        case 0:
            return titleCell
        case 1:
            bannerCell.model = self.channels
            bannerCell.goToPlayerAction = { idx in

                let plVC = PlayerViewController(playerVM: self.playerVM,
                                                playlistId: self.channels?[idx].playListId ?? "")
                self.navigationController?.present(plVC, animated: true)
            }
            return bannerCell
        case 2:
            plMidCell.selectionStyle = .none
            plMidCell.cPosition = .mid
            plMidCell.model = self.playlistsMid
            plMidCell.playlistTitleLabel.text = self.playlistsMid?[0].playlistTitle
            return plMidCell
        case 3:
            plBotCell.selectionStyle = .none
            plBotCell.cPosition = .bot
            plBotCell.model = self.playlistsBot
            plBotCell.playlistTitleLabel.text = self.playlistsBot?[0].playlistTitle
            return plBotCell
        case 4:
            btnBotCell.arrowView.image = UIImage(named: "arrow_top")
            btnBotCell.selectionStyle = .none
            return btnBotCell
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
            return 48
        case 1:
            return 220
        case 2:
            return 184
        case 3:
            return 248
        case 4:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            print("tap Banner")
//            let plVC = PlayerViewController()
//            self.navigationController?.present(plVC, animated: true)
        default:
            break
        }
    }
}

