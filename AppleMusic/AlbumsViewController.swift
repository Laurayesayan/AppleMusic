//
//  AlbumsViewController.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 16.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Kingfisher

class AlbumsViewController: UIViewController {
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    private var albums = MutableObservableArray<Albums.Album>([])
    var artistName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestForAlbums(artistName: self.artistName!)
        
        albums.bind(to: albumsCollectionView) { (dataSource, indexPath, collection) -> UICollectionViewCell  in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "AlbumsCell", for: indexPath) as? AlbumsCollectionViewCell else { fatalError() }
            
            let albumImageURL = URL(string: self.albums.value.collection[indexPath.row].artworkUrl60)
            cell.albumImageView.kf.setImage(with: albumImageURL)
            
            return cell
        }.dispose(in: bag)
    
    }

    // MARK: - Request
    
    func requestForAlbums(artistName: String) {
        MusicViewModel().albumsRequest(artistName: artistName) { [weak self] albums in
            guard let self = self else { return }
            
            for album in albums.results {
                print(album.artistName)
                print(album.collectionName)
                self.albums.append(album)
            }
        }
    }
    
}

class AlbumsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
}
