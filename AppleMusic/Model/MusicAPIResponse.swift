//
//  Albums.swift
//  MusicAPIResponse
//
//  Created by Лаура Есаян on 16.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

struct MusicAPIResponse<T: Decodable>: Decodable {
    var results: [T]
}

struct Artist: Decodable {
    var artistName: String
    var artistId: Int
}

struct Album: Decodable {
    var artistName: String
    var collectionName: String?
    var artworkUrl60: String?
}

struct Track: Decodable {
    var artistName: String
    var trackName: String?
}
