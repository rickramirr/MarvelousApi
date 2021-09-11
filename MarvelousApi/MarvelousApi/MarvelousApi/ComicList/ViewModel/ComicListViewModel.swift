//
//  ComicListViewModel.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import Foundation
import Combine

class ComicListViewModel {
    
    let comicProvider: ComicProvider
    
    @Published var comics = [Comic]()
    
    @Published var isLoading = false
    
    var total: Int = 0
    
    init(comicProvider: ComicProvider = MarvelAPI()) {
        self.comicProvider = comicProvider
    }
    
    func getComicsIfNeeded() {
        guard !isLoading else {
            return
        }
        if comics.count == 0 || comics.count < total {
            requestComics()
        }
    }
    
    func requestComics() {
        isLoading = true
        comicProvider.getComics(withOffset: comics.count) { response in
            self.comics.append(contentsOf: response.data.results)
            self.total = response.data.total
            self.isLoading = false
        }
    }
    
}
