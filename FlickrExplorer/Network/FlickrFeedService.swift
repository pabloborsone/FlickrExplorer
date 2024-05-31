//
//  FlickrFeedService.swift
//  FlickrExplorer
//
//  Created by Pablo Borsone on 31/05/24.
//

import Foundation

final class FlickrFeedService: APIService {
    private let decoder: JSONDecoder
    private let session: URLSession

    private let baseURL = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne")!

    init(decoder: JSONDecoder, session: URLSession = .shared) {
        self.decoder = decoder
        self.session = session
    }

    func fetch(tag: String) async throws -> [FlickrItem] {
        let requestURL = buildURL(for: tag)
        let request = URLRequest(url: requestURL)

        let (data, _) = try await session.data(for: request)
        let feed = try decoder.decode(FlickrFeed.self, from: data)
        return feed.items
    }

    private func buildURL(for tag: String) -> URL {
        baseURL.appending(queryItems: [URLQueryItem(name: "format", value: "json"),
                                       URLQueryItem(name: "nojsoncallback", value: "1"),
                                       URLQueryItem(name: "tags", value: tag)])
    }
}
