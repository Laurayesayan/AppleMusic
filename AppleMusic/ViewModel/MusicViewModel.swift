//
//  MusicViewModel.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 14.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

class MusicViewModel {
    func artistsRequest(artistName: String, offset: Int, getArtists: @escaping (Artists) -> Void) {
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
    
    func albumsRequest(artistName: String, getAlbums: @escaping (Albums) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredArtistName = artistName.replacingOccurrences(of: " ", with: "")
            let decoder = JSONDecoder()
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(filteredArtistName)&entity=album&limit=10") else { return }
            guard let jsonData = try? Data(contentsOf: url) else { return }

            guard let albums = try? decoder.decode(Albums.self, from: jsonData) else { return }

            DispatchQueue.main.async {
                getAlbums(albums)
            }
        }
    }
    
    func tracksRequest(artistName: String, getTracks: @escaping (Tracks) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredArtistName = artistName.replacingOccurrences(of: " ", with: "")
            let decoder = JSONDecoder()
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(filteredArtistName)&entity=musicTrack&limit=10") else { return }
            guard let jsonData = try? Data(contentsOf: url) else { return }

            guard let tracks = try? decoder.decode(Tracks.self, from: jsonData) else { return }

            DispatchQueue.main.async {
                getTracks(tracks)
            }
        }
    }
}
