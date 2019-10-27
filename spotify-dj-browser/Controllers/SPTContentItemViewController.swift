//
//  MyLibraryViewController.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/16/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class SPTContentItemViewController: UIViewController {

    var sptContentItem: SPTAppRemoteContentItem! {
        didSet {
            loadData()
        }
    }
    
    var sptChildContentItems: [SPTAppRemoteContentItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var imageCache: [String: UIImage] = [:]
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 72
        tableView.tableFooterView = UIView()
        tableView.register(SPTContentItemTableViewCell.self, forCellReuseIdentifier: SPTContentItemTableViewCell.reuseId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupConstraints()
    }
    
    func loadData() {
        Networking.shared.getChildContentItems(of: sptContentItem) { items in
            self.sptChildContentItems = items
        }
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}

extension SPTContentItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sptChildContentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SPTContentItemTableViewCell.reuseId) as! SPTContentItemTableViewCell
        cell.delegate = self
        cell.itemImageView.image = nil
        let item = sptChildContentItems[indexPath.row]
        if let image = imageCache[item.uri] {
            cell.needsLoadImage = false
            cell.itemImageView.image = image
        } else {
            cell.needsLoadImage = true
        }
        cell.item = item
        return cell
    }
    
}

extension SPTContentItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sptChildContentItems[indexPath.row]
        print(item.uri)
        if item.uri.contains("track:") {
            Player.shared.playTrack(track: item)
        } else if item.uri.contains("playlist:") {
            let vc = PlaylistViewController()
            vc.sptContentItem = item
            navigationController?.pushViewController(vc, animated: true)
        } else{
            let vc = SPTContentItemViewController()
            vc.sptContentItem = item
            navigationController?.pushViewController(vc, animated: true)
        
        }
    }
    
}

extension SPTContentItemViewController: SPTContentItemTableViewCellDelegate {
    
    func cacheItemImage(id: String, image: UIImage) {
        imageCache[id] = image
    }
    
}
