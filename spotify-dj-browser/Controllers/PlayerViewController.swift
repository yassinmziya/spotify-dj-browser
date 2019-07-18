//
//  PlayerViewController.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/8/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    
    var dismissPlayerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "downward-chevron"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var albumArtImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.darkGray
        return imgView
    }()
    
    var trackNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Track Name"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    var keyLabel: UILabel = {
        let label = UILabel()
        label.text = "D"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    var tempoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "128 BPM"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var playbackProgressView: PlaybackProgressView = {
        return PlaybackProgressView()
    }()
    
    var playPauseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "pause-icon"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    var skipButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "skip-icon"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    var prevButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prev-icon"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleViewPan)))
        view.isUserInteractionEnabled = true
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(dismissPlayerButton)
        dismissPlayerButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        view.addSubview(albumArtImageView)
        view.addSubview(trackNameLabel)
        view.addSubview(keyLabel)
        view.addSubview(tempoLabel)
        view.addSubview(playPauseButton)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        
        view.addSubview(playbackProgressView)
        view.addSubview(playPauseButton)
        
        view.addSubview(prevButton)
        prevButton.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
        view.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skipTrack), for: .touchUpInside)
        
        setupConstraints()
        setupPlayerObservers()
        updatePlayer(notification: nil)
    }
    

    func setupConstraints() {
        albumArtImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(view.snp.width).multipliedBy(0.75)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(75)
        }
        
        keyLabel.snp.makeConstraints { make in
            make.top.equalTo(albumArtImageView.snp.bottom).offset(24)
            make.height.width.equalTo(keyLabel.intrinsicContentSize.height + 30)
            make.height.equalTo(keyLabel.intrinsicContentSize.height)
            make.trailing.equalTo(albumArtImageView).offset(9)
        }
        
        tempoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(keyLabel)
            make.top.equalTo(keyLabel.snp.bottom).offset(4)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumArtImageView).offset(-9)
            make.trailing.equalTo(keyLabel.snp.leading).offset(-4)
            make.top.equalTo(keyLabel)
        }
        
        playbackProgressView.snp.makeConstraints { make in
            make.leading.equalTo(trackNameLabel)
            make.trailing.equalTo(keyLabel)
            make.top.equalTo(tempoLabel.snp.bottom).offset(16)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.centerX.equalTo(playbackProgressView)
            make.top.equalTo(playbackProgressView.snp.bottom).offset(32)
            make.height.width.equalTo(64)
        }
        
        prevButton.snp.makeConstraints { make in
            make.trailing.equalTo(playPauseButton.snp.leading).offset(-16)
            make.centerY.equalTo(playPauseButton)
            make.height.width.equalTo(playPauseButton).multipliedBy(0.8)
        }
        
        skipButton.snp.makeConstraints { make in
            make.leading.equalTo(playPauseButton.snp.trailing).offset(16)
            make.centerY.height.width.equalTo(prevButton)
        }
        
        dismissPlayerButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.width.equalTo(28)
            make.leading.equalTo(trackNameLabel).offset(-8)
        }
    }
    
    func setupPlayerObservers() {
        // print("[PLAYER] Notification received")
        let notificationName = NSNotification.Name(PLAYER_STATE_UPDATE_NOTIFICATION)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayer), name: notificationName, object: nil)
    }
    
    @objc func updatePlayer(notification: NSNotification?) {
        if let playerState = Player.shared.playerState {
            let track = playerState.track
            
            let dimensions = CGSize(width: albumArtImageView.frame.width * 3, height: albumArtImageView.frame.width * 3)
            Networking.shared.getImage(item: track, dimensions: dimensions) { image in
                DispatchQueue.main.async {
                    self.albumArtImageView.image = image
                }
            }
            trackNameLabel.text = track.name
            keyLabel.text = Int.intToKey(value: Player.shared.audioFeatures!.key)
            var tempo = Player.shared.audioFeatures!.tempo
            tempo = Float(round(10*tempo)/10)
            tempoLabel.text = "\(tempo) BPM"
            
            let btnImg = UIImage(named: playerState.isPaused ? "play-icon" : "pause-icon")
            playPauseButton.setImage(btnImg, for: .normal)
        }
    }
    
    @objc func handleViewPan(recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            return
        }
        var translation = recognizer.translation(in: view.superview)
        recognizerView.transform = recognizerView.transform.translatedBy(x: 0, y: translation.y)
        recognizer.setTranslation(.zero, in: recognizerView)
        
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func playPauseButtonTapped() {
        Player.shared.pauseResumeTrack()
    }
    
    @objc func skipTrack() {
        Player.shared.skipTrack()
    }
    
    @objc func previousTrack() {
        Player.shared.prevTrack()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
