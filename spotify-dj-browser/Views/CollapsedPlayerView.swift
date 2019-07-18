//
//  CollapsedPlayerView.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/6/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class CollapsedPlayerView: UIView {

    static let PLAYER_HEIGHT = 48
    
    var progressBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var currentSongLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var playPauseButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(progressBarView)
        addSubview(currentSongLabel)
        addSubview(playPauseButton)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        if let state = Player.shared.playerState {
            currentSongLabel.attributedText = createPlayerText(track: state.track)
            playPauseButton.setImage(UIImage(named: (state.isPaused ? "play-icon" : "pause-icon")), for: .normal)
        }
        
        setupPlayerObservers()
    }
    
    override func layoutSubviews() {
        progressBarView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(8)
            make.trailing.equalToSuperview().multipliedBy(0.58)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.top.equalTo(progressBarView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(24)
        }
        
        currentSongLabel.snp.makeConstraints { make in
            make.centerY.equalTo(playPauseButton)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupPlayerObservers() {
        let notificationName = NSNotification.Name(PLAYER_STATE_UPDATE_NOTIFICATION)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayer), name: notificationName, object: nil)
    }
    
    @objc func updatePlayer(notification: NSNotification) {
        guard let state = Player.shared.playerState else {
            return
        }
        
        currentSongLabel.attributedText = createPlayerText(track: state.track)
        playPauseButton.setImage(UIImage(named: (state.isPaused ? "play-icon" : "pause-icon")), for: .normal)
    }
    
    @objc func playPauseButtonPressed() {
        Player.shared.pauseResumeTrack()
    }
    
    func createPlayerText(track: SPTAppRemoteTrack) -> NSMutableAttributedString {
        let name = track.name
        let attrString = NSMutableAttributedString(string: "\(name) ", attributes: [
            NSAttributedString.Key.strokeColor: UIColor.black
            ])
        
        let artist = track.artist.name
        attrString.append(NSAttributedString(string: "• \(artist)", attributes: [
            NSAttributedString.Key.strokeColor : UIColor.gray
            ]))
        
        return attrString
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
