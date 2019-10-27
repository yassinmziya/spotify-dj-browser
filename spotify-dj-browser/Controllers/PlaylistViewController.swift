//
//  PlaylistViewController.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/20/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation
import UIKit

class PlaylistViewController: SPTContentItemViewController {
    
    var playlistArtworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(playlistArtworkImageView)
        playlistArtworkImageView.image = imageCache[sptContentItem.uri]
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupConstraints()
    }
    
    override func loadData() {
        super.loadData()
        
        Networking.shared.getImage(item: sptContentItem, dimensions: CGSize(width: 500, height: 500)) { image in
            self.playlistArtworkImageView.image = image
        }
    }
    
    override func setupConstraints() {
        playlistArtworkImageView.snp.makeConstraints { make in
            make.height.width.equalTo(144)
            make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(playlistArtworkImageView.snp.bottom).offset(24)
            make.leading.equalTo(playlistArtworkImageView)
            make.trailing.bottom.equalToSuperview()
            
            
        }
    }
    
}
