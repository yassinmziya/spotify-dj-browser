//
//  AudioFeatures.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/14/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation

struct AudioFeatures: Codable {
    var acousticness: Float
    var analysis_url: String
    var danceability: Float
    var duration_ms: Int
    var energy: Float
    var id: String
    var instrumentalness: Float
    var key: Int
    var liveness: Float
    var loudness: Float
    var mode: Int
    var speechiness: Float
    var tempo: Float
    var time_signature: Int
    var track_href: String
    var type: String
    var uri: String
    var valence: Float
}
