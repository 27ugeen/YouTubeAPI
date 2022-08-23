//
//  PlayerControlTableViewCell.swift
//  YouTubeAPI
//
//  Created by GiN Eugene on 22/8/2022.
//

import UIKit

class PlayerControlTableViewCell: UITableViewCell {
    // MARK: - props
    static let cellId = "PlayerControlTableViewCell"
    
    var playPauseAction: (() -> Void)?
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor.red.cgColor, UIColor.systemPink.cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = CGPoint(x: 0, y: 0.15)
//        gradient.frame = bounds
//
//        layer.addSublayer(gradient)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
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
        btn.setBackgroundImage(UIImage(named: "play_p"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var prevButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "prev"), for: .normal)
        btn.tintColor = .white
//        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "next"), for: .normal)
        btn.tintColor = .white
//        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
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
    @objc private func playPauseTapped() {
        print("tap1")
        self.playPauseAction?()
    }
    
    
}
//MARK: - setupViews
extension PlayerControlTableViewCell {
    private func setupViews() {
//        contentView.backgroundColor = UIColor(rgb: 0xE9408D)
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

        NSLayoutConstraint.activate([
            trackSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            trackSlider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
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


//@IBDesignable open class DesignableSlider: UISlider {
//
//    @IBInspectable var trackHeight: CGFloat = 3
//
//    @IBInspectable var roundImage: UIImage? {
//        didSet{
//            setThumbImage(roundImage, for: .normal)
//        }
//    }
//    @IBInspectable var roundHighlightedImage: UIImage? {
//        didSet{
//            setThumbImage(roundHighlightedImage, for: .highlighted)
//        }
//    }
//    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
//        //set your bounds here
//        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
//    }
//}

