//
//  MarvelAPI.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import Foundation
import Combine
import CryptoKit

protocol ComicProvider {
    func getComics(withOffset offset: Int?, completion: @escaping (ComicsResponse) -> Void)
}

class MarvelAPI: ComicProvider {
    
    let baseURL = "https://gateway.marvel.com"
    let publicKey = "YOUR_API_KEY"
    let privateKey = "YOUR_API_KEY"
        
    var cancellable: AnyCancellable?
    
    func getComics(withOffset offset: Int?, completion: @escaping (ComicsResponse) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/v1/public/comics")
        let ts = String(Date().timeIntervalSince1970)
        let hash = generateHash(withTimestamp: ts)
        var queryItems = [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash),
        ]
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
    
    private func generateHash(withTimestamp ts: String) -> String {
        let digest = CryptoKit.Insecure.MD5.hash(data: "\(ts)\(privateKey)\(publicKey)".data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
}

struct ComicsResponse: Codable {
    let code: Int?
    let message: String?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: ComicsData?
}

struct ComicsData: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Comic]?
}
