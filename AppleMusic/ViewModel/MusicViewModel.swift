//
//  MusicViewModel.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 14.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

class MusicViewModel {
    func request<ReadType: Decodable> (artistName: String, entity: String, limit: Int, offset: Int = 0, getResult: @escaping (ReadType) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredArtistName = artistName.replacingOccurrences(of: " ", with: "")
            let decoder = JSONDecoder()
            
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(filteredArtistName)&entity=\(entity)&limit=\(limit)&offset=\(offset)") else { return }
    
                guard let jsonData = try? Data(contentsOf: url) else { return }

                guard let artists = try? decoder.decode(ReadType.self, from: jsonData) else { return }
                
                DispatchQueue.main.async {
                    getResult(artists)
                }
        }
    }
}
