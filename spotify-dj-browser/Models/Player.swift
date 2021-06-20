//
//  Player.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/8/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation


let PLAYER_STATE_UPDATE_NOTIFICATION = "yassinmziya.spotify-dj-browser.player-state-change"

class Player {
    
    static let shared = Player()
    var playerState: SPTAppRemotePlayerState?
    var audioFeatures: AudioFeatures?
    
    private init() { }
    
    func updatePlayerState(newState: SPTAppRemotePlayerState?) {
        playerState = newState
        if let trackId = Player.shared.getTrackID() {
            Networking.shared.getAudioFeatures(trackId: trackId) { audioFeatures in
                self.audioFeatures = audioFeatures
                
                // POST UPDATE NOTIFICATION
                let notificationName = NSNotification.Name(PLAYER_STATE_UPDATE_NOTIFICATION)
                NotificationCenter.default.post(name: notificationName, object: nil)
                print("[PLAYER] notification posted")
            }
        }
    }
    
    func getTrackID() -> String? {
        guard let playerState = playerState else {
            return nil
        }
        
        let uri = playerState.track.uri
        if let lastColon = uri.lastIndex(of: ":") {
            let fromIndex = uri.index(lastColon, offsetBy: 1)
            return String(uri[fromIndex...])
        }
        return nil
    }
    
    func skipTrack() {
        SpotifyManager.shared.appRemote.playerAPI?.skip(toNext: nil)
    }
    
    func prevTrack() {
        SpotifyManager.shared.appRemote.playerAPI?.skip(toPrevious: nil)
    }
    
    func pauseResumeTrack() {
        guard let playerState = Player.shared.playerState else {
            return
        }
        
        let appRemote = SpotifyManager.shared.appRemote
        
        if playerState.isPaused {
            appRemote.playerAPI?.resume({ (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
        } else {
            appRemote.playerAPI?.pause({ (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
        }
    }
    
    func playTrack(track: SPTAppRemoteContentItem) {
        let appRemote = SpotifyManager.shared.appRemote
        
        appRemote.playerAPI?.play(track, callback: nil)
    }
}
