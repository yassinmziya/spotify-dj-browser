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
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        
//        let defaults = UserDefaults.standard
//        guard let encodedSession = defaults.object(forKey: SPTSESSION_DATA_UD_KEY) as? Data, let decodedSession = NSKeyedUnarchiver.unarchiveObject(with: encodedSession) as? SPTSession  else {
//            window?.rootViewController = AuthViewController()
//            return true
//        }
//
//        self.sessionManager.session = decodedSession
//        SpotifyManager.shared.sessionManager.renewSession()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SpotifyManager.shared.handleOAuthRedirect(url: url)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = SpotifyManager.shared.appRemote.connectionParameters.accessToken {
            SpotifyManager.shared.appRemote.connect()
        } else {
            window?.rootViewController?.present(AuthViewController(), animated: true, completion: nil)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if SpotifyManager.shared.appRemote.isConnected {
            SpotifyManager.shared.appRemote.disconnect()
        }
    }
}
