//
//  Artist.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 13.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

struct Artists: Decodable {
    var results: [Artist]
    
    struct Artist: Decodable {
        var artistName: String
        var artistId: Int
    }
}
