//
//  MarvelAPI.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import Foundation
import Combine

protocol ComicProvider {
    func getComics(withOffset offset: Int?, completion: @escaping (ComicsResponse) -> Void)
}

class MarvelAPI: ComicProvider {
    
    let baseURL = "https://gateway.marvel.com"
    let apiKey = "YOUR_API_KEY"
        
    var cancellable: AnyCancellable?
    
    func getComics(withOffset offset: Int?, completion: @escaping (ComicsResponse) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/v1/public/comics")
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map { $0.data }
            .decode(type: ComicsResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { data in
                completion(data)
            })
    }
    
}

struct ComicsResponse: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: ComicsData
}

struct ComicsData: Codable {
    let offset, limit, total, count: Int
    let results: [Comic]
}
