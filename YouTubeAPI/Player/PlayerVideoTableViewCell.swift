//
//  PlayerVideoTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 22/8/2022.
//

import UIKit
//import youtube_ios_player_helper
import YouTubePlayer

class PlayerVideoTableViewCell: UITableViewCell {
    // MARK: - props
    static let cellId = "PlayerVideoTableViewCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    private lazy var videoPlayer: YouTubePlayerView = {
        let view = YouTubePlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private lazy var playPauseButton: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setBackgroundImage(UIImage(named: "play_p"), for: .normal)
//        btn.tintColor = .white
//        btn.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
//        return btn
//    }()
    
    private lazy var trackSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.trackRect(forBounds: CGRect(origin: bounds.origin, size: CGSize(width: 3, height: 3)))
        slider.layer.cornerRadius = 4
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.65)
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        
        return slider
    }()
    
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    private lazy var titleVideoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title Vodeo Name Long Text Label in One Line"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "42424242 views"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var playPauseButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var prevButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "prev"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "next"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.layer.cornerRadius = 4
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.65)
        slider.thumbRect(forBounds: CGRect(x: 0, y: 0, width: 2, height: 12), trackRect: CGRect(x: 0, y: 0, width: 2, height: 12), value: 0)
        
        
        return slider
    }()
    
    private lazy var minVolView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "vol_min")
        
        return view
    }()
    
    private lazy var maxVolView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "vol_max")
        
        return view
    }()
    
    //MARK: - methods
//    @objc private func btnTapped() {
//        playerView.pauseVideo()
//    }
    
    private func loadVideo() {
        //TODO: - hide controls
//        var playerVars = YouTubePlayerView.YouTubePlayerParameters.self
//        let playerVars: [String:AnyObject] = ["showinfo" : 0 as AnyObject]
        videoPlayer.play()
    }
    
    @objc private func playPauseTapped() {
        print("tap2")
        if videoPlayer.ready {
            if videoPlayer.playerState != .Playing {
                playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                videoPlayer.play()
            } else {
                videoPlayer.pause()
                playPauseButton.setBackgroundImage(UIImage(named: "play_p"), for: .normal)
            }
        }
    }
    
    @objc private func nextTapped() {
        print("next video")
        videoPlayer.nextVideo()
    }
    
    @objc private func prevTapped() {
        print("prev video")
        videoPlayer.previousVideo()
    }

}
//MARK: - setupViews
extension PlayerVideoTableViewCell {
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(videoPlayer)
        contentView.addSubview(trackSlider)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(endTimeLabel)
        contentView.addSubview(titleVideoLabel)
        contentView.addSubview(viewsCountLabel)
        contentView.addSubview(playPauseButton)
        contentView.addSubview(prevButton)
        contentView.addSubview(nextButton)
        contentView.addSubview(volumeSlider)
        contentView.addSubview(minVolView)
        contentView.addSubview(maxVolView)
        
        videoPlayer.playerVars = ["controls" : 0 as AnyObject, "showinfo" : 0 as AnyObject, "playsinline" : 1 as AnyObject]
//        videoPlayer.loadVideoID("x31vGxoI7go")
        videoPlayer.loadPlaylistID("UUu5jfQcpRLm9xhmlSd5S8xw")
        
//        playerView.load(withVideoId: "x31vGxoI7go", playerVars: ["controls" : 0, "showinfo" : 0, "playsinline" : 1, "autohide" : 1])
        videoPlayer.delegate = self
        
        NSLayoutConstraint.activate([
            
            videoPlayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoPlayer.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoPlayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            videoPlayer.heightAnchor.constraint(equalToConstant: 235),
            
            trackSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            trackSlider.topAnchor.constraint(equalTo: videoPlayer.bottomAnchor, constant: 24),
            trackSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            trackSlider.heightAnchor.constraint(equalToConstant: 3),

            startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            startTimeLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 7),

            endTimeLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 7),
            endTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            titleVideoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52.5),
            titleVideoLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 40),
            titleVideoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -64.5),

            viewsCountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            viewsCountLabel.topAnchor.constraint(equalTo: titleVideoLabel.bottomAnchor, constant: 9),

            prevButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 92),
            prevButton.topAnchor.constraint(equalTo: viewsCountLabel.bottomAnchor, constant: 46),
            prevButton.widthAnchor.constraint(equalToConstant: 31),
            prevButton.heightAnchor.constraint(equalToConstant: 20),

            playPauseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: viewsCountLabel.bottomAnchor, constant: 41),
            playPauseButton.widthAnchor.constraint(equalToConstant: 24),
            playPauseButton.heightAnchor.constraint(equalToConstant: 30),

            nextButton.topAnchor.constraint(equalTo: viewsCountLabel.bottomAnchor, constant: 46),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -92),
            nextButton.widthAnchor.constraint(equalToConstant: 31),
            nextButton.heightAnchor.constraint(equalToConstant: 20),

            minVolView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            minVolView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 52),
            minVolView.widthAnchor.constraint(equalToConstant: 7),
            minVolView.heightAnchor.constraint(equalToConstant: 11),

            maxVolView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 50),
            maxVolView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            maxVolView.widthAnchor.constraint(equalToConstant: 17),
            maxVolView.heightAnchor.constraint(equalToConstant: 15),

            volumeSlider.leadingAnchor.constraint(equalTo: minVolView.trailingAnchor, constant: 15),
            volumeSlider.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 56),
            volumeSlider.trailingAnchor.constraint(equalTo: maxVolView.leadingAnchor, constant: -10),
            volumeSlider.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
}
//MARK: -
extension PlayerVideoTableViewCell: YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {

        
        self.loadVideo()
    }
    
//    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
//        <#code#>
//    }
    
//    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
//        <#code#>
//    }
    
}
