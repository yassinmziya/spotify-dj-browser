//
//  AuthViewController.swift
//  
//
//  Created by Yassin Mziya on 7/3/19.
//

import UIKit

class AuthViewController: UIViewController {

    var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login With Spotify", for: .normal)
        btn.setTitleShadowColor(.green, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(loginButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            ])
    }
    
    @objc func loginButtonPressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let requestedScopes: SPTScope = [.appRemoteControl, .playlistModifyPrivate, .playlistModifyPublic, .streaming]
        appDelegate.sessionManager.initiateSession(with: requestedScopes, options: .default)
    }

}
