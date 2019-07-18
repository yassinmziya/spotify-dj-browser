//
//  Playlist.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/16/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    var description: String
    var href: String
    var id: String
    var name: String
    var `public`: Bool
    var uri: String
}
