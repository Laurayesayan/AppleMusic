//
//  Tracks.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 20.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

struct Tracks: Decodable {
    var results: [Track]
    
    struct Track: Decodable {
        var artistName: String
        var trackName: String?
    }
}
