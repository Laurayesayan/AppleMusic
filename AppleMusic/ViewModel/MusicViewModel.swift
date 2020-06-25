//
//  MusicViewModel.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 14.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

class MusicViewModel {
    func request<ReadType: Decodable> (artistName: String? = nil, artistId: Int? = nil, entity: String, limit: Int, offset: Int = 0, getResult: @escaping (ReadType) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var url: URL!
            var filteredArtistName = ""
            let decoder = JSONDecoder()
            
            if let artistName = artistName {
                filteredArtistName = artistName.replacingOccurrences(of: " ", with: "")
            }
            
            if let artistId = artistId {
                url = URL(string: "https://itunes.apple.com/lookup?id=\(artistId)&entity=\(entity)&limit=\(limit)&offset=\(offset)")
            } else {
                url = URL(string: "https://itunes.apple.com/search?term=\(filteredArtistName)&entity=\(entity)&limit=\(limit)&offset=\(offset)")
            }
            
            if let url = url {
                guard let jsonData = try? Data(contentsOf: url) else { return }

                guard let result = try? decoder.decode(ReadType.self, from: jsonData) else { return }
                
                DispatchQueue.main.async {
                    getResult(result)
                }
            }
        }
    }
}
