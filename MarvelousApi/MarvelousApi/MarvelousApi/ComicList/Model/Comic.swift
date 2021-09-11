//
//  Comic.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import Foundation

struct Comic: Codable, Hashable {
    let id: Int?
    let digitalID: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription: String?
    let resultDescription: String?
    let modified: String?
    let isbn: String?
    let upc :String?
    let diamondCode: String?
    let ean: String?
    let issn: String?
    let format: String?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let urls: [Url]?
    let series: SeriesSummary?
    let dates: [ComicDate]?
    let prices: [ComicPrice]?
    let thumbnail: Image?
    let images: [Image]?
    let creators: ItemList?
    let characters: ItemList?
    let stories: ItemList?
    let events: ItemList?
}

struct ItemList: Codable, Hashable {
    let available: Int?
    let collectionURI: String?
    let items: [Item]?
    let returned: Int?
}

struct Item: Codable, Hashable {
    let resourceURI: String?
    let name: String?
    let role: String?
    let type: String?
}

struct ComicDate: Codable, Hashable {
    let type: String?
    let date: String?
}

struct Image: Codable, Hashable {
    let path: String?
    let thumbnailExtension: String?
}

struct ComicPrice: Codable, Hashable {
    let type: String?
    let price: Double?
}

struct SeriesSummary: Codable, Hashable {
    let resourceURI: String?
    let name: String?
}

struct TextObject: Codable, Hashable {
    let type: String?
    let language: String?
    let text: String?
}

struct Url: Codable, Hashable {
    let type: String?
    let url: String?
}
