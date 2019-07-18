//
//  PlaylistsTableViewCell.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/4/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit

class PlaylistsTableViewCell: UITableViewCell {
    
    static let reuseId = "PlaylistsTableViewCell"
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Playlist 1"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
