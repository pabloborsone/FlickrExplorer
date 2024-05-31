//
//  FlickrFeedServiceTests.swift
//  FlickrExplorerTests
//
//  Created by Pablo Borsone on 31/05/24.
//

import XCTest

@testable import FlickrExplorer

final class FlickrFeedServiceTests: XCTestCase {

    let response = """
    {
      "title": "Recent Uploads tagged porcupine",
      "link": "https://www.flickr.com/photos/tags/porcupine/",
      "description": "",
      "modified": "2024-05-30T22:05:40Z",
      "generator": "https://www.flickr.com",
      "items": [
        {
          "title": "Porcupine",
          "link": "https://www.flickr.com/photos/photosbyblackwolf/53758695904/",
          "media": {
            "m": "https://live.staticflickr.com/65535/53758695904_4954b2d59f_m.jpg"
          },
          "date_taken": "2024-05-12T20:04:05-08:00",
          "description": "<p><a href=\\"https://www.flickr.com/people/photosbyblackwolf/\\">Dan King Alaskan Photography</a> posted a photo:</p><p><a href=\\"https://www.flickr.com/photos/photosbyblackwolf/53758695904/\\" title=\\"Porcupine\\"><img src=\\"https://live.staticflickr.com/65535/53758695904_4954b2d59f_m.jpg\\" width=\\"240\\" height=\\"160\\" alt=\\"Porcupine\\" /></a></p><p>This spring, my wife and I have seen an abundance of porcupines. Usually, we may see one or two all year long, in the last week, we have seen 6 different porcupines. (One walked through our yard, of course, I was at work but my wife got a good video of it.)<br />This porcupine was spotted near Wrangell St. Elias National Park. If it wasn't for this porcupine, and one other I photographed later in the day, we would not have seen any wildlife.</p>",
          "published": "2024-05-30T22:05:40Z",
          "author": "nobody@flickr.com (\\"Dan King Alaskan Photography\\")",
          "author_id": "9887740@N02",
          "tags": "porcupine erethizondorsatum rodent wildlife wilderness protectwildlife preservewilderness wrangellsteliasnationalpark alaska canon80d sigma150600mm dankingalaskanphotographycom"
        },
        {
          "title": "Another Porcupine",
          "link": "https://www.flickr.com/photos/photosbyblackwolf/53758695905/",
          "media": {
            "m": "https://live.staticflickr.com/65535/53758695905_4954b2d59f_m.jpg"
          },
          "date_taken": "2024-05-13T10:14:05-08:00",
          "description": "<p><a href=\\"https://www.flickr.com/people/photosbyblackwolf/\\">Dan King Alaskan Photography</a> posted another photo:</p><p><a href=\\"https://www.flickr.com/photos/photosbyblackwolf/53758695905/\\" title=\\"Another Porcupine\\"><img src=\\"https://live.staticflickr.com/65535/53758695905_4954b2d59f_m.jpg\\" width=\\"240\\" height=\\"160\\" alt=\\"Another Porcupine\\" /></a></p><p>We have seen yet another porcupine near the park. This is truly the year of the porcupine sightings!</p>",
          "published": "2024-05-31T22:05:40Z",
          "author": "nobody@flickr.com (\\"Dan King Alaskan Photography\\")",
          "author_id": "9887740@N02",
          "tags": "porcupine wildlife alaska"
        }
      ]
    }
    """


    func testStatusCode200FetchesFeedItemsSuccessfully() async throws {
        let sut = makeSUT()
        let expectedData = response.data(using: .utf8)!

        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=porcupine")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, expectedData)
        }

        let items = try await sut.fetch(tag: "porcupine")
        XCTAssertEqual(items.first?.title, "Porcupine")
    }

    private func makeSUT() -> FlickrFeedService {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return .init(decoder: decoder, session: mockSession)
    }
}
