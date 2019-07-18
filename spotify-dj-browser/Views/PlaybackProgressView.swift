//
//  PlaybackProgressView.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/8/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class PlaybackProgressView: UIView {

    let barHeight = 6
    
    var barView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var curTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "1:24"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var trackLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "3:42"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(barView)
        addSubview(progressView)
        addSubview(curTimeLabel)
        addSubview(trackLengthLabel)
    }
    
    override func layoutSubviews() {
        barView.snp.makeConstraints { make in
            make.top.centerX.width.equalToSuperview()
            make.height.equalTo(barHeight)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.leading.height.equalTo(barView)
            make.width.equalTo(barView).multipliedBy(0.34)
        }
        
        curTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(barView)
            make.top.equalTo(barView.snp.bottom).offset(4)
        }
        
        trackLengthLabel.snp.makeConstraints { make in
            make.trailing.equalTo(barView)
            make.top.equalTo(curTimeLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
