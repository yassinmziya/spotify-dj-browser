//
//  TabBarController.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/14/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var collapsedPlayerView = CollapsedPlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        
        view.addSubview(collapsedPlayerView)
        
        collapsedPlayerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
            make.height.equalTo(48)
        }
        collapsedPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerTapped)))
        
        setupTabs()
    }
    
    @objc func playerTapped(recognizer: UITapGestureRecognizer) {
        // let playerVC = PlayerViewController()
        self.present(PlayerViewController(), animated: true, completion: nil)
    }
    
    func setupTabs() {
        Networking.shared.getRootContentItems { (contentItems) in
            var tabs: [UIViewController] = []
            for item in contentItems {
                switch item.title {
                case "Your Library":
                    let vc = SPTContentItemViewController()
                    vc.sptContentItem = item
                    vc.tabBarItem = UITabBarItem(title: item.title, image: nil, selectedImage: nil)
                    tabs.append(UINavigationController(rootViewController: vc))
                default:
                    let vc = PlaylistsViewController()
                    vc.tabBarItem = UITabBarItem(title: item.title, image: nil, selectedImage: nil)
                    tabs.append(vc)
                }
            }
            
            self.viewControllers = tabs
        }
    }

}
