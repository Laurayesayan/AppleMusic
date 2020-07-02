//
//  ViewController.swift
//  AppleMusic
//
//  Created by Лаура Есаян on 13.06.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ArtistsViewController: UIViewController {
    @IBOutlet weak var searcher: UISearchBar!
    @IBOutlet weak var artistsTableView: UITableView!
    
    private let musicRequest = MusicRequest()
    private var artists = MutableObservableArray<Artist>([])
    private var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRequestToSearcher()
        bindArtistsToTableView()
        observeRowSelection()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let albumsViewController = segue.destination as? AlbumsViewController, segue.identifier == "ShowAlbums" {
            if let artistId = sender as? Int {
                albumsViewController.artistId = artistId
            }
        }
    }
    
    // MARK: - Binding
    func observeRowSelection() {
        artistsTableView.reactive.selectedRowIndexPath.observeNext { [weak self] indexPath in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "ShowAlbums", sender: self.artists.value.collection[indexPath.row].artistId)
        }.dispose(in: bag)
    }
    
    func bindArtistsToTableView() {
        artists.bind(to: artistsTableView) { [weak self] (dataSource, indexPath, tableView) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") else { fatalError() }

            if let textLabel = cell.textLabel {
                textLabel.text = dataSource[indexPath.row].artistName
            }
            
            if let self = self {
                let offsetStep = 50
                if tableView.indexPathsForVisibleRows!.last!.row + 1 == self.offset + offsetStep {
                    self.offset += offsetStep
                    self.requestForArtists(artistName: self.searcher.text!)
                }
            }
            
            return cell
        }.dispose(in: bag)
    }
    
    func bindRequestToSearcher() {
        searcher.reactive.text
            .ignoreNils()
            .dropFirst(1)
            .debounce(for: 0.8)
            .observeNext { [weak self] text in
                guard let self = self else { return }
                
                self.artists.removeAll()
                
                if text.count > 0 {
                    self.offset = 0
                    self.requestForArtists(artistName: text)
                }
                
        }.dispose(in: bag)
    }
    
    // MARK: - Request
    func requestForArtists(artistName: String) {
        musicRequest.request(artistName: artistName, entity: "musicArtist", limit: 50, offset: self.offset) { [weak self] (artists: MusicAPIResponse<Artist>) in
            guard let self = self else { return }

            for artist in artists.results {
                self.artists.append(artist)
            }
        }
    }
}
