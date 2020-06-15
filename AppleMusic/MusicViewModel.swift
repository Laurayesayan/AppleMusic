//
//  MusicViewModel.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 14.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

class MusicViewModel {
    func makeRequest(artistName: String, offset: Int, getArtists: @escaping (Artists) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredArtistName = artistName.replacingOccurrences(of: " ", with: "")
            let decoder = JSONDecoder()
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(filteredArtistName)&entity=musicArtist&limit=50&offset=\(offset)") else { return }
            guard let jsonData = try? Data(contentsOf: url) else { return }

            guard let artists = try? decoder.decode(Artists.self, from: jsonData) else { return }
            
            DispatchQueue.main.async {
                getArtists(artists)
            }
        }
    }
}
