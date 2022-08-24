//
//  PlayerVideoTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 22/8/2022.
//

import UIKit
import YouTubePlayer

class PlayerVideoTableViewCell: UITableViewCell {
    // MARK: - props
    static let cellId = "PlayerVideoTableViewCell"
    
    var videoDuration: Double?
    
    var nextVideoAction: (() -> Void)?
    var prevVideoAction: (() -> Void)?

    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setTimer()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        timer.invalidate()
//    }
    //MARK: - subviews
    private lazy var videoPlayer: YouTubePlayerView = {
        let view = YouTubePlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trackSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        //TODO: - set slider height
        //        slider.trackRect(forBounds: CGRect(origin: bounds.origin, size: CGSize(width: 3, height: 3)))
        slider.layer.cornerRadius = 4
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.65)
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(trackSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 11, weight: .regular)
        return label
    }()
    
    lazy var titleVideoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title Vodeo Name Long Text Label in One Line"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var viewsCountLabel: UILabel = {
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
        slider.value = 0.5
        //TODO: - didn't find how to connect to library yet...
        //        slider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
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
    func loadVideo(_ vId: String) {
        videoPlayer.playerVars = ["controls" : 0 as AnyObject,
                                  "showinfo" : 0 as AnyObject,
                                  "playsinline" : 1 as AnyObject]
        videoPlayer.loadVideoID(vId)
    }
    
    private func playVideo() {
        videoPlayer.play()
    }
    
    private func setTimer() {
        var timer: Timer!
        if timer != nil { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getCurTime), userInfo: nil, repeats: true)
    }
    
    private func getDuration() {
        videoPlayer.getDuration { dur in
            if let duration = dur {
                self.videoDuration = duration
                let secText = String(format: "%02d", Int(duration) % 60)
                let minText = String(format: "%02d", Int(duration) / 60)
                print(duration)
                self.endTimeLabel.text = "\(minText):\(secText)"
            }
        }
    }
    
    private func setupBtnsNextPrev() {
        self.trackSlider.value = 0
        self.setTimer()
        self.getDuration()
        if playPauseButton.currentBackgroundImage == UIImage(named: "play_p") {
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc private func trackSliderChange() {
        if self.videoDuration != nil {
            if let cDurration = self.videoDuration {
                let totalSec = cDurration
                let value = self.trackSlider.value * Float(totalSec)
                self.videoPlayer.seekTo(value, seekAhead: true)
            }
        }
    }
    
    @objc private func getCurTime() {
        videoPlayer.getCurrentTime { t in
//            print("timer: \(t)")
            if let time = t {
                let secText = String(format: "%02d", Int(time) % 60)
                let minText = String(format: "%02d", Int(time) / 60)
                self.startTimeLabel.text = "\(minText):\(secText)"
                if self.videoDuration != nil {
                    if let cDur = self.videoDuration {
                        self.trackSlider.value = Float(time / cDur)
                        let restDur = cDur - time
                        let sec = String(format: "%02d", Int(restDur) % 60)
                        let min = String(format: "%02d", Int(restDur) / 60)
                        self.endTimeLabel.text = "-\(min):\(sec)"
                        //TODO: - need review taking duration of video
//                        print("TRACK: \(Int(restDur))")
//                        if Int(restDur) == 0 {
//                            self.nextTapped()
//                        }
                    }
                }
            }
        }
    }
    
    @objc private func playPauseTapped() {
        if videoPlayer.ready {
            if videoPlayer.playerState != .Playing {
                playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
                self.videoPlayer.play()
            } else {
                self.videoPlayer.pause()
                playPauseButton.setBackgroundImage(UIImage(named: "play_p"), for: .normal)
            }
        }
    }
    
    @objc private func nextTapped() {
        self.setupBtnsNextPrev()
        self.nextVideoAction?()
    }
    
    @objc private func prevTapped() {
        self.setupBtnsNextPrev()
        self.prevVideoAction?()
    }
    
    @objc private func volumeChanged() {
        print("VS: \(volumeSlider.value)")
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
//MARK: - YouTubePlayerDelegate
extension PlayerVideoTableViewCell: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.getDuration()
        self.playVideo()
    }
}
