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

class ViewController: UIViewController {
    @IBOutlet weak var searcher: UISearchBar!
    @IBOutlet weak var artistsTableView: UITableView!
    
    var artists = MutableObservableArray<Artists.Artist>([])
    private lazy var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRequestWithSearcher()
        bindArtistsWithTableView()
    }
    
    func bindArtistsWithTableView() {
        artists.bind(to: artistsTableView) { [weak self] (dataSource, indexPath, tableView) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") else { fatalError() }

            if let textLabel = cell.textLabel {
                textLabel.text = dataSource[indexPath.row].artistName
            }
            
            if let self = self {
                if tableView.indexPathsForVisibleRows!.last!.row + 1 == self.offset + 50 {
                    self.offset += 50
                    self.request(artistName: self.searcher.text!)
                }
            }
            
            return cell
        }.dispose(in: bag)
    }
    
    func bindRequestWithSearcher() {
        searcher.reactive.text
            .ignoreNils()
            .debounce(for: 0.8)
            .observeNext { [weak self] text in
                guard let self = self else { return }
                
                self.artists.removeAll()
                
                self.offset = 0
                self.request(artistName: text)
        }.dispose(in: bag)
    }
    
    func request(artistName: String) {
        MusicViewModel().makeRequest(artistName: artistName, offset: self.offset) { [weak self] artists in
            guard let self = self else { return }

            for artist in artists.results {
                self.artists.append(artist)
            }
        }
    }
}
