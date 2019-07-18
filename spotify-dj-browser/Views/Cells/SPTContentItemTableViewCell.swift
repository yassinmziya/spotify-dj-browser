//
//  SPTContentItemTableViewCell.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/16/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

protocol SPTContentItemTableViewCellDelegate {
    func cacheItemImage(id: String, image: UIImage)
}

class SPTContentItemTableViewCell: UITableViewCell {

    static let reuseId = "SPTContentItemTableViewCell"
    var delegate: SPTContentItemTableViewCellDelegate!
    
    var item: SPTAppRemoteContentItem! {
        didSet {
            Networking.shared.getImage(item: item, dimensions: CGSize(width: 100, height: 100)) { image in
                self.delegate.cacheItemImage(id: self.item.uri, image: image)
                self.itemImageView.image = image
            }
            
            itemTitleLabel.text = item.title
        }
    }
    
    var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(itemImageView)
        addSubview(itemTitleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemImageView.snp.makeConstraints { make in
            make.height.width.equalTo(self.snp.height).offset(-8)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        itemTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImageView.snp.trailing).offset(8)
            make.centerY.equalTo(itemImageView).offset(-4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
