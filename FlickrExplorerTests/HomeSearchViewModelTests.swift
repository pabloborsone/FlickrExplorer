//
//  HomeSearchViewModelTests.swift
//  FlickrExplorerTests
//
//  Created by Pablo Borsone on 31/05/24.
//

import Combine
import XCTest

@testable import FlickrExplorer

final class HomeSearchViewModelTests: XCTestCase {
    private var cancellable = Set<AnyCancellable>()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"

        return formatter
    }()

    override func tearDown() {
        super.tearDown()
        cancellable.removeAll()
    }

    @MainActor func testSearchQueryUpdatesHomeItemArrayForExistingTag() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Waiting for items to be set")

        sut.$items
            .dropFirst()
            .sink { items in
                XCTAssertEqual(items.first?.title, "title")
                expectation.fulfill()
            }
            .store(in: &cancellable)

        sut.searchQuery = "tree"

        wait(for: [expectation], timeout: 1)
    }

    @MainActor func testSearchQueryDoesNotUpdateHomeItemArrayIfTagDoesntExist() {
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Waiting for items to be set")

        sut.$items
            .dropFirst()
            .sink { items in
                XCTAssertNil(items.first?.title)
                expectation.fulfill()
            }
            .store(in: &cancellable)

        sut.searchQuery = "randomtag"

        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    private func makeSUT() -> HomeSearchViewModel {
        .init(service: MockAPIService(), dateFormatter: dateFormatter, cancellables: cancellable)
    }
}

final class MockAPIService: APIService {
    func fetch(tag: String) async throws -> [FlickrItem] {
        if tag == "tree" {
            return [.init(title: "title",
                          link: URL(string: "https://google.com")!,
                          media: .init(m: URL(string: "https://google.com")!),
                          dateTaken: .init(),
                          description: "",
                          published: .init(),
                          author: "Pablo Borsone",
                          authorID: "m3",
                          tags: "nature")]
        } else {
            return []
        }
    }
}
