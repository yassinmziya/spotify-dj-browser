//
//  SpotifyManager.swift
//  untitled-spotify-project
//
//  Created by Yassin Mziya on 5/22/20.
//  Copyright © 2020 Yassin Mziya. All rights reserved.
//

class SpotifyManager: NSObject {
    
    private var isPresentingAuthVC = false // TODO: must be a better way to do this
    
    private let SpotifyClientID = "9f2dccb4b70149d392eed1dc954a26ba"
    private let SpotifyRedirectURL = URL(string: "spotify-dj-browser://redirect")!
    
    private lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    private(set) var accessToken: String? {
        get {
            UserDefaults.standard.value(forKey: "SPTAccessToken") as? String
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "SPTAccessToken")
            appRemote.connectionParameters.accessToken = newValue
        }
    }
    
    private(set) lazy var appRemote: SPTAppRemote = {
      let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
      appRemote.connectionParameters.accessToken = accessToken
      appRemote.delegate = self
      return appRemote
    }()
    
    static let shared = SpotifyManager()
    
    private override init() {
        super.init()
    }
}

// MARK: - Public

extension SpotifyManager {
    
    func beginOAuthFlow() {
        appRemote.authorizeAndPlayURI("")
    }
    
    func handleOAuthRedirect(url: URL) -> Bool {
        let parameters = appRemote.authorizationParameters(from: url);
        guard let accessToken = parameters?[SPTAppRemoteAccessTokenKey] else {
            if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
                // Show the error
            }
            return false
        }
        
        self.accessToken = accessToken
        appRemote.connect()
        return true
    }
    
}

// MARK:- SpotifyManager + SPTAppRemoteDelegate

extension SpotifyManager: SPTAppRemoteDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("app remote connection established")
        
        // subsicribe to player state chanages
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        
        // dismiss authVC
        if isPresentingAuthVC {
            let rootVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
            rootVC?.dismiss(animated: true) { [weak self] in self?.isPresentingAuthVC = false }
        }
    }
    
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("app remote connection failed")
        
        // present auth VC
        let rootVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
        rootVC?.present(AuthViewController(), animated: true) { [weak self] in self?.isPresentingAuthVC = true }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("app remote connection lost")
        
        accessToken = nil
        
        let rootVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
        rootVC?.present(AuthViewController(), animated: true) { [weak self] in self?.isPresentingAuthVC = true }
    }
}

// MARK: - SpotifyManager + SPTAppRemotePlayerStateDelegate

extension SpotifyManager: SPTAppRemotePlayerStateDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("app remote player state changed")
        Player.shared.updatePlayerState(newState: playerState)
    }
}
