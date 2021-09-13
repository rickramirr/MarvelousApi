//
//  ComicListViewModel.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import Foundation
import Combine

class ComicListViewModel {
    
    let comicProvider: ComicService
    
    @Published var comics = [Comic]()
    
    @Published var isLoading = false
    
    @Published var error: String? = nil
    
    var total: Int = 0
    
    init(comicProvider: ComicService = MarvelAPI()) {
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
        comicProvider.getComics(withOffset: comics.count) { data, error  in
            if let error = error {
                self.error = error.localizedDescription
                self.isLoading = false
                return
            }
            guard let comics = data?.data?.results,
                  let total = data?.data?.total
                else {
                return
            }
            self.comics.append(contentsOf: comics)
            self.total = total
            self.isLoading = false
        }
    }
    
}
