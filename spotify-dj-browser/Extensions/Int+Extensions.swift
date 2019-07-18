//
//  Int+Extensions.swift
//  spotify-dj-browser
//
//  Created by Yassin Mziya on 7/14/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

extension Int {
    static func intToKey(value: Int) -> String {
        let map = ["C","C#", "D","D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        return map[value % 12]
    }
}
