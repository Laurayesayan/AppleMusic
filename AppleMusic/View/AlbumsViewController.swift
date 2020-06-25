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
    @IBOutlet weak var tracksTableView: UITableView!
    
    private var albums = MutableObservableArray<Albums.Album>([])
    private var tracks = MutableObservableArray<Tracks.Track>([])
    var artistId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestForAlbums(artistId: self.artistId!)
        requestForTracks(artistId: self.artistId!)
        
        bindAlbumsToCollectionView()
        bindTracksToTableView()
    }
    
    // MARK: - Binding
    func bindAlbumsToCollectionView() {
        albums.bind(to: albumsCollectionView) { [weak self] (dataSource, indexPath, collection) -> UICollectionViewCell  in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "AlbumsCell", for: indexPath) as? AlbumsCollectionViewCell else { fatalError() }
            
            if let self = self {
                let albumImageURL = URL(string: self.albums.value.collection[indexPath.row].artworkUrl60)
                cell.albumImageView.kf.setImage(with: albumImageURL)
            }
            
            return cell
        }.dispose(in: bag)
    }
    
    func bindTracksToTableView() {
        tracks.bind(to: tracksTableView) { [weak self] (dataSource, indexPath, tableView) -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TracksCell") else { fatalError() }
            
            if let self = self {
                if let title = cell.textLabel, let subtitle = cell.detailTextLabel {
                    title.text = self.tracks.value.collection[indexPath.row].trackName
                    subtitle.text = self.tracks.value.collection[indexPath.row].artistName
                }
            }
            
            return cell
        }.dispose(in: bag)
    }
    
    // MARK: - Requests
    func requestForAlbums(artistId: Int) {
        MusicViewModel().request(artistId: artistId, entity: "album", limit: 10) { [weak self] (albums: Albums) in
            guard let self = self else { return }
            
            for album in albums.results {
                self.albums.append(album)
            }
        }
    }
    
    func requestForTracks(artistId: Int) {
        MusicViewModel().request(artistId: artistId, entity: "song", limit: 10) { [weak self] (tracks: Tracks) in
            guard let self = self else { return }
            for track in tracks.results {
                self.tracks.append(track)
            }
        }
    }
    
}

// MARK: - Albums collection view cell class
class AlbumsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
}
