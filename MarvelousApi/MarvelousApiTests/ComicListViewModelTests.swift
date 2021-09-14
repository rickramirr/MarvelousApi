//
//  ComicListViewModelTests.swift
//  MarvelousApiTests
//
//  Created by Ricardo Ramirez on 13/09/21.
//

@testable import MarvelousApi
import XCTest

class ComicListViewModelTests: XCTestCase {
    
    var sut: ComicListViewModel!
    
    var mockService: MockComicService!
    
    override func setUp() {
        super.setUp()
        mockService = MockComicService()
        sut = ComicListViewModel(comicProvider: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_loading_when_fetching() {
        // when
        sut.getComicsIfNeeded()
        
        // assert
        XCTAssertTrue(sut.isLoading)
    }
    
    func test_finish_loading_after_fetch() {
        // when
        sut.getComicsIfNeeded()
        mockService.triggerError()
        
        // assert
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_error_on_failed_fetch() {
        // when
        sut.getComicsIfNeeded()
        mockService.triggerError()
        
        // assert
        XCTAssertNotNil(sut.error)
    }
    
    func test_comics_on_success_fetch() {
        // when
        mockService.comics = ComicStubGenerator().stubComicResponse(comicCount: 10)
        sut.getComicsIfNeeded()
        mockService.triggerSuccess()
        
        // assert
        XCTAssertEqual(sut.comics.count, 10)
    }
    
    func test_add_comics_to_existent() {
        // when
        let stubGenerator = ComicStubGenerator()
        sut.comics = stubGenerator.stubComics(comicCount: 10)
        sut.total = 100
        mockService.comics = stubGenerator.stubComicResponse(comicCount: 10)
        sut.getComicsIfNeeded()
        mockService.triggerSuccess()
        
        // assert
        XCTAssertEqual(sut.comics.count, 20)
    }

}

class MockComicService: ComicService {
    
    var comics: ComicsResponse?
    
    var completion: ((ComicsResponse?, Error?) -> Void)!
    
    func getComics(withOffset offset: Int?, completion: @escaping (ComicsResponse?, Error?) -> Void) {
        self.completion = completion
    }
    
    func triggerSuccess() {
        completion(comics, nil)
    }
    
    func triggerError() {
        completion(nil, NSError(domain: "", code: -1, userInfo: nil))
    }
    
}

class ComicStubGenerator {
    
    func stubComicResponse(comicCount: Int) -> ComicsResponse {
        return ComicsResponse(
            code: nil,
            message: nil,
            status: nil,
            copyright: nil,
            attributionText: nil,
            attributionHTML: nil,
            etag: nil,
            data: ComicsData(
                offset: 0,
                limit: 20,
                total: 100000,
                count: comicCount,
                results: stubComics(comicCount: comicCount)
            )
        )
    }
    
    func stubComics(comicCount: Int) -> [Comic] {
        var comics = [Comic]()
        for index in 0..<comicCount {
            comics.append(
                Comic(
                    id: index,
                    digitalID: nil,
                    title: UUID().uuidString,
                    issueNumber: nil,
                    variantDescription: nil,
                    description: UUID().uuidString,
                    modified: nil,
                    isbn: UUID().uuidString,
                    upc: nil,
                    diamondCode: nil,
                    ean: nil,
                    issn: nil,
                    format: nil,
                    pageCount: nil,
                    textObjects: nil,
                    resourceURI: nil,
                    urls: nil,
                    series: nil,
                    dates: nil,
                    prices: nil,
                    thumbnail: nil,
                    images: nil,
                    creators: nil,
                    characters: nil,
                    stories: nil,
                    events: nil
                )
            )
        }
        return comics
    }
    
}
