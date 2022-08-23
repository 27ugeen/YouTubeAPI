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
//    private let controlCellId = PlayerControlTableViewCell.cellId

    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(rgb: 0xEE4289).cgColor, UIColor(rgb: 0x630BF5).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = view.bounds
        
        wrapperView.layer.addSublayer(gradient)
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.backgroundColor = .clear
        
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
//    private lazy var wrapperView: WKWebView = {
//        let view = WKWebView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue
//        view.scrollView.isScrollEnabled = false
//
//        return view
//    }()
    
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor(rgb: 0xE9408D).cgColor
//        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        return button
    }()
    
//    private lazy var arrowView: UIImageView = 
    

    

//    private lazy var bottomView: WKWebView = {
//        let view = WKWebView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue
//        view.clipsToBounds = true
//        view.scrollView.isScrollEnabled = false
//
//        return view
//    }()
    


}
//MARK: - setupViews
extension PlayerViewController {
    private func setupViews() {
        view.addSubview(wrapperView)
        wrapperView.addSubview(tableView)
        
        tableView.register(PlayerShowHideTableViewCell.self, forCellReuseIdentifier: topBtnCell)
        tableView.register(PlayerVideoTableViewCell.self, forCellReuseIdentifier: videoCellId)
//        tableView.register(PlayerControlTableViewCell.self, forCellReuseIdentifier: controlCellId)

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
        
        
//        let controlCell = tableView.dequeueReusableCell(withIdentifier: controlCellId) as! PlayerControlTableViewCell
        
        switch indexPath.row {
        case 0:
            let topBtnCell = tableView.dequeueReusableCell(withIdentifier: topBtnCell) as! PlayerShowHideTableViewCell
            topBtnCell.backgroundColor = .black
            return topBtnCell
        case 1:
            let videoCell = tableView.dequeueReusableCell(withIdentifier: videoCellId) as! PlayerVideoTableViewCell
            videoCell.backgroundColor = .clear
            videoCell.selectionStyle = .none
            return videoCell
//        case 2:
//            controlCell.backgroundColor = .clear
//            controlCell.selectionStyle = .none
////            controlCell.playPauseAction = {
////                videoCell.playerPause()
////            }
//            return controlCell
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
            //TODO: - fix it!
            return UIScreen.main.bounds.height - 50
//            return 300
//        case 2:
//            //TODO: - fix it!!!
//            return UIScreen.main.bounds.height - 285
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
