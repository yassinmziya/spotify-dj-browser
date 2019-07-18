//
//  Networking.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/5/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    // MARK:- SINGLETON PATTERN
    static let shared = Networking()
    let baseURL = "https://api.spotify.com/v1"
    
    private init() {}
    
    // MARK:- CLASS WIDE HELPERS
    private func getAccessToken() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.sessionManager.session?.accessToken ?? ""
    }
    
    // MARK:- NETWORK INTERACTIONS
    func getAudioFeatures(trackId: String, completion: @escaping(AudioFeatures) -> Void) {
        let accessToken = getAccessToken()
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)"
        ]
        Alamofire.request("\(baseURL)/audio-features/\(trackId)", headers: headers).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                let decoder = JSONDecoder()
                if let audioFeatures = try? decoder.decode(AudioFeatures.self, from: data) {
                    // print(audioFeatures)
                    completion(audioFeatures)
                } else {
                    print("[NETWORKING] error decoding")
                }
            }
        }
    }
    
    func getPlaylist(playlistId: String, completion: @escaping () -> Void) {
        let accessToken = getAccessToken()
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)"
        ]
        Alamofire.request("\(baseURL)/playlists/\(playlistId)", headers: headers).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                let decoder = JSONDecoder()
                if let playlist = try? decoder.decode(Playlist.self, from: data) {
                    print("[NETWORKING] \(playlist)")
                } else {
                    print("[NETWORKING] error decoding")
                }
            }
        }
    }
    
    func getImage(item: SPTAppRemoteImageRepresentable, dimensions: CGSize,  completion: @escaping (UIImage) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appRemote = appDelegate.spotifyAppRemote
        appRemote.imageAPI?.fetchImage(forItem: item, with: dimensions, callback: { (image, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(image as! UIImage)
        })
    }
    
    func getRootContentItems(completion: @escaping ([SPTAppRemoteContentItem]) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appRemote = appDelegate.spotifyAppRemote
        
        appRemote.contentAPI?.fetchRootContentItems(forType: SPTAppRemoteContentTypeDefault, callback: { (items, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let contentItems = items as? [SPTAppRemoteContentItem] {
                completion(contentItems)
            }
        })
    }
    
    func getChildContentItems(of item: SPTAppRemoteContentItem, completion: @escaping ([SPTAppRemoteContentItem]) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appRemote = appDelegate.spotifyAppRemote
        
        appRemote.contentAPI?.fetchChildren(of: item, callback: { (items, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let contentItems = items as? [SPTAppRemoteContentItem] {
                completion(contentItems)
            }
        })
    }
    
}
