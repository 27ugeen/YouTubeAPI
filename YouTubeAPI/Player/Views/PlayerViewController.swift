//
//  PlayerViewController.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 21/8/2022.
//

import UIKit
import YouTubePlayer

class PlayerViewController: UIViewController {
    //MARK: - props
    private let playlistId: String
    private let playerVM: PlayerViewModel
    
    private var videoDuration: Double?
    private var videoIdx: Int = 0
    private var timer: Timer!
    
    var changeTitleAction: (() -> Void)?
    
    private var videos: [VideoItemsStub]? {
        didSet { view.reloadInputViews() }
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
        setTimer()
        addGradient()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
        self.changeTitleAction?()
    }
    //MARK: - subviews
    private lazy var topButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.backgroundColor = UIColor(rgb: 0xE9408D).cgColor
        //        btn.setBackgroundImage(UIImage(named: "arrow_bot"), for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btn.addTarget(self, action: #selector(topBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow_bot")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        slider.thumbRect(forBounds: CGRect(x: 0, y: 0, width: 3, height: 12), trackRect: CGRect(x: 0, y: 0, width: 2, height: 12), value: 0)
        slider.value = 0.5
        //TODO: - didn't find how to connect to library yet...
        slider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
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
    private func getVideoArr() {
        playerVM.getVideos(playlistId) { videoArr in
            self.videos = videoArr
            self.loadVideo(self.videos?[0].videoId ?? "")
        }
    }
    
    private func loadVideo(_ vId: String) {
        videoPlayer.playerVars = ["controls" : 0 as AnyObject,
                                  "showinfo" : 0 as AnyObject,
                                  "playsinline" : 1 as AnyObject]
        videoPlayer.loadVideoID(vId)
        self.setupLabels()
    }
    
    private func playVideo() {
        videoPlayer.play()
    }
    
    private func setTimer() {
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
    
    private func setupLabels() {
        titleVideoLabel.text = "\(self.videos?[videoIdx].videoTitle ?? "NIL")"
        viewsCountLabel.text = "\(self.videos?[videoIdx].viewsCount ?? "0") views"
    }
    
    private func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(rgb: 0xEE4289).cgColor, UIColor(rgb: 0x630BF5).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0.7)
        gradient.frame = view.bounds
        wrapperView.layer.addSublayer(gradient)
    }
    
    private func setupBtnsNextPrev() {
        self.trackSlider.value = 0
        if playPauseButton.currentBackgroundImage == UIImage(named: "play_p") {
            playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc private func getCurTime() {
        videoPlayer.getCurrentTime { t in
            if let time = t {
//                print("timer: \(Int(time))")
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
                        //print("TRACK: \(Int(restDur))")
                        //if Int(restDur) == 0 {
                        //  self.nextTapped()
                        //}
                    }
                }
            }
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
    
    @objc private func topBtnTapped() {
        print("top tap")
        self.dismiss(animated: true)
    }
    
    @objc private func playPauseTapped() {
        print("playPauseTapped")
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
    
    @objc private func prevTapped() {
        print("prevTapped")
        if self.videoIdx > 0 {
            self.videoIdx -= 1
        } else {
            self.videoIdx = (self.videos?.count ?? 1) - 1
        }
        self.loadVideo(self.videos?[videoIdx].videoId ?? "nil")
    }
    
    @objc private func nextTapped() {
        print("nextTapped")
        self.setupBtnsNextPrev()
        if self.videoIdx < (self.videos?.count ?? 1) - 1 {
            self.videoIdx += 1
        } else {
            self.videoIdx = 0
        }
        self.loadVideo(self.videos?[videoIdx].videoId ?? "nil")
    }
    
    @objc private func volumeChanged() {
        print("VS: \(volumeSlider.value)")
    }
}
//MARK: - setupViews
extension PlayerViewController {
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(topButton)
        topButton.addSubview(arrowView)
        
        view.addSubview(videoPlayer)
        videoPlayer.delegate = self
        
        view.addSubview(wrapperView)
        wrapperView.addSubview(trackSlider)
        wrapperView.addSubview(startTimeLabel)
        wrapperView.addSubview(endTimeLabel)
        wrapperView.addSubview(titleVideoLabel)
        wrapperView.addSubview(viewsCountLabel)
        wrapperView.addSubview(playPauseButton)
        wrapperView.addSubview(prevButton)
        wrapperView.addSubview(nextButton)
        wrapperView.addSubview(volumeSlider)
        wrapperView.addSubview(minVolView)
        wrapperView.addSubview(maxVolView)
        
        NSLayoutConstraint.activate([
            topButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topButton.heightAnchor.constraint(equalToConstant: 50),
            
            arrowView.centerXAnchor.constraint(equalTo: topButton.centerXAnchor),
            arrowView.centerYAnchor.constraint(equalTo: topButton.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 29),
            arrowView.heightAnchor.constraint(equalToConstant: 15),
            
            videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayer.topAnchor.constraint(equalTo: topButton.bottomAnchor),
            videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayer.heightAnchor.constraint(equalToConstant: 235),
            
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            wrapperView.topAnchor.constraint(equalTo: videoPlayer.bottomAnchor),
            
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trackSlider.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 15),
            trackSlider.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 24),
            trackSlider.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -24),
            trackSlider.heightAnchor.constraint(equalToConstant: 3),
            
            startTimeLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 12),
            startTimeLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 7),
            
            endTimeLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 7),
            endTimeLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -24),
            
            titleVideoLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 52.5),
            titleVideoLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 40),
            titleVideoLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -64.5),
            
            viewsCountLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            viewsCountLabel.topAnchor.constraint(equalTo: titleVideoLabel.bottomAnchor, constant: 9),
            
            prevButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 92),
            prevButton.topAnchor.constraint(equalTo: viewsCountLabel.bottomAnchor, constant: 46),
            prevButton.widthAnchor.constraint(equalToConstant: 31),
            prevButton.heightAnchor.constraint(equalToConstant: 20),
            
            playPauseButton.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: viewsCountLabel.bottomAnchor, constant: 41),
            playPauseButton.widthAnchor.constraint(equalToConstant: 24),
            playPauseButton.heightAnchor.constraint(equalToConstant: 30),
            
            nextButton.topAnchor.constraint(equalTo: viewsCountLabel.bottomAnchor, constant: 46),
            nextButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -92),
            nextButton.widthAnchor.constraint(equalToConstant: 31),
            nextButton.heightAnchor.constraint(equalToConstant: 20),
            
            minVolView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 17),
            minVolView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 52),
            minVolView.widthAnchor.constraint(equalToConstant: 7),
            minVolView.heightAnchor.constraint(equalToConstant: 11),
            
            maxVolView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 50),
            maxVolView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -28),
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
extension PlayerViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.getDuration()
        self.playVideo()
    }
}
