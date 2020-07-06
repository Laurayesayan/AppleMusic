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

class AlbumsViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    @IBOutlet weak var tracksTableView: UITableView!
    
    private let musicRequest = MusicRequest()
    private var albums = MutableObservableArray<Album>([])
    private var tracks = MutableObservableArray<Track>([])
    var artistId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tracksTableView.tableFooterView = UIView()
        
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
                if let artworkUrl60 = self.albums.value.collection[indexPath.row].artworkUrl60 {
                    let albumImageURL = URL(string: artworkUrl60)
                    cell.albumImageView.kf.setImage(with: albumImageURL)
                }
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
        musicRequest.detailRequest(artistId: artistId, entity: "album", limit: 10) { [weak self] (albums: MusicAPIResponse<Album>) in
            guard let self = self else { return }
            
            for album in albums.results {
                if album.collectionName != nil && album.artworkUrl60 != nil {
                    self.albums.append(album)
                }
            }
        }
    }
    
    func requestForTracks(artistId: Int) {
        musicRequest.detailRequest(artistId: artistId, entity: "song", limit: 10) { [weak self] (tracks: MusicAPIResponse<Track>) in
            guard let self = self else { return }
            for track in tracks.results {
                if track.trackName != nil {
                    self.tracks.append(track)
                }
            }
        }
    }
}

// MARK: - Albums collection view cell class
class AlbumsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
}
