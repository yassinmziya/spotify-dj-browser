//
//  AppDelegate.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/3/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit

let SPTSESSION_DATA_UD_KEY = "yassinmziya.spotify-dj-browser.user_defaults_session_data"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // APPLICATION VARS
    var window: UIWindow?

    // AUTH VARS
    let SpotifyClientID = "4e690c986ef04d50b8b39c461e799592"
    let SpotifyRedirectURL = URL(string: "spotify-dj-browser://spotify-login-callback")!
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://spotify-dj-browser.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://spotify-dj-browser.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    // SPOTIFY APPREMOTE VARS
    lazy var spotifyAppRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let defaults = UserDefaults.standard
        guard let encodedSession = defaults.object(forKey: SPTSESSION_DATA_UD_KEY) as? Data, let decodedSession = NSKeyedUnarchiver.unarchiveObject(with: encodedSession) as? SPTSession  else {
            window?.rootViewController = AuthViewController()
            return true
        }
                
        self.sessionManager.session = decodedSession
        self.sessionManager.renewSession()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = self.spotifyAppRemote.connectionParameters.accessToken {
            self.spotifyAppRemote.connect()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if self.spotifyAppRemote.isConnected {
            self.spotifyAppRemote.disconnect()
        }
    }
    
}

// MARK:- SPTSessionManagerDelegate
extension AppDelegate: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
        
//        // save session in user defaults
//        let defaults = UserDefaults.standard
//        let encodedSessionData = NSKeyedArchiver.archivedData(withRootObject: session)
//        defaults.set(encodedSessionData, forKey: SPTSESSION_DATA_UD_KEY)
//        defaults.synchronize()
        
        // configure app remote
        self.spotifyAppRemote.connectionParameters.accessToken = session.accessToken
        self.spotifyAppRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
}

// MARK: SPTAppRemoteDelegate
extension AppDelegate: SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("[APPDELEGATE] app remote connection established")
        
        // subsicribe to player state chanages
        self.spotifyAppRemote.playerAPI?.delegate = self
        self.spotifyAppRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            // switch views
            DispatchQueue.main.async {
                self.window?.rootViewController = TabBarController()
            }
            
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("[APPDELEGATE] app remote disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("[APPDELEGATE] app remote connection failed")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("[APPDELEGATE] player state changed")
        Player.shared.updatePlayerState(newState: playerState)
    }
    
}
