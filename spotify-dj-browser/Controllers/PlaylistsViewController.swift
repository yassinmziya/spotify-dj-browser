//
//  PlaylistsViewController.swift
//  
//
//  Created by Yassin Mziya on 7/4/19.
//

import UIKit
import SnapKit

class PlaylistsViewController: UIViewController {
    
    let playlistsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlaylistsTableViewCell.self, forCellReuseIdentifier: PlaylistsTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(playlistsTableView)
        playlistsTableView.dataSource = self
        
        setupConstraints()
        getData()
    }
    
    func setupConstraints() {
        playlistsTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func getData() {
        Networking.shared.getRootContentItems { contentItems in
            print("RECEIVED")
        }
    }

}

extension PlaylistsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistsTableView.dequeueReusableCell(withIdentifier: PlaylistsTableViewCell.reuseId) as! PlaylistsTableViewCell
        cell.nameLabel.text = "Playlist \(indexPath.row)"
        
        return cell
    }
    
}
