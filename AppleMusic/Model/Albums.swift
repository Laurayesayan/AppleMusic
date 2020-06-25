//
//  Albums.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 16.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

struct Albums: Decodable {
    var results: [Album]
    
    struct Album: Decodable {
        var artistName: String
        var collectionName: String?
        var artworkUrl60: String?
    }
}
